<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.net.URL"%>
<%@page import="java.security.*"%>
<%@page import="javax.net.ssl.*"%>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
	try{
        SSLContext ctx = SSLContext.getInstance("TLS");
        ctx.init(new KeyManager[0], new TrustManager[] {new com.steg.util.DefaultTrustManager()}, new SecureRandom());
        SSLContext.setDefault(ctx);
 
        URL url = new URL("https://itsm.mobis.co.kr");
        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
        conn.setHostnameVerifier(new HostnameVerifier() {
            public boolean verify(String arg0, SSLSession arg1) {
            	Log.act.info("AAAAA");
                return true;
            }
        });
        out.println(conn.getResponseCode());
        conn.disconnect();
	}catch(IOException e){
		Log.biz.err(e);
	}catch(Exception e){
		Log.biz.err(e);
	}
%>
