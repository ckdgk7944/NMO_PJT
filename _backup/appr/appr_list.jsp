<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
    /**
     * 테스트 필요시 테이블 생성
     * TODO
     */

    Sqls sqls = ICE.getInstance().sqls();

    DbMgr dbMgr = new DbMgr(GlobalConfig.getInstance().getDbName());
    Result r = dbMgr.query("SELECT * FROM tmp_appr_test ORDER BY apprt_id desc");
    RecordSet rs = r.getRecordSet();
%>

<html>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<link href="/xplugin/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="/xplugin/jquery/ui/1.13.2/jquery-ui.css" rel="stylesheet" type="text/css">

<script type="text/javascript" src="/xplugin/jquery/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="/xplugin/jquery/ui/1.13.2/jquery-ui.min.js"></script>
<body>

<h1>Approval I/F TEST</h1>
<div>

    <table class="table">
        <tr>
            <th>ID</th>
            <th>ENT</th>
            <th>KEY</th>
            <th>TITLE</th>
            <th>STATUS</th>
            <th>REG_DTTM</th>
            <th>APPRT_ITEMS</th>
            <th>DOC</th>
        </tr>
        <%
            StringBuffer buf = new StringBuffer();
            while (rs.next()) {
                System.out.println(".....");
                buf.append("<tr>");
                buf.append("<td>" + rs.get("apprt_id") + "</td>");
                buf.append("<td>" + rs.get("apprt_ent_id") + "</td>");
                buf.append("<td>" + rs.get("apprt_src_id") + "</td>");
                buf.append("<td>" + rs.get("apprt_title") + "</td>");
                buf.append("<td>" + rs.get("apprt_status") + "</td>");
                buf.append("<td>" + rs.get("apprt_reg_dttm") + "</td>");
                buf.append("<td>" + rs.get("apprt_items") + "</td>");
                buf.append("<td>" + rs.get("apprt_doc") + "</td>");
                buf.append("</tr>");
            }

            out.write(buf.toString());
        %>

    </table>

</div>

<script type="text/javascript">
    $(document).ready(function () {

    });
</script>
</body>
</html>