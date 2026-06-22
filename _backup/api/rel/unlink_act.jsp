<%@ page contentType="text/html; charset=utf-8"  %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
    Box box = HttpUtility.getBox(request);
	Log.act.info(this+"_box : "+box);
	String ent_id = box.get("ent_id");
	
	ICE ice = ICE.getInstance();
	EntityMap map = ice.map();
	Entity ent = map.getEntity(ent_id);
	String prefix = ent.prefix;
	String tb = ent.getMasterTableName().toLowerCase(Locale.ENGLISH).;
	
	int cnt = box.getInt("entire_cnt");
	String[] key = new String[cnt];
	for(int i=0; i<cnt; i++){
		key[i] = box.get("key_"+i);
		//Log.act.info("box_key : "+key[i]);
	}

	deleteData(tb, prefix, key);
%>
<%!
	int deleteData(String tb, String prefix, String[] key) throws Exception{
		Connection con = new DBSource().getConnection("egene");
		JPreparedStatement pstmt = null;
		int count = 0;
	     try{
	    	con.setAutoCommit(false);
	    	
	    	for(int i=0; i<key.length; i++){
				String dml_1 = "delete from "+tb+" where "+prefix+"_id = ?";
				pstmt = new JPreparedStatement(con,dml_1,true);
				Log.act.info("key : " + key[i]);
				//pstmt.setLogging(false);
				pstmt.setString(1, key[i]);
		     	count += pstmt.executeUpdate();
				/**
				String dml_2 = "delete * from eso_wf_rel where wfr_tgt_id = ?";
				pstmt = new JPreparedStatement(con,dml_2,true);
				//pstmt.setLogging(false);
				pstmt.setString(1, key[i]);
		     	count += pstmt.executeUpdate();
		     	**/
	    	}
	     	con.commit();
	     }catch(SQLException e){
	    	 con.rollback();
	    	 Log.biz.err(e);
	     }catch(Exception e){
	    	 con.rollback();
	    	 Log.biz.err(e);
	     }finally {
	         pstmt.close();
	         con.close();
	     }  
	     return count;
	}  
%>