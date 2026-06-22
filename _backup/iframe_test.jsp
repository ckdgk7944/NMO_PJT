<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
	Box box = HttpUtility.getBox(request);
	Log.act.info("box : "+box);
%>
<html>
    <body>
        <div>
        </div>
        <div>
        	<iframe id='ifr2' width=1000px height=600px src='http://localhost/sample/security01.jsp?param=한글'></iframe>
        </div>        
    </body>
</html>