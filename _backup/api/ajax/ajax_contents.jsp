<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.nio.*,java.nio.channels.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="org.sdf.servlet.*,org.sdf.util.*,org.sdf.log.*" %>
<%
 	Box box = HttpUtility.getBox(request);
 	
%>
<table border=1>
<tr>
	<td>ID</td><td><%= box.get("id") %></td>
	<td>이름</td><td><%= box.get("name") %></td>
</tr>
</table>

<script language=javascript>
	alert('Execute getContents()');
</script>	
