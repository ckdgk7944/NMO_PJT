<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.nio.*,java.nio.channels.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="org.sdf.servlet.*,org.sdf.util.*,org.sdf.log.*" %>
<%
 	Box box = HttpUtility.getBox(request);

%>
<html>
	<style>
		body{
			font:normal 12px dotum;
		}
		input,textarea{
			font:normal 12px dotum;
		}
	</style>
	<script type="text/javascript" src="/xefc/script/prototype.js"></script>
	<script type="text/javascript" src="/xefc/script/common.js"></script>
	<script type="text/javascript" src="/xefc/script/core.js"></script>
	<script language=javascript>
		testGetContents = function(){

			var uri = "ajax_contents.jsp";
			var params = "id=123&name=AAA"; 
			getContents('div_test',uri,params);
			
			alert('End testGetContents');
		}
		
		testCallAjaxJson = function(){

			var uri = "ajax_json.jsp";
			var params = "id=123&name=AAA"; 
			var json = callAjaxJSON(uri,params);
			
			if(json.error) alert(json.errcode + ":" + json.errmsg);
			else alert("ID:"+ json.id + ",이름:" + json.name +
							 "\n회사:" + json.office.name);
		}
		
		testCallAjaxScript = function(){

			var uri = "ajax_script.jsp";
			var params = "id=123&name=AAA"; 
			
			var json = callAjaxScript(uri,params);
			if(json.error) alert(json.errcode + ":" + json.errmsg);
			else alert("Result:"+json.result);
			
		}

		testFormCallAjaxJson = function(frm){

			var uri = "ajax_json.jsp";
			var params = Forms.serialize(frm); 
			var json = callAjaxJSON(uri,params);
			
			if(json.error) alert(json.errcode + ":" + json.errmsg);
			else alert("ID:"+ json.id + ",이름:" + json.name +
							 "\n회사:" + json.office.name);
		}
		
		testFormCallAjaxScript = function(frm){

			var uri = "ajax_script.jsp";
			var params = Forms.serialize(frm); 
			
			var json = callAjaxScript(uri,params);
			if(json.error) alert(json.errcode + ":" + json.errmsg);
			else alert("Result:"+json.result);
			
		}		
		
		
		testMPPCallAjaxJson = function(){

			var uri = "/xif/jsp/common/EXDU.jsp";
			var params = "mpp_id=Sample.UPDATE&id=123"; 
			var json = callAjaxJSON(uri,params);
			
			if(json.error) alert(json.errcode + ":" + json.errmsg);
			else alert("ID:"+ json.id + ",이름:" + json.name +
							 "\n회사:" + json.office.name);
		}		
	</script>
<body>
	* 비동기 방식<br>
	<input type=button value="Test GetContents" onClick="testGetContents()"><br>
	<div id='div_test' style='border:1px solid #aaaaaa'>&nbsp;</div>
	
	<br>
	<br>
	* 동기 방식[Parameter 지정] (id=123&name=AAA)<br>
	<input type=button value="Test CallAjaxJson" onClick="testCallAjaxJson()">
	<input type=button value="Test CallAjaxScript" onClick="testCallAjaxScript()">
	
	<br>
	<br>
	<br>
	* 동기 방식[Form 지정]
	<form name=frm method=post style='margin:0;padding:0'>
	ID:<input type=text name=id value="<%= box.get("id") %>">	
	이름:<input type=text name=name value="<%= box.get("name") %>"><br>	

	<input type=button value="Test Form CallAjaxJson" onClick="testFormCallAjaxJson('frm')">
	<input type=button value="Test Form CallAjaxScript" onClick="testFormCallAjaxScript('frm')">
	
	</form>
	
	<br>
	<br>
	* Mapping Call 동기 방식[Parameter 지정] (mpp_id=Sample.UPDATE&id=123)<br>
	<input type=button value="Test CallAjaxJson" onClick="testMPPCallAjaxJson()">	
</body>
</html>		
