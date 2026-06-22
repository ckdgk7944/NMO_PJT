<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
    // Request Parameter
    Box box = HttpUtility.getBox(request);

    // SQL 수행할 경우
    String sqlId = "";
    if (StringUtil.valid(sqlId)) {
        RecordSet rs = ICE.getInstance().sqls().getResult(sqlId, box).getRecordSet();
        while (rs.next()) {
            String filePath = rs.get("file_path");
        }
    }

%>
<html>
<head>
    <title>Title</title>
</head>
<body>
<form name="_form" action="http://10.80.26.99:60104/itsm_cm_call.jsp" method="post">
    <input type="hidden" name="INTERFACE" value="ITSM">
    <input type="hidden" name="CALLTYPE" value="ANM">
    <input type="hidden" name="INST_ID" value="CHM2002-00001">
    <input type="hidden" name="LOGIN_ID" value="23452">

    <%-- 파일 개수만큼 반복해야 함 --%>
    <input type="hidden" name="FILE_FULL_PATH" value="/xif/jsp/a.jsp">
    <input type="hidden" name="FILE_FULL_PATH" value="/xif/jsp/b.jsp">
    <input type="hidden" name="FILE_FULL_PATH" value="/xif/jsp/c.jsp">
    <input type="hidden" name="FILE_FULL_PATH" value="/xif/jsp/d.jsp">
</form>
<script>
    (function(){
        document._form.submit();
    })();
</script>
</body>
</html>
