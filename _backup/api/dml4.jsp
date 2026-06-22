<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="org.sdf.servlet.*,
                           org.sdf.rdb.*,
                           org.sdf.util.*,
                           org.sdf.log.*,
                           org.sdf.lang.*,
                           com.steg.org.json.simple.*"
                import="java.util.*,java.sql.*"     
                import="com.steg.efc.*"
                           
%>

<%
 	Box box = HttpUtility.getBox(request);
 
	ICE ice = ICE.getInstance();
	Sqls sqls = ice.sqls();
	
	int act = box.getInt("act");
	
	TrxResult tr = null;
	if(act == 2){
		String sql_id = "Sample.Dml.MUpdate";
		tr = sqls.executeBatch(sql_id, box);
		
	}else if(act == 3){
		String sql_id = "Sample.Dml.MDelete";
		tr = sqls.executeBatch(sql_id, box);
	}
	
	if( tr == null ) tr = new TrxResult(0);

	String sql_id = "Sample.Query.1";
	
	Result r = sqls.getResult(sql_id);
	RecordSet rs = r.getRecordSet();
%>
<html>
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
	
	input{
		font:11px dotum;	
		height:15px;
		margin:0;
		padding:0;
	}
</style>	
<script language=javascript>
	doModify = function(frm){
		frm.act.value = '2';
		frm.submit();
	}
	
	doDelete = function(frm){
		frm.act.value = '3';
		frm.submit();
	}
</script>			
<body>

<form name=frm method=post>
<input type=hidden name=act >
<input type=hidden name=row_cnt value="<%= rs.getRowCount() %>" >

<div>
	<input type=button value="수 정" onClick="doModify(document.frm)">
	<input type=button value="삭 제" onClick="doDelete(document.frm)">
</div>		
<table border=1>
	<col width=30>
	<col width=30>
	<col width=100>	
	<col width=200>
	<col width=150>
	<col width=400>
<tr>	
	<th>No</th>
	<th></th>
	<th>ID</th>
	<th>name</th>
	<th>등록일시</th>
	<th>제목</th>
</tr>

<%
	if(rs.getRowCount() == 0){			
%>
	<tr><td colspan=6>데이터가 없습니다.</td></tr>
<%
	}else{
		for(int i=0; rs.next(); i++){
%>
	<tr>	
		<td><%= (i+1) %></td>
		<td><input type=checkbox name=sam_id<%= i %> value="<%= rs.get("sam_id") %>" ></td>
		<td><%= rs.get("sam_id") %></td>
		<td><input size=25 type=text name=sam_name<%= i %> value="<%= rs.get("sam_name") %>"></td>
		<td><%= rs.get("sam_reg_dttm") %></td>
		<td><input size=40  type=text name=sam_title<%= i %> value="<%= rs.get("sam_title") %>"></td>
	</tr>

<%
		}
	}
%>
</tr>
</table>	

</form>

</body>	
</html>		
