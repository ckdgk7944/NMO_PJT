<%@ page contentType="text/html; charset=utf-8"  %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
	Box box = HttpUtility.getBox(request);
	String att_id = "";
	
	//VDI_View_Client설치매뉴얼(사내).pdf
	if(box.getInt("gubun") == 1){
		att_id = "MOBISFILE00001";
	//VDI_View_Client설치매뉴얼(사외-외부공용).pdf
	}else if(box.getInt("gubun") == 2){
		att_id = "MOBISFILE00002";
	//[접근통제] 결재시스템 사용자 대상 메뉴얼.ppt
	}else if(box.getInt("gubun") == 3){
		att_id = "MOBISFILE00003";
	}
	
	String uri = "/xefc/jsp/common/download.jsp?tab_name=ecf_file_file&direct=1&att_id="+att_id;
	response.sendRedirect(uri);
%>
<html>
<script>
	down = function(){
		f_form.submit();
	}
	//down();
</script>
<body>
	<form name="f_form" method="post" action="/xefc/jsp/common/download.jsp">
		<input type="hidden" name="tab_name" value="ecf_file_file">
		<input type="hidden" name="att_id" value="<%=att_id%>">
		<input type="hidden" name="direct" value="1">
	</form>
	
	<a href="#" onClick="down();">down</a>
</body>
</html>