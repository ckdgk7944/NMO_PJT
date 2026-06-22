<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
    Box box = HttpUtility.getBox(request);

    String[] files = box.getArray("FILE_FULL_PATH");

    for(int i = 0; i < files.length; i++) {
        out.println(files[i]);
        Log.act.info(files[i]);
    }
%>