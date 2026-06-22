<%@page import="org.sdf.slim.config.GlobalResource"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/xefc/jsp/common/import.jspf" %>

<%
	ICE ice = ICE.getInstance();
	Sqls sqls = ice.sqls();

	GlobalResource gr = GlobalResource.getInstance();
	String dbname = gr.get("db.name");

	callProc(dbname);
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

결과 :<br>
--------------------------<br>
</body>
</html>

<%!

    public static void callProc(String dbname){


		Log.act.info("dbname : "+dbname);
		TrxContext trx = null;
		CallableStatement cstmt = null;
		Connection con = null;
		try {

			trx = new TrxContext(dbname);
			trx.begin();

			con = trx.getConnection();

	        cstmt  = con.prepareCall("{ ? = call EAI_DB_SNDR (?, ?, ?) }");
	        cstmt.registerOutParameter(1, Types.INTEGER);
	        cstmt.setString(2, "Z99H-0014-10");
	        cstmt.setString(3, "I");
	        cstmt.setString(4, "");

	        cstmt.execute();

	        Log.act.info("result : "+cstmt.getObject(1));
	        /**
	        ResultSet rs = (ResultSet) cstmt.getObject(1);
	        while (rs.next()) {
	        	Log.act.info("AAAAA");
	        }
	        **/

			trx.commit();
		} catch (SQLException e) {
			if(trx != null) trx.rollback();
			Log.biz.err("Call Proc : ", e);
		} catch (Exception e) {
			if(trx != null) trx.rollback();
			Log.biz.err("Call Proc : ", e);
		} finally {
			try {
				if(cstmt != null) cstmt.close();
			} catch (SQLException e) {
				Log.biz.err(e.getMessage());  /* 20150921-Logger */
			} catch (Exception e) {
				Log.biz.err(e.getMessage());  /* 20150921-Logger */
			}
			if(trx != null) {
				trx.close();
			}

			try {
				if(con != null) con.close();
			} catch (SQLException e) {
				Log.biz.err(e.getMessage());  /* 20150921-Logger */
			}catch(Exception e) {
				Log.biz.err(e.getMessage());  /* 20150921-Logger */
			}
		}
    }
%>
