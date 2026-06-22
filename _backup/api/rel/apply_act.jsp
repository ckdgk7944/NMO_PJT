<%@ page contentType="text/html; charset=utf-8"  %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
    Box box = HttpUtility.getBox(request);
	//Log.act.info("box : "+box);
	
%>
<%!
	int deleteData(String[] key) throws Exception{
		Connection con = new DBSource().getConnection("egene");
		JPreparedStatement pstmt = null;
		int count = 0;
	     try{
	    	con.setAutoCommit(false);
	    	
	    	for(int i=0; i<key.length; i++){
				String dml_1 = "delete * from eso_workorder where wor_id = ?";
				pstmt = new JPreparedStatement(con,dml_1,true);
				//pstmt.setLogging(false);
				pstmt.setString(1, key[i]);
		     	count += pstmt.executeUpdate();
	
				String dml_2 = "delete * from eso_wf_rel where wfr_tgt_id = ?";
				pstmt = new JPreparedStatement(con,dml_2,true);
				//pstmt.setLogging(false);
				pstmt.setString(1, key[i]);
		     	count += pstmt.executeUpdate();
	    	}
	     	con.commit();
	     }catch(SQLException e){
	    	 con.rollback();
	    	 Log.biz.err(e);
	     }catch(Exception e){
	    	 con.rollback();
	    	 Log.biz.err(e);
	     }finally {
			if(pstmt != null)
		         pstmt.close();
			if(con != null)
	       	 	 con.close();
	     }  
	     return count;
	}  
%>