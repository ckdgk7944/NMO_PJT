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
	ICE ice = ICE.getInstance();
	Sqls sqls = ice.sqls();
	
	Data data = new Data();
	
	org.sdf.lang.Time tm = new org.sdf.lang.Time();
	data.put("name", "테스트 " + tm.cur_dttm());
	data.put("title", "테스트 타이틀 " + tm.cur_dttm() );
	
	String sql_id = "Sample.Dml.Insert";
	TrxResult tr = sqls.execute(sql_id, data);
			
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

결과 :<%= tr.getCount() %><br>
--------------------------<br>	
Key : <%= tr.getKey() %><br>
--------------------------<br>	
	Error : <%= tr.isError %><br>
	<%= tr.getException() %>

</body>	
</html>		
