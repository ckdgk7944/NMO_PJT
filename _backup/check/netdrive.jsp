<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
	
	String dir = "U:/";

	String fname = "common.js";
	File file = new File(dir);
	boolean f = file.isDirectory();
	
	File[] drive = File.listRoots();
	String[] oDrive = new String[drive.length];
	for(int s=0;s<drive.length;s++)
	{
		oDrive[s]=drive[s].getPath();
		out.println("현재 연결된 드라이브명 : "+oDrive[s]+"<BR>");
	}	
%>