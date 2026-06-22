<%@ page contentType="text/html; charset=utf-8"  %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
    Box box = HttpUtility.getBox(request);

    Log.act.info("box= " + box.toString());

    TrxContext trx = null;

    JPreparedStatement pstmt = null;
    int count = 0;

    String act = box.get("act");
    String objs = box.get("objs");


    String[] sqlMaps = new String[]{

            ""/*
            // ECR_SQL
         ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_sql t set sql_sql = replace(sql_sql, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where sql_sql like '% ' || ? || '%' and sql_sql is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_sql t set sql_sql = replace(sql_sql, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where sql_sql like '%,' || ? || '%' and sql_sql is not null"

        // ECR_SQL Config
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_sql t set sql_config = replace(sql_config, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where sql_config like '% ' || ? || '%' and sql_config is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_sql t set sql_config = replace(sql_config, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where sql_config like '%,' || ? || '%' and sql_config is not null"

        // ECR_LIST
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_list t set lst_sql = replace(lst_sql, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where lst_sql like '% ' || ? || '%' and lst_sql is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_list t set lst_sql = replace(lst_sql, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where lst_sql like '%,' || ? || '%' and lst_sql is not null"

        // ECR_LIST
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_list t set lst_config = replace(lst_config, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where lst_config like '% ' || ? || '%' and lst_config is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_list t set lst_config = replace(lst_config, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where lst_config like '%,' || ? || '%' and lst_config is not null"
*/
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_list t set lst_sql_args = replace(lst_sql_args, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where lst_sql_args like '% ' || ? || '%' and lst_sql_args is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_list t set lst_sql_args = replace(lst_sql_args, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where lst_sql_args like '%,' || ? || '%' and lst_sql_args is not null"
/*

        // EWF_WORKFLOW -> WOF_SQL_SELECT
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_select = replace(wof_sql_select, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where wof_sql_select like '% ' || ? || '%' and wof_sql_select is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_select = replace(wof_sql_select, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where wof_sql_select like '%,' || ? || '%' and wof_sql_select is not null"

        // EWF_WORKFLOW -> WOF_SQL_FROM
        //update ewf_workflow t set wof_sql_from = replace(wof_sql_from, 'eso_srm', '#{db_owner}' || 'eso_srm') where wof_sql_from like 'eso_srm%';
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_from = replace(wof_sql_from, ?, '' || chr(35)||'{db_owner}' || ?) where wof_sql_from like ? || '%' and wof_sql_from is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_from = replace(wof_sql_from, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where wof_sql_from like '% ' || ? || '%' and wof_sql_from is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_from = replace(wof_sql_from, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where wof_sql_from like '%,' || ? || '%' and wof_sql_from is not null"

        // EWF_WORKFLOW -> wof_sql_items_reg
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_items_reg = replace(wof_sql_items_reg, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where wof_sql_items_reg like '% ' || ? || '%' and wof_sql_items_reg is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_items_reg = replace(wof_sql_items_reg, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where wof_sql_items_reg like '%,' || ? || '%' and wof_sql_items_reg is not null"

        // EWF_WORKFLOW -> wof_sql_items_req
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_items_reg = replace(wof_sql_items_req, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where wof_sql_items_req like '% ' || ? || '%' and wof_sql_items_req is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_items_reg = replace(wof_sql_items_req, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where wof_sql_items_req like '%,' || ? || '%' and wof_sql_items_req is not null"

        // EWF_WORKFLOW -> wof_sql_items_ass
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_items_ass = replace(wof_sql_items_ass, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where wof_sql_items_ass like '% ' || ? || '%' and wof_sql_items_ass is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_items_ass = replace(wof_sql_items_ass, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where wof_sql_items_ass like '%,' || ? || '%' and wof_sql_items_ass is not null"

        // EWF_WORKFLOW -> wof_sql_items_own
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_items_own = replace(wof_sql_items_own, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where wof_sql_items_own like '% ' || ? || '%' and wof_sql_items_own is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_items_own = replace(wof_sql_items_own, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where wof_sql_items_own like '%,' || ? || '%' and wof_sql_items_own is not null"

        // EWF_WORKFLOW -> wof_sql_config
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_config = replace(wof_sql_config, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where wof_sql_config like '% ' || ? || '%' and wof_sql_config is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ewf_workflow t set wof_sql_config = replace(wof_sql_config, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where wof_sql_config like '%,' || ? || '%' and wof_sql_config is not null"

        // Relation
        // RELATION -> RLT_DML_LINK
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_relation t set rlt_dml_link = replace(rlt_dml_link, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where rlt_dml_link like '% ' || ? || '%' and rlt_dml_link is not null"
        // RELATION -> RLT_DML_UNLINK
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_relation t set rlt_dml_unlink = replace(rlt_dml_unlink, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where rlt_dml_unlink like '% ' || ? || '%' and rlt_dml_unlink is not null"
        // RELATION -> RLT_DML_APPLY
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_relation t set rlt_dml_apply = replace(rlt_dml_apply, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where rlt_dml_apply like '% ' || ? || '%' and rlt_dml_apply is not null"

        // Loader
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_loader t set ldr_sql = replace(ldr_sql, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where ldr_sql like '% ' || ? || '%' and ldr_sql is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_loader t set ldr_sql = replace(ldr_sql, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where ldr_sql like '%,' || ? || '%' and ldr_sql is not null"

        // MPP
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_mapping t set mpp_sql = replace(mpp_sql, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where mpp_sql like '% ' || ? || '%' and mpp_sql is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecr_mapping t set mpp_sql = replace(mpp_sql, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where mpp_sql like '%,' || ? || '%' and mpp_sql is not null"

        // Entity
        ,"update "+GlobalResource.getInstance().getDbOwner()+"efc_entity t set ent_sql = replace(ent_sql, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where ent_sql like '% ' || ? || '%' and ent_sql is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"efc_entity t set ent_sql = replace(ent_sql, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where ent_sql like '%,' || ? || '%' and ent_sql is not null"

        // KPI
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecf_indicator t set ind_calc_sql = replace(ind_calc_sql, ' ' || ?, ' ' || chr(35)||'{db_owner}' || ?) where ind_calc_sql like '% ' || ? || '%' and ind_calc_sql is not null"
        ,"update "+GlobalResource.getInstance().getDbOwner()+"ecf_indicator t set ind_calc_sql = replace(ind_calc_sql, ',' || ?, ',' || chr(35)||'{db_owner}' || ?) where ind_calc_sql like '%,' || ? || '%' and ind_calc_sql is not null"
*/

    };



%>
<%
    if("".equals(objs)) {
        objs = "ebd_bbs"
                +"\nebd_comment"
                +"\nebd_config"
                +"\nebd_ebs_file"
                +"\necc_dash_das"
                +"\necc_dataset"
                +"\necc_datasource"
                +"\necc_dip"
                +"\necc_dip_history"
                +"\necc_dsr_file"
                +"\necc_rawdata"
                +"\necf_aas_history"
                +"\necf_autoassign"
                +"\necf_code"
                +"\necf_code_type"
                +"\necf_cod_acp"
                +"\necf_contract"
                +"\necf_ctr_file"
                +"\necf_ctr_goal"
                +"\necf_ctr_history"
                +"\necf_ctr_ind"
                +"\necf_ctr_svc"
                +"\necf_ctr_svg"
                +"\necf_datr"
                +"\necf_datr_temp"
                +"\necf_dci"
                +"\necf_dci_attrib"
                +"\necf_dept"
                +"\necf_division"
                +"\necf_doc"
                +"\necf_doctype"
                +"\necf_doc_fav"
                +"\necf_drct"
                +"\necf_drct_attrib"
                +"\necf_employee"
                +"\necf_emp_alarm"
                +"\necf_emp_apprgroup"
                +"\necf_emp_apprline"
                +"\necf_emp_link"
                +"\necf_emp_system"
                +"\necf_file_file"
                +"\necf_holiday"
                +"\necf_image"
                +"\necf_indicator"
                +"\necf_ind_custom"
                +"\necf_ind_das"
                +"\necf_ind_history"
                +"\necf_member"
                +"\necf_menu"
                +"\necf_metrics"
                +"\necf_met_history"
                +"\necf_mtn"
                +"\necf_mto"
                +"\necf_org"
                +"\necf_org_history"
                +"\necf_perspective"
                +"\necf_pmswbs"
                +"\necf_pmswbs_attrib"
                +"\necf_position"
                +"\necf_ppt"
                +"\necf_ppt_file"
                +"\necf_pridept"
                +"\necf_proc"
                +"\necf_psd"
                +"\necf_psd_file"
                +"\necf_psp_history"
                +"\necf_pwbs_file"
                +"\necf_role"
                +"\necf_role_menu"
                +"\necf_service"
                +"\necf_sms"
                +"\necf_svcgroup"
                +"\necf_svc_custom"
                +"\necf_svc_history"
                +"\necf_svc_ind"
                +"\necf_targettime"
                +"\necf_tcm"
                +"\necf_tcm_file"
                +"\necf_term"
                +"\necf_tsm"
                +"\necf_tsm_file"
                +"\necf_tsm_tcm"
                +"\necf_user_role"
                +"\necf_usr_history"
                +"\necf_wog_history"
                +"\necf_workgroup"
                +"\necr_content"
                +"\necr_form"
                +"\necr_frm_choice"
                +"\necr_frm_field"
                +"\necr_frm_group"
                +"\necr_frm_set"
                +"\necr_frm_ui"
                +"\necr_help"
                +"\necr_json"
                +"\necr_list"
                +"\necr_loader"
                +"\necr_mapping"
                +"\necr_meta"
                +"\necr_pof"
                +"\necr_pof_file"
                +"\necr_prml"
                +"\necr_pti"
                +"\necr_ptu"
                +"\necr_relation"
                +"\necr_sql"
                +"\necr_sql_history"
                +"\necr_text"
                +"\nedm_dash_ola"
                +"\nedm_dash_sla"
                +"\nedm_das_outsrc"
                +"\nedm_total_item"
                +"\nedm_total_ola"
                +"\nedm_total_opm"
                +"\nedm_total_sla"
                +"\nefc_config"
                +"\nefc_doc_sequence"
                +"\nefc_entity"
                +"\nefc_field"
                +"\nefc_fieldtype"
                +"\nefc_sequence"
                +"\nefc_table"
                +"\nefc_template"
                +"\nelb_code"
                +"\nelg_accesslog"
                +"\nelg_batchlog"
                +"\nelg_emailalarm"
                +"\nelg_emaillog"
                +"\nelg_fms_paylog"
                +"\nelg_iflog"
                +"\nelg_loader"
                +"\nelg_login"
                +"\nelg_smslog"
                +"\nesd_avm"
                +"\nesd_avm_file"
                +"\nesd_avm_history"
                +"\nesd_avm_wf"
                +"\nesd_cpm"
                +"\nesd_cpm_file"
                +"\nesd_cpm_history"
                +"\nesd_cpm_wf"
                +"\nesd_ctm"
                +"\nesd_ctm_file"
                +"\nesd_ctm_history"
                +"\nesd_ctm_wf"
                +"\nesd_ctr"
                +"\nesd_ctr_file"
                +"\nesd_ctr_history"
                +"\nesd_ctr_wf"
                +"\nesd_isc"
                +"\nesd_iscc"
                +"\nesd_iscl"
                +"\nesd_iscr"
                +"\nesd_isc_file"
                +"\nesd_isc_history"
                +"\nesd_isc_wf"
                +"\nesd_ism"
                +"\nesd_ismr"
                +"\nesd_ismr_file"
                +"\nesd_ismr_history"
                +"\nesd_ismr_wf"
                +"\nesd_ism_file"
                +"\nesd_ism_history"
                +"\nesd_ism_wf"
                +"\nesd_mtc"
                +"\nesd_mtc_attrib"
                +"\nesd_mtc_cm"
                +"\nesd_mtc_file"
                +"\nesd_mtc_history"
                +"\nesd_mtc_wf"
                +"\nesd_ppm"
                +"\nesd_ppm_file"
                +"\nesd_ppm_history"
                +"\nesd_ppm_wf"
                +"\nesd_prm"
                +"\nesd_prm_emp"
                +"\nesd_prm_rslt"
                +"\nesd_prm_wf"
                +"\nesd_scm"
                +"\nesd_scm_file"
                +"\nesd_scm_history"
                +"\nesd_scm_wf"
                +"\nesd_spm"
                +"\nesd_spm_file"
                +"\nesd_spm_history"
                +"\nesd_spm_wf"
                +"\neso_aaa"
                +"\neso_aaa_file"
                +"\neso_aaa_history"
                +"\neso_aaa_wf"
                +"\neso_acc"
                +"\neso_apm"
                +"\neso_apm_file"
                +"\neso_apm_history"
                +"\neso_apm_wf"
                +"\neso_approval"
                +"\neso_appr_item"
                +"\neso_aprl"
                +"\neso_asi"
                +"\neso_bbs"
                +"\neso_bbs_content"
                +"\neso_bbs_file"
                +"\neso_bbs_history"
                +"\neso_bbs_manager"
                +"\neso_bbs_wf"
                +"\neso_cam"
                +"\neso_cam_custom"
                +"\neso_cam_file"
                +"\neso_cam_history"
                +"\neso_cam_relation"
                +"\neso_cam_wf"
                +"\neso_ccc_history"
                +"\neso_cfm"
                +"\neso_cfm_file"
                +"\neso_cfm_history"
                +"\neso_cfm_wf"
                +"\neso_chg"
                +"\neso_chg_file"
                +"\neso_chg_history"
                +"\neso_chg_wf"
                +"\neso_chm"
                +"\neso_chm_cab"
                +"\neso_chm_file"
                +"\neso_chm_history"
                +"\neso_chm_relation"
                +"\neso_chm_wf"
                +"\neso_cm"
                +"\neso_cmm"
                +"\neso_cmm_file"
                +"\neso_cmm_history"
                +"\neso_cmm_wf"
                +"\neso_cm_attrib"
                +"\neso_cm_custom"
                +"\neso_cm_disk"
                +"\neso_cm_file"
                +"\neso_cm_history"
                +"\neso_cm_rel"
                +"\neso_code_attrib"
                +"\neso_cpr"
                +"\neso_cr"
                +"\neso_crm"
                +"\neso_crm_custom"
                +"\neso_dcm"
                +"\neso_dcm_file"
                +"\neso_dcm_history"
                +"\neso_dcm_wf"
                +"\neso_drc"
                +"\neso_drcl"
                +"\neso_drc_attrib"
                +"\neso_ecams_lst"
                +"\neso_ecams_rel"
                +"\neso_edu"
                +"\neso_edu_custom"
                +"\neso_edu_file"
                +"\neso_edu_history"
                +"\neso_eim"
                +"\neso_ibs"
                +"\neso_ibs_file"
                +"\neso_ibs_history"
                +"\neso_ibs_wf"
                +"\neso_icm"
                +"\neso_icm_custom"
                +"\neso_icm_file"
                +"\neso_icm_history"
                +"\neso_icm_relation"
                +"\neso_icm_wf"
                +"\neso_idm"
                +"\neso_idm_file"
                +"\neso_idm_wf"
                +"\neso_ido"
                +"\neso_ido_file"
                +"\neso_inm"
                +"\neso_inm_file"
                +"\neso_inm_history"
                +"\neso_inm_wf"
                +"\neso_inr"
                +"\neso_ins"
                +"\neso_inv_attrib"
                +"\neso_kri"
                +"\neso_meeting"
                +"\neso_mee_file"
                +"\neso_memo"
                +"\neso_memo_file"
                +"\neso_messenger"
                +"\neso_mpi"
                +"\neso_msg_room"
                +"\neso_msg_user"
                +"\neso_ofm"
                +"\neso_ofm_custom"
                +"\neso_ofm_file"
                +"\neso_ofm_history"
                +"\neso_ofm_relation"
                +"\neso_ofm_wf"
                +"\neso_pbm"
                +"\neso_pbm_custom"
                +"\neso_pbm_file"
                +"\neso_pbm_history"
                +"\neso_pbm_relation"
                +"\neso_pbm_wf"
                +"\neso_pdm_aaa"
                +"\neso_pem"
                +"\neso_pem_file"
                +"\neso_pem_history"
                +"\neso_pem_wf"
                +"\neso_pms"
                +"\neso_pms_attrib"
                +"\neso_pms_file"
                +"\neso_pms_history"
                +"\neso_pms_wf"
                +"\neso_psr"
                +"\neso_psr_file"
                +"\neso_pswbs"
                +"\neso_pswbs_attrib"
                +"\neso_pswbs_file"
                +"\neso_pwr"
                +"\neso_pwr_file"
                +"\neso_pwr_history"
                +"\neso_pwr_wf"
                +"\neso_ram"
                +"\neso_ram_file"
                +"\neso_ram_history"
                +"\neso_ram_wf"
                +"\neso_reqform_dtl"
                +"\neso_rim"
                +"\neso_rim_file"
                +"\neso_rim_history"
                +"\neso_rim_wf"
                +"\neso_rkm"
                +"\neso_rkms"
                +"\neso_rkms_file"
                +"\neso_rkms_history"
                +"\neso_rkms_wf"
                +"\neso_rkm_attrib"
                +"\neso_rkm_term"
                +"\neso_rkt_history"
                +"\neso_rkt_wf"
                +"\neso_rom"
                +"\neso_sfd"
                +"\neso_sip"
                +"\neso_sip_ex03"
                +"\neso_sip_file"
                +"\neso_sip_history"
                +"\neso_sip_wf"
                +"\neso_spm_attrib"
                +"\neso_srm"
                +"\neso_srm_attrib"
                +"\neso_srm_custom"
                +"\neso_srm_ex01"
                +"\neso_srm_file"
                +"\neso_srm_history"
                +"\neso_srm_test"
                +"\neso_srm_wf"
                +"\neso_stegw01"
                +"\neso_stegw01_file"
                +"\neso_stegw01_history"
                +"\neso_stegw01_wf"
                +"\neso_svm"
                +"\neso_svm_file"
                +"\neso_svm_history"
                +"\neso_svm_wf"
                +"\neso_tcl"
                +"\neso_template"
                +"\neso_test01"
                +"\neso_test01_file"
                +"\neso_test01_history"
                +"\neso_test01_wf"
                +"\neso_tmp_file"
                +"\neso_tmp_history"
                +"\neso_tmp_relation"
                +"\neso_tmp_wf"
                +"\neso_tst"
                +"\neso_tst_file"
                +"\neso_tst_history"
                +"\neso_tst_wf"
                +"\neso_two"
                +"\neso_two_custom"
                +"\neso_two_file"
                +"\neso_two_history"
                +"\neso_two_wf"
                +"\neso_uam"
                +"\neso_uam_file"
                +"\neso_uam_history"
                +"\neso_uam_wf"
                +"\neso_uit"
                +"\neso_utm"
                +"\neso_utm_file"
                +"\neso_utm_history"
                +"\neso_utm_wf"
                +"\neso_vim"
                +"\neso_vvv"
                +"\neso_vvv_file"
                +"\neso_vvv_history"
                +"\neso_vvv_wf"
                +"\neso_wf_attrhist"
                +"\neso_wf_cm"
                +"\neso_wf_code"
                +"\neso_wf_emps"
                +"\neso_wf_hist"
                +"\neso_wf_reason"
                +"\neso_wf_rel"
                +"\neso_workorder"
                +"\neso_wor_attrib"
                +"\neso_wor_custom"
                +"\neso_wor_file"
                +"\neso_wor_history"
                +"\neso_wor_wf"
                +"\ness_bom"
                +"\ness_bom_file"
                +"\ness_bom_history"
                +"\ness_bom_wf"
                +"\ness_brm"
                +"\ness_brm_file"
                +"\ness_brm_history"
                +"\ness_brm_wf"
                +"\ness_dmm"
                +"\ness_dmm_file"
                +"\ness_dmm_history"
                +"\ness_dmm_wf"
                +"\ness_fcm"
                +"\ness_fcm_file"
                +"\ness_fcm_history"
                +"\ness_fcm_wf"
                +"\ness_pfm"
                +"\ness_pfm_custom"
                +"\ness_pfm_file"
                +"\ness_pfm_history"
                +"\ness_pfm_wf"
                +"\ness_pms"
                +"\ness_stm"
                +"\ness_stm_file"
                +"\ness_stm_history"
                +"\ness_stm_wf"
                +"\nest_alm"
                +"\nest_arm"
                +"\nest_arm_attrib"
                +"\nest_cem"
                +"\nest_cem_file"
                +"\nest_cem_history"
                +"\nest_cem_wf"
                +"\nest_etm"
                +"\nest_etm_attrib"
                +"\nest_etm_file"
                +"\nest_etm_history"
                +"\nest_etm_wf"
                +"\nest_ilm"
                +"\nest_ipm"
                +"\nest_ipm_file"
                +"\nest_ipm_history"
                +"\nest_ipm_wf"
                +"\nest_irm"
                +"\nest_qlm"
                +"\nest_qrm"
                +"\nest_rem"
                +"\nest_rem_file"
                +"\nest_rem_history"
                +"\nest_rem_wf"
                +"\nest_vfm"
                +"\nest_vfm_file"
                +"\nest_vfm_history"
                +"\nest_vfm_wf"
                +"\netb_survey"
                +"\netb_sur_answer_obj"
                +"\netb_sur_answer_sbj"
                +"\netb_sur_quest"
                +"\netb_sur_quest_mapping"
                +"\netb_sur_quest_obj"
                +"\netb_sur_user"
                +"\netemp_apm_ping"
                +"\netemp_cm"
                +"\netemp_cm_fields"
                +"\netemp_loader"
                +"\netemp_psr"
                +"\nets_etr"
                +"\nets_ets"
                +"\nets_etw"
                +"\nets_fp"
                +"\nets_fpi"
                +"\nets_invs"
                +"\nets_template"
                +"\newf_actflow"
                +"\newf_activity"
                +"\newf_atf_act"
                +"\newf_atf_tas"
                +"\newf_bizflow"
                +"\newf_control"
                +"\newf_stamap"
                +"\newf_statflow"
                +"\newf_stfstat"
                +"\newf_sts_tas"
                +"\newf_task"
                +"\newf_wfmap"
                +"\newf_wfm_atf"
                +"\newf_workflow"
                +"\nezt_activity"
                +"\nezt_control"
                +"\nezt_form"
                +"\nezt_frm_field"
                +"\nezt_frm_group"
                +"\nezt_frm_set"
                +"\nezt_frm_ui"
                +"\nezt_task"
                +"\nezt_workflow"
                +"\nezz_sample"
                +"\nzssd_bp"
                +"\nzssd_datamap"
                +"\nzssd_menu"
                +"\nzssd_show"
                +"\nzssd_shw_item"
                +"\nzssd_smboard"
                +"\nzssd_smb_dam"
                +"\nzssd_tempdata"
                +"\nzssd_type"
                +"\nzssd_wgi_templ"
                +"\nzssd_wgt_item"
                +"\nzssd_widget"
                +"\nzssd_witem"

                +"\nvw_universal_entity"
                +"\nvw_workgroup_member"

                +"\n"
                +"\nfm_dur"
                +"\nfm_ldt"
                +"\nfm_ldttm"
                +"\nf_check_dci"
                +"\nf_check_dci_week"
                +"\nf_costid"
                +"\nf_numtodate"
                +"\ngetacp_time"
                +"\ngetbizday"
                +"\ngetcmname"
                +"\ngetcode_fullpath"
                +"\ngetcode_level1name"
                +"\ngetcode_level2name"
                +"\ngetcode_level3name"
                +"\ngetlevel1_sysid"
                +"\ngetlevel1_sysname"
                +"\ngetlevel2_sysid"
                +"\ngetlevel2_sysname"
                +"\ngetproc_time"
                +"\ngetstartym"
                +"\ngettotalbizday"
                +"\nget_chm_sid"
                +"\nget_codename"
                +"\nget_dept"
                +"\nget_dptname"
                +"\nget_dur"
                +"\nget_durmins"
                +"\nget_dursecs"
                +"\nget_empname"
                +"\nget_hsda_sys"
                +"\nget_icm_pri"
                +"\nget_mon"
                +"\nget_mondays"
                +"\nget_monedt"
                +"\nget_monsdt"
                +"\nget_monsecs"
                +"\nget_orgname"
                +"\nget_pcat_id"
                +"\nget_pcat_id2"
                +"\nget_preweek_edt"
                +"\nget_preweek_sdt"
                +"\nget_psys_id"
                +"\nget_psys_id2"
                +"\nget_reject_state"
                +"\nget_srm_pri"
                +"\nget_tasname"
                +"\nget_wog"
                +"\nget_wogname"
                +"\nnextbizday";
    }

    String tables[] = objs.split("\r\n");
%>
<html>

<style>
    .bluetop {
        border-collapse: collapse;
        border-top: 3px solid #168;
    }
    .bluetop th {
        color: #168;
        background: #f0f6f9;
    }
    .bluetop th, .bluetop td {
        padding: 10px;
        border: 1px solid #ddd;
    }
    .bluetop th:first-child, .bluetop td:first-child {
        border-left: 0;
    }
    .bluetop th:last-child, .bluetop td:last-child {
        border-right: 0;
    }
</style>
</html>
<body>
<form id="f" method="post">
    <div>
        * Update 대상 <br>
        - ecr_sql (sql_sql, sql_config) <br>
        - ecr_list (lst_sql, lst_config) <br>
        - ewf_workflow (wof_sql_select, wof_sql_form, wof_sql_items_reg, wof_sql_items_req, wof_sql_items_ass, wof_sql_items_own)
        <br>
        - ecr_relation (rlt_dml_link, rlt_dml_unlink, rlt_dml_apply) <br>
        - ecr_loader (ldr_sql) <br>
        - ecr_mapping (mpp_sql) <br>
        - efc_entity (ent_sql) <br>
        - ecf_indicator (ind_calc_sql) <br>
    </div>
<input id="act" name="act" type="hidden">
<button id="btn" onclick="fnSubmit();">진행</button>
<script type="text/javascript">
    var fnSubmit = function(){
        var f = document.getElementById('f');
        var act = document.getElementById('act');
        act.value = "1";

        f.submit();
    }
</script>
<div>
    <textarea style="width: 100%; height: 200px;" name="objs"><%=objs%></textarea>
</div>
</form>
<% if("1".equals(act)) { %>
<div style="height:500px; overflow: auto">
<table class="bluetop">
    <thead>
        <tr>
            <td>NO</td>
            <td>Object</td>
<%
    int totalSqlCount=0;
    for(String sql : sqlMaps) {
        if("".equals(sql)) continue;
%>
            <td><label title="<%= sql %>"><%= ++totalSqlCount %></label></td>
<%
    }
%>
        </tr>
    </thead>
    <tbody>

<%

try {

    trx = new TrxContext(GlobalConfig.getInstance().getDbName());
    trx.begin();
    int idx = 0;
    for (String table : tables)   {
        idx++;
        if("".equals(table)) continue;

        out.write("<tr>");
        out.write("<td>" + idx + "</td>");
        out.write("<td>" + table +"</td>");
        for(String sql : sqlMaps) {

            if("".equals(sql)) continue;
            count = 0;

            table = table.toLowerCase(Locale.ENGLISH).;
            pstmt = new JPreparedStatement(trx.getConnection(), sql);
            pstmt.setString(1, table);
            pstmt.setString(2, table);
            pstmt.setString(3, table);
            count = pstmt.executeUpdate();
            if(pstmt != null) {pstmt.close();}

            table = table.toUpperCase();
            pstmt = new JPreparedStatement(trx.getConnection(), sql);
            pstmt.setString(1, table);
            pstmt.setString(2, table);
            pstmt.setString(3, table);
            count += pstmt.executeUpdate();
            if(pstmt != null) {pstmt.close();}

            out.write("<td>" + count +"</td>");
        }

        out.write("</tr>");
    }


    out.write("<tr><td colspan=" + (totalSqlCount +2) +"> 정상 종료 </td><tr>");
    trx.commit();

} catch (SQLException e) {
    out.write("<tr><td colspan=2>SQL IndicatorError</td><tr>");
    trx.rollback();
    Log.biz.err(e);

} catch (Exception e) {
    out.write("<tr><td colspan=2>Unknow IndicatorError</td><tr>");
    trx.rollback();
    Log.biz.err(e);

} finally {
    if(pstmt != null) {
        pstmt.close();
    }
    if(trx != null) {
        trx.close();
    }
}

%>
    </tbody>
</table>
</div>
<% } %>
</body>
