<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@page import="org.apache.commons.lang.RandomStringUtils"%>
<%
	Box box = HttpUtility.getBox(request);

	response.setContentType("text/html;charset=UTF-8");
	Connection conn = null;
	Statement stmt = null;

	String className = box.get("className"); //DB Class 이름
	String url = box.get("url"); //DB url정보
	String user = box.get("user"); //DB user id
	String pw = box.get("pw"); //DB user pw
	String tab = box.get("tab"); //조회테이블
	String rownum = box.get("rownum"); //조회할 row수

	tab = StringUtil.invalid(tab) ? "dual" : tab;
	out.println("=============Box===========<br/>");
	out.println("url : " + url + "<br/>");
	out.println("user : " + user + " pw : " + pw + "<br/>");
	out.println("tab : " + tab + "<br/>");
	out.println("===========================<br/>");
	/* 
	List classNames = new ArrayList();
	classN */
	
	/*
		ClassName
		
		SQL_Server 2000 - com.microsoft.jdbc.sqlserver.SQLServerDriver
		SQL_Server 2005, 2008, 2012 - com.microsoft.sqlserver.jdbc.SQLServerDriver
		MySQL - com.mysql.jdbc.Driver
		Oracle - oracle.jdbc.driver.OracleDriver
		Tibero - com.tmax.tibero.jdbc.TbDriver
		CUBRID - cubrid.jdbc.driver.CUBRIDDriver
		DB2(Universal JDBC Type 2, 4) - com.ibm.db2.jcc.DB2Driver
	
	//localhost
	String className = "oracle.jdbc.OracleDriver";
	String url = "jdbc:oracle:thin:@localhost:1521:egene";
	String user = "egene52";
	String pw = "egene52";
	*/
	
	//Tibero
	/*
	String className = "com.tmax.tibero.jdbc.TbDriver";
	String url = "jdbc:tibero:thin:@10.240.14.125:8629:itsm";	
	String user = "egene51";
	String pw = "egene51";
	*/
	
	//DEV
	/*	
	String className = "oracle.jdbc.driver.OracleDriver";
	String url = "jdbc:oracle:thin:@10.240.229.151:1521/egene";	
	String user = "egene51";
	String pw = "egene51";
	*/
	
	//INSA REAL
	/*	
	String className = "oracle.jdbc.driver.OracleDriver";
	String url = "jdbc:oracle:thin:@10.10.163.73:1521:imdb";	
	String user = "IMIF_ITSM";
	String pw = "Mob1s!tsm2018";	
	*/	
	
	//INSA
	/*	
	String className = "oracle.jdbc.driver.OracleDriver";
	String url = "jdbc:oracle:thin:@10.133.21.223:1521/oimdb";	
	String user = "imif_itsm";
	String pw = "Mob!s1tsm";	
	*/
	
	//보안포탈	
	/* 	 
	String className = 	"net.sourceforge.jtds.jdbc.Driver";	
	String url = "jdbc:jtds:sqlserver://10.240.13.207:1433/Mobis_SPS";	
	String user = "inf_itsm";
	String pw = "dkdlxl!23";
	*/
	 
	//자산관리
	/*
	String className = 	"net.sourceforge.jtds.jdbc.Driver";
	String url = "jdbc:jtds:sqlserver://10.10.163.185:1433/NetClient5_dev";	
	String user = "itsm";
	String pw = "ahqltmITSM20!8";
	*/
	
	//NT성능 모니터링 
	/*
	String className = 	"net.sourceforge.jtds.jdbc.Driver";
	String url = "jdbc:jtds:sqlserver://10.10.163.114:1433/NT_perf";	
	String user = "perf";
	String pw = "perf2010";	
	*/
	
	//AS400
	/*
	String className = 	"com.ibm.as400.access.AS400JDBCDriver";
	String url = "jdbc:as400:10.133.21.184;prompt=false;";	
	String user = "ITSM";
	String pw = "itsm2018@";	
	*/
	
	//DBSAFER
	/*	
	String className = 	"com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://10.240.13.228:3306/psync";	
	String user = "itsm";
	String pw = "itsm@";	
	*/
	try {

		Class.forName(className);
		conn = DriverManager.getConnection(url, user, pw);
		out.println("<h3>  JDBC Connection Success</h5>");
		out.println("<h5>- Product Name : " + conn.getMetaData().getDatabaseProductName() + "</h5>");
		out.println("<h5>- Product Version : " + conn.getMetaData().getDatabaseProductVersion() + "</h5>");
		out.println("<h5>- Driver Name : " + conn.getMetaData().getDriverName()+"</h5>");
		out.println("<h5>- Driver Version : " + conn.getMetaData().getDriverVersion()+"</h5>");

		Connection con = new DBSource().getConnection("egene");

		Result result = new Result();
		String sql = null;
		try {

			RecordSet rs = null;
			sql = "select * from " +  tab;

			out.println("<br>con : " + con);
			rs = new RecordSet(sql, 1, 10);
			rs.executeQuery(con);
			out.println("<br/>sql : " + sql);
			out.println("\t [count : " + rs.getTotalCount() + "]");
			result.setRecordSet(rs);

			out.println("<br>conn : " + conn);
			rs = new RecordSet(sql, 1, 10);
			rs.executeQuery(conn);
			out.println("<br/>sql : " + sql);
			out.println("\t [count : " + rs.getTotalCount() + "]");
			result.setRecordSet(rs);
		} catch (SQLException e) {
			Log.biz.err(sql, e);
			result.setException(e);
			response.getWriter().append("<h5>Exception Message<h5><br>");
			Log.biz.err("SECURE-201911", e);
		} catch (Exception e) {
			Log.biz.err(sql, e);
			result.setException(e);
			response.getWriter().append("<h5>Exception Message<h5><br>");
			Log.biz.err("SECURE-201911", e);
		} finally {
			try {
				con.close();
			} catch (SQLException e) {
				Log.biz.err("SECURE-201911", e);
			} catch (Exception e) {
				Log.biz.err("SECURE-201911", e);
			}
		}
		
	} catch (ClassNotFoundException e) {
		Log.biz.err("error : "+e);
		response.getWriter().append("<h5>Exception Message<h5><br>");
		Log.biz.err("SECURE-201911", e);
	} catch (SQLException e) {
		Log.biz.err("error : "+e);
		response.getWriter().append("<h5>Exception Message<h5><br>");
		Log.biz.err("SECURE-201911", e);
	} catch (Exception e) {
		Log.biz.err("error : "+e);
		response.getWriter().append("<h5>Exception Message<h5><br>");
		Log.biz.err("SECURE-201911", e);
	} finally {
		try{ if(stmt != null) stmt.close(); } catch(SQLException e){ Log.biz.err(e.getMessage()); } catch(Exception e){ Log.biz.err(e.getMessage()); }
		try{ if(conn != null) conn.close(); } catch(SQLException e){ Log.biz.err(e.getMessage()); } catch(Exception e){ Log.biz.err(e.getMessage()); }
	}
%>