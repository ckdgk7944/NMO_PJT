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
 	String fname = box.get("fname");
 	GlobalResource gr = GlobalResource.getInstance();
 	
 	String dir = gr.getBaseDir();
 	File f = new File(dir, "sample/api/"+ fname);
 	StringBuffer buf = new StringBuffer();
 	BufferedReader r = null;
 	try{
 		r = new BufferedReader( new InputStreamReader(new FileInputStream(f),"utf-8"));
			
		String line = null;
		for(int i=0; r.ready();i++){
			line = r.readLine();
			if(line == null) break;
			
			buf.append(line).append("\n");
		}
 	}catch(FileNotFoundException fe) {
 		Log.biz.err(fe.getMessage());
 	}catch(IOException ie) {
 		Log.biz.err(ie.getMessage());
 	}catch(Exception e){
 	  // 20150921-Logger
    Log.biz.err(e.getMessage()); 
 	}finally{
 		if (r != null) {
			try{ r.close(); } catch(IOException e){ Log.biz.err(e.getMessage()); } catch(Exception e){ Log.biz.err(e.getMessage()); }
		}
 	}
 	
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
<b>Source : <font color=blue><%= fname %></font></b>
<textarea style='width:100%;height:100%' readonly><%= org.sdf.servlet.HttpUtility.translate(buf.toString()) %></textarea>		

</body>	
</html>		
