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
	
	
	
	String sql_id = "Sample.Dml.Update";
	
	TrxContext trx = null;
	TrxResult tr = new TrxResult(0);
  	try{
  		trx = new TrxContext(sqls.getDbName(sql_id));
		trx.begin();

		org.sdf.lang.Time tm = new org.sdf.lang.Time();
		data.put("sam_id", "1111" );
		data.put("name", "테스트 " + tm.cur_dttm());
		data.put("title", "테스트 타이틀 " + tm.cur_dttm() );
		
		tr = sqls.execute(trx.getConnection(), sql_id, data);
		if(tr.getCount() == 0){
			
			sql_id = "Sample.Dml.Insert";	
			tr = sqls.execute(trx.getConnection(), sql_id, data);
		}
		
		trx.commit();

	} catch (SQLException e) {
		if (trx != null)
			trx.rollback();
		Log.biz.err("SQL[" + sql_id + "] " + data, e);
	} catch (Exception e) {
		if (trx != null)
			trx.rollback();
		Log.biz.err("SQL[" + sql_id + "] " + data, e);
	}finally{
		if(trx != null) { trx.close(); }
	}			
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
