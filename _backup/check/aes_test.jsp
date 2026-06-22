<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
	String s = "QbdJzjXfvSLNRro+pPTmMg==";
	//s= "963f5be641eee016cae76d15a8e2652c160898ea588d13af1456cc91f16657c9";
//	String d = AES256.AES_Decode(s);
	String d = SecureUtil.getInstance().getSecure(SecureUtil.AES256).decrypt(s);
	d = "a#1605067";
	out.println("s : "+ s);
	out.println("<br>");	
	out.println("d : "+ d);
	out.println("<br>");	
	out.println("r : "+ SecureUtil.getInstance().getSecure(SecureUtil.AES256).encrypt(d));
%>
<%@ include file="/xefc/jsp/common/script.jspf" %>
<style>
::selection, select:focus::-ms-value {
	background-color: #BDBDBD;
	color: #000;
}

/*
Option control color
*/
option:checked {
	background-color: #BDBDBD;
	color: #000;
}

option:checked:hover, select:focus option:checked:hover {
	background-color: #BDBDBD;
	color: #000;
}
</style>
<select class="sel">	
	<option>선택</option>
	<option value=1>선택1</option>
	<option value=2>선택2</option>
	<option value=3>선택3</option>
</select>