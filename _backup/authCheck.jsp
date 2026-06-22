<%--
  Created by IntelliJ IDEA.
  User: jhgo
  Date: 2022-09-19
  Time: 오후 1:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>

<%!
    /**
     * AT
     * @param key
     * @param atf_id
     * @param session
     * @param data
     * @return
     */
    public static boolean checkFormAuthentication(String entId, Row row, String key, String atf_id, HttpSession session, Data data) {
        Entity entity = null;
        User user = null;
        // 엔터티 확인
        if (StringUtil.valid(entId)) {
            entity = ICE.getInstance().map().getEntity(entId);

        }
        // 엔터티 정보 없으면 flase 리턴
        if (entity == null)
            return false;

        // Login User
        user = (User) session.getAttribute("egene.user");

        // 로그인 정보가 없으면 flase 리턴
        if (user == null)
            return false;

        // 관리자에게 워크플로우외 엔터티 권한을 부여

        // 관리자.
        if(user.isAdmin()) {
            return true;
        }
        else if (user.isAdmin() && !Entity.ENTITY_WORKFLOW.equals(entity.type)) {
            return true;
        } else if (Entity.ENTITY_BOARD.equals(entity.type)) {
            // 게시판 타입 엔터티 권한 체크
            // 등록자와 같은지.
            if (user.id.equals(row.get(entity.prefix + "_reg_emp_id"))) {
                return true;
            }

            // 게시판 Admin 여부
            {
                // BBS ADMIN
                String bbsAdminSqlId = "Employee.Role";
                String arrParams[] = new String[1];
                arrParams[0] = user.id;
                Result bbsResutl = ICE.getInstance().sqls().getResult(bbsAdminSqlId, arrParams);
                RecordSet bbsRs = bbsResutl.getRecordSet();
                String FINAL_BBS_ADMIN = "R999";	// BBS Admin Role ID
                String bbsadmin = "";
                while(bbsRs.next()) {
                    if(FINAL_BBS_ADMIN.equals(bbsRs.get("rol_id"))) {
                        bbsadmin = "1";
                    }
                }
                // bbs admin 의 경우.
                if("1".equals(bbsadmin)) return true;
            }
        } else if (Entity.ENTITY_WORKFLOW.equals(entity.type)) {
            // 워크플로우 타입 엔터티 권한 체크
            // Activity Flow ID가 있으면 해당 Activity Flow 권한을 확인하고,
            // Activity Flow id가 없드면 해당 워크플로우의 전체 Activity Flow를 확인한다.
            if (StringUtil.valid(atf_id)) {
                return checkFormAuthentication(key, atf_id, session, data);
            } else {
                // Task id 정보를 이용하여 권한체크 수행
                String tas_id = row.get(entity.prefix + "_tas_id");
                if (StringUtil.valid(tas_id)) {
                    Wfms wfms = Wfms.getInstance();
                    String act_id = wfms.getTask(tas_id).act_id;
                    String wof_id = wfms.getActivity(act_id).wof_id;
                    Workflow workFlow = wfms.getWorkflow(wof_id);

                    List actFlows = workFlow.getActFlows();

                    for(int i = 0; actFlows != null && i < actFlows.size(); i++) {
                        ActFlow actFlow = (ActFlow)actFlows.get(i);
                        // ActFlow중 하나라도 권한이 있으면 권한 획득
                        if (checkFormAuthentication(key, actFlow.id, session, data) == true) {
                            return true;
                        }
                    }
                } else {
                    // 임시저장 상태인경우 등록자에게 권한 부여함
                    if (user.id.equals(row.get(entity.prefix + "_reg_emp_id"))) {
                        return true;
                    }
                }
            }


        }

        return false;

    }


    /**
     * Activity Flow 권한 확인
     * @param key
     * @param atf_id
     * @param session
     * @param data
     * @return
     */
    public static boolean checkFormAuthentication(String key, String atf_id, HttpSession session, Data data) {
        ActFlowBean bean = new ActFlowBean(atf_id);
        return bean.checkAuthentication(session, data, key);
    }
%>