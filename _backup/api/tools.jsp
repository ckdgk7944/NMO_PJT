<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="org.sdf.servlet.*,
                           org.sdf.rdb.*,
                           org.sdf.util.*,
                           org.sdf.log.*,
                           org.sdf.lang.*,
                           org.sdf.slim.*,
                           org.sdf.slim.config.*,
                           com.steg.org.json.simple.*"
                import="java.io.*,java.util.*,java.sql.*"     
                import="com.steg.efc.*"
                           
%>

<%
 	Box box = HttpUtility.getBox(request);	
 
 	String new_key = "";
 	boolean result = false;
 	
 	if("make".equals(box.get("act"))){
 		boolean demo = box.valid("demo");
 		if(demo){
 			new_key = L.trial( );
 		}else{
 			String host = box.get("host");
 			String src = host  ;
 			new_key = L.encode( src);
 		
 		}
 		
	}else if("verify".equals(box.get("act"))){
 		
 		result = L.verify(box.get("key"), box.get("host"));
 		
 	}
 
 %>
 <html xmlns="http://www.w3.org/1999/xhtml">
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
<style>
	html,body{
		font:11px dotum;	
	}
	
	th{
		font:bold 11px dotum;	
		background-color:#afafaf;
	}
	
	td{
		font:11px dotum;	
	}
	
	input,textarea{
		font:11px dotum;	
	}
</style>			
<script language=javascript>
	doMake = function(){
		document.form.act.value = "info";
		document.form.submit();	
	}
	
	doVerify = function(){
		
	}
</script>	

<body>
	
	<form name=form method=post>
	<input type=hidden name=act value="make">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<table>
	<tr>
		<td>Host</td>	<td><input type=text name=host value="<%= box.get("host") %>"></td>	</tr>
	<tr>
		<td>Demo</td><td><input type=checkbox name=demo value="1"></td>	</tr>
	<tr>
		<td>Key</td><td><input type=text  size=50 readonly value="<%= new_key %>"></td>	</tr>
	</table>		
	<input type=submit value="Make">
	</form>
	
	
	<form name=form method=post>
	<input type=hidden name=act value="verify">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

	<table>
	<tr>
		<td>Host</td>	<td><input type=text name=host value="<%= box.get("host") %>"></td>	</tr>	
		<td>Key</td><td><input type=text size=50  name=key value="<%= box.get("key") %>"></td></tr>
	<tr>
		<td>Verify</td><td><%= result %></td></tr>

	</table>		
	<input type=submit value="Verify">
	</form>
</body>
</html>	
 