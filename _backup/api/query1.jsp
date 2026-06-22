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
	String sql_id = "Sample.Query.1";
	ICE ice = ICE.getInstance();
	Sqls sqls = ice.sqls();
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
</style>			
<body>

<table border=1>
	<col width=30>
	<col width=100>	
	<col width=200>
	<col width=150>
	<col width=400>
<tr>	
	<th>No</th>
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
		<td><%= rs.get("sam_id") %></td>
		<td><%= rs.get("sam_name") %></td>
		<td><%= rs.get("sam_reg_dttm") %></td>
		<td><%= rs.get("sam_title") %></td>
	</tr>
<%
		}
	}
%>
</tr>
</table>	

</body>	
</html>		
