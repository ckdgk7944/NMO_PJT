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

<form name=frm method=post>
<input type=hidden name=act value='1'>
	
sam_id:<input type=text name=sam_id value="<%= box.get("sam_id") %>"><br>
sam_name:<input type=text name=sam_name value="<%= box.get("sam_name") %>"><br>
sam_title:<input type=text name=sam_title value="<%= box.get("sam_title") %>"><br>

n_sam_id:<input type=text name=n_sam_id value="<%= box.get("n_sam_id") %>"><br>
<input type=submit value="확 인">
</form>
<%
	ICE ice = ICE.getInstance();
	Sqls sqls = ice.sqls();
	
	
	int act =box.getInt("act");
	
	if(act == 1){
		
		
		/* ------------------------------------------------*/
		TrxSqls tsqls = sqls.getTrxSqls();
		tsqls.begin();
		
		
		Result r = tsqls.getResult("Sample.Query.2", box.get("sam_id") );
		RecordSet rs = r.getRecordSet();
		rs.next();
		out.println( "Before: "+rs.get("sam_name")  + " : " + rs.get("sam_title") + "<br>");
		
		String sql_id = "Sample.Dml.Update";
		TrxResult tr = tsqls.execute(sql_id, box);

		r = tsqls.getResult("Sample.Query.2", box.get("sam_id") );
		rs = r.getRecordSet();
		rs.next();
		out.println( "After: "+rs.get("sam_name")  + " : " + rs.get("sam_title")+ "<br>");
		
		
		r = sqls.getResult("Sample.Query.2", box.get("sam_id") );
		rs = r.getRecordSet();
		rs.next();
		out.println( "Other Con Before Commit: "+rs.get("sam_name")  + " : " + rs.get("sam_title")+ "<br>");
		
		if(!box.valid("n_sam_id")){
			box.put("n_sam_id", UniqueKey.getInstance().fetchNewKey());
		}
		sql_id = "Sample.Dml.Insert1";
		tr = tsqls.execute(sql_id, box);
		
		tsqls.commit();

		r = sqls.getResult("Sample.Query.2", box.get("sam_id") );
		rs = r.getRecordSet();
		rs.next();
		out.println( "Other Con After Commit: "+rs.get("sam_name")  + " : " + rs.get("sam_title")+ "<br>");

		
		boolean isError = tsqls.isError;
		Exception err	= tsqls.getException();
		/* ------------------------------------------------*/
%>
결과 :<%= tr.getCount() %><br>
--------------------------<br>	
Key : <%= tr.getKey() %><br>
--------------------------<br>	
	Error : <%= isError %>  : <%= err %>

<%		
	}
%>


</body>	
</html>		
