<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.nio.*,java.nio.channels.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="org.sdf.servlet.*,org.sdf.util.*,org.sdf.log.*" %>
<%
 	Box box = HttpUtility.getBox(request);
 
  String text = "ID:" + box.get("id") + ", 이름:" + box.get("name");
  String result = org.sdf.lang.Time.cur_ldttm();
%>
<script language=javascript>
	alert('<%= text %>');
	"<%= result %>";
</script>	
