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
 	String sql_id = box.get("sql_id");
 
 	ICE ice = ICE.getInstance();
	Sqls sqls = ice.sqls();
 	
 	Sql sql = (Sql)sqls.get(sql_id);
 	
 	String vars  = box.get("vars");
 	
 	
 	
 	String msg = null;
 	RecordSet rs = null;
 	Result r = null;
 	if("info".equals(box.get("act"))){
 	
 	}else if("exec".equals(box.get("act"))){
 		String[] arr = org.sdf.util.StringUtil.getArray(vars,';');
 		for(int i=0; i<arr.length; i++){
 			String[] arr1 = org.sdf.util.StringUtil.getArray(arr[i],'=');
 			if(arr1.length == 2){
 				box.put(arr1[0], arr1[1]);
 			}
 		}
 		
 		
 		if(sql.callType == Sql.CALL_QUERY ) r= sqls.callResult(sql_id, box);
 		else r= sqls.getResult(sql_id, box);
 		
 		rs = ( r != null ? r.getRecordSet() : null);
 		msg = (r.isError ? r.getException().toString() : null);
 	}else if("modify".equals(box.get("act"))){
 	
 	}
 	
 	if(rs == null) rs = new RecordSet();
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
	doGetInfo = function(){
		document.form.act.value = "info";
		document.form.submit();	
	}
	
	doExec = function(){
		document.form.act.value = "exec";
		document.form.submit();	
	}
	
	doModify = function(){
		document.form.act.value = "modify";
		document.form.submit();
	}
</script>	
<body>
	
<table>
<tr>
	<td>		
<form name=form method=post>
<input type=hidden name=act value="">
<b>SQL ID : <input type=text name=sql_id size=30 value="<%= box.get("sql_id") %>"> <b>
	<input type=button value="조회" onClick=doGetInfo()><input type=button value="실행" onClick=doExec()></b><br>


* SQL DB Name : <input type=text readonly value="<%= (sql != null ? sql.getDbName() : "") %>"> server.xml에 정의된 Resource Name, 
* SQL Type  : <input type=text readonly value="<%= (sql != null && sql.callType == Sql.CALL_QUERY  ? "Call Query" : "Query") %>"> 
	<br>		
* SQL <br>
<textarea style='width:100%;height:150px' readonly><%= (sql != null ? sql.getSql() : "") %></textarea><br>

* SQL Args <br>
<textarea style='width:100%;height:150px' readonly><%= (sql != null ? sql.getSqlConfig() : "") %></textarea><br>

* 변수	
<textarea name=vars style='width:100%;height:40px' ><%= box.get("vars") %></textarea><br>
	ex) emp_id=0001;cat_cd=AAA;sdate=20101011
<br>	

</form>
	</td>
	<td valign=top>
		<div style='overflow:scroll;width:250px;height:370px;padding:0px;border:1px solid #cccccc;'>
<%	
		for(int i=0; i<sqls.size(); i++){
			Sql o = (Sql)sqls.get(i);
%>
			<div style='padding:1px;cursor:hand;text-decoration:underline;' onClick="document.form.sql_id.value='<%= o.id %>'"><%= o.id %></div>		
<%		
		}
%>		
							
		</div>
	</td>
</tr>
</table>	

<%
	int col_cnt = rs.getColumnCount();		
	if(col_cnt > 0){	
		String[] cols = rs.getColumnNames();
%>	
<hr>
<%= col_cnt %>	
<%= (r != null && r.isError )	? r.getException().toString() : "" %>
<table cellspacing=1 cellpadding=2 bgcolor=#999999>
	<tr>
<%
		for(int j=0; j<col_cnt; j++){
%>				
			<td bgcolor=#eeeeee><%= cols[j] %></td>
<%
		}
%>	
	</tr>			
<%
		for(	int i=0; rs.next(); i++){
%>
	<tr bgcolor=#ffffff>
<%
		for(int j=0; j<col_cnt; j++){
%>				
			<td ><%= rs.get(j+1) %></td>
<%
		}
%>	
				
	</tr>	
<%		
		}
%>
		
</table>			
<hr>
<%
	}
%>	
</body>	
</html>		
