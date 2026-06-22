<%@ page import="com.steg.efc.ICE" %>
<%@ page import="com.steg.efc.EntityMap" %>
<%@ page import="java.util.List" %>
<%@ page import="com.steg.efc.Entity" %>
<%@ page import="org.sdf.log.Log" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="org.apache.commons.lang.ArrayUtils" %>
<%@ page import="com.steg.mgr.ent.EntMgr" %>
<%@ page import="org.sdf.lang.Data" %>
<%@ page import="com.steg.lit.dao.EgeneSqlDao" %>
<%@ page import="java.sql.SQLSyntaxErrorException" %>
<%@ page import="com.steg.efc.Sqls" %>
<%@ page import="java.io.IOException" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
    /**
     * 데이터 초기화
     */

    execClearData(response);

%>
<html lang="en">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1, user-scalable=no">
<link rel="shortcut icon" href="/favicon.ico"><!-- Chrome, Safari, IE -->
<link rel="icon" href="/favicon.png"><!-- Chrome, Safari, IE -->
<link rel="apple-touch-icon-precomposed" href="/favicon.ico"><!-- iphone -->
<meta name="author" content="STEG">
<meta http-equiv="Publisher" content="STEG"/>
<meta name="description" content="eGene Lightning">
<meta name="Keywords" content="egene, itsm, steg, itom"/>
<meta name="Robots" content="noindex, nofollow"/>

<link href="/xplugin/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/xplugin/jquery/jquery-3.7.1.min.js"></script>
<body>
<h1>eGene Data Clearing</h1>


<%!

    // 삭제 기준 Workorder 과 그 외

    void execClearData(HttpServletResponse response) throws IOException {

        // 제외 대상 엔터티
        String[] arrExcludeEnts = new String[] {
                "001" //서비스
                , "002" //서비스그룹
                , "003" //서비스지표
                , "004" //계약
                , "006" //계약-지표
                , "007" //계약-서비스
                , "008" //계약-서비스그룹
                , "009" //데이터셋
                , "010" //데이터소스
                , "012" //지표
                , "013" //메트릭스
                , "014" //Entity Field
                , "015" //필드유형
                , "016" //DataAdapter
                , "017" //사용자
                , "018" //SQL
                , "020" //코드유형
                , "021" //코드
                , "022" //form
                , "023" //회사
                , "024" //부서
                , "025" //직원
                , "026" //권한
                , "027" //메뉴
                , "028" //리스트
                , "030" //권한메뉴
                , "040" //Activity
                , "041" //Task
                , "042" //Workflow
                , "044" //Entity
                , "050" //control
                , "051" //액티비티플로우
                , "052" //워크플로우맵
                , "053" //릴레이션
                , "054" //텍스트
                , "055" //작업그룹
                , "056" //member
                , "061" //Sequence
                , "070" //config
                , "071" //컨텐츠
                , "072" //help
                , "082" //매핑
                , "083" //코드별 결재라인
                , "AAS" //AutoAssign
                , "ASSEMPS" //처리자 배정
                , "ATOM" //ATOM관리
                , "ATOMTMP" //ATOMTMP
                , "BBSCON" //게시판 관리
                , "CA010" //표준지표
                , "CHKD" //점검항목
                , "CM"
                , "CMB"
                , "CMF"
                , "DOC" //개발공정
                , "EMM" //매뉴얼관리
                , "HOD" //휴일관리
                , "JS" //스크립트
                , "LDR" //파일로더
                , "MAG" //메일그룹
                , "MAM" //메일그룹대상자
                , "META" //META INFO
                , "MPI" //수기KPI
                , "MTN"
                , "MTO"
                , "PMSMED" // 프로젝트 표준방법론 pool
                , "PMSPDT" // 프로젝트 표준산출물 pool
                , "PMSSTD" // 프로젝트 방법론-산출물 연결 pool
                , "STEGW01"
                , "TRM" //기수관리
                , "TCM" //테스트케이스POOL
                , "SAS" //[설문조사] 주관식 응답
                , "SQS" //[설문조사] 질문 그룹 관리
                , "SVM" //[설문조사] 설문조사 관리
                , "SVP" //[설문조사] 설문문항 PULL
                , "SVQ" //[설문조사] 질문 관리
                , "SVS" //[설문조사] 객관식 문항 그룹
                , "ITTM" //장애 등급 및 목표시간 관리 Entity
        };

        // 별도 제외 엔터티
        String[] arrExcludeEtcEnts = new String[] {

        };

        String[] logTalbes = new String[] {
                "elg_accesslog",
                "elg_actlog",
                "elg_batchlog",
                "elg_emailalarm",
                "elg_emaillog",
                "elg_entity_logging",
                "elg_iflog",
                "elg_loader",
                "etemp_loader",
                "elg_login",
                "elg_messengerlog",
                "elg_smslog",

                "elg_ecr_form",
                "elg_ecr_frm_field",
                "elg_ecr_frm_group",
                "elg_ecr_frm_set",
                "elg_ecr_frm_ui",
                "elg_ewf_activity",
                "elg_ewf_control",
                "elg_ewf_task",
                "elg_ewf_workflow"
        };

        //		String[] runSqls = new String[]{
        //				"LIT_CLEAR_DATA_USER"
        //		};

        // 1. 등록된 데이터 초기화

        // 등록된 Entity 외 제외한다.

        EntityMap entityMap = ICE.getInstance().map();
        Sqls sqls = ICE.getInstance().sqls();

        List list = entityMap.list();

        for (int i = 0; i < list.size(); i++) {
            Entity e = (Entity)list.get(i);

            //			Log.biz.info("Ent Id=" + e.id);
            //			Log.biz.info("Ent Id=" + e.type);

            //boolean isExcuude = Arrays.stream(arrExcludeEnts).allMatch(e.id::equals);
            boolean isExculde = ArrayUtils.contains(arrExcludeEnts, e.id);

            // Log.biz.info("id=" + e.id + "// type=" + e.type + "/isExcuude=" + isExculde);

            EntMgr entMgr = new EntMgr();
            // todo false가 삭제여야 하지만 테스트
            if (isExculde == false) {

                // 별도 제외에도 없는 경우 삭제
                if (false == ArrayUtils.contains(arrExcludeEtcEnts, e.id)) {
                    // 삭제
                    entMgr.initEntity(e.id);

                    Log.biz.info("# id=" + e.id + "// type=" + e.type + " Init");
                    response.getWriter().println(e.id + "</br>");
                }
            }
        }

        EgeneSqlDao egeneSqlDao = EgeneSqlDao.getInstance();
        int count = 0;
        Data params = new Data();

        for (String table : logTalbes) {

            params.put("tab_id", table);
            count += egeneSqlDao.delete("com.steg.egene.entmgr.truncateEntityTable", params);
            Log.biz.info("# truncate table=" + table);
        }

        // guided.setup.T

        // 사용자 삭제

        // LIT_CLEAR_DATA_USER
        Data arrParam = new Data();
        // sqls.executeArray("LIT_CLEAR_DATA_USER", arrParam, arrParam);

        // 2. 기본 설정 값 초기화

        // 3. 설정 변경
        // s9 정보
        // title
        // config - http
        // mail

        // 4. 라이선스 적용 -- todo

        // todo 가이드 my.cnf
        // 버전에 따른
        // Tomcat 버전에 따른

    }
%>