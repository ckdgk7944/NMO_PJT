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
<body>
<b>SQL ID : <font color=blue><%= sql_id %></font></b><br>
* SQL <br>
<textarea style='width:100%;height:200px' readonly><%= (sql != null ? sql.getSql() : "") %></textarea><br>

* SQL Args <br>
<textarea style='width:100%;height:200px' readonly><%= (sql != null ? sql.getSqlConfig() : "") %></textarea><br>

</body>	
</html>		
