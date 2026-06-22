<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*,java.nio.*,java.nio.channels.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="org.sdf.servlet.*,org.sdf.util.*,org.sdf.log.*" %>
<%
 	Box box = HttpUtility.getBox(request);

%>
{
  "id":"<%= box.get("id") %>",
  "name":"<%= box.get("name") %>",
  "office":{ 
  	"name":"(주)에스티이지", 
  	"phone":"02-3273-3477"
  },
  "arr":[ "111", "222", "333"]
} 	
