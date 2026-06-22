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

	Entity entity = ICE.getInstance().map().getEntity("SAP");
	Row row = entity.open("SAP00165");

	Log.biz.info(row.toString());

//	Row row2 = entity.openOne(new String[]{"sap_trkorr", "sap_date", "sap_time"}, new String[]{"SAPKD75579", "2022-01-10", "14:09:59"});
	Row row2 = entity.openOne(new String[]{"sap_trkorr"}, new String[]{"IN3K9A5R2K"});
	Log.biz.info(row2.toString());





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


</body>	
</html>		
