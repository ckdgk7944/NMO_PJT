<%@ page contentType="text/html; charset=utf-8"  %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
SelectTest test = new SelectTest();
test.test();


%>
<%!



public class SelectTest{

	public String test(){
		try{
			Class.forName("cubrid.jdbc.driver.CUBRIDDriver");
		}catch(ClassNotFoundException e){
			throw new RuntimeException(e);
		}

		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try{
			String jdbcUrl = "jdbc:cubrid:localhost:33000:demodb:dba::?charset=utf-8";
			conn = DriverManager.getConnection(jdbcUrl);

			stmt = conn.createStatement();

			String sql = "select count(*) from athlete where gender='M'";
			rs = stmt.executeQuery(sql);

			if(rs.next()){
				int total = rs.getInt(1);
			}

			//conn.commit();
	    }catch(SQLException e){
	        //conn.rollback();
	        Log.biz.err("SECURE-201911", e);
	    }finally{
	    	try{
	    		if(rs != null) rs.close();
	    	}catch(Exception ignored){
				Log.biz.err("SECURE-201911", ignored);
	    	}

			try{
			    if(stmt != null) stmt.close();
			}catch(Exception ignored){
				Log.biz.err("SECURE-201911", ignored);
			}

			try{
			    if(conn != null) conn.close();
			}catch(Exception ignored){
				Log.biz.err("SECURE-201911", ignored);
			}
	    }
		return "";
	}
}
%>
