<%@ page import="com.steg.util.SScheduler" %>
<%@ page import="org.sdf.cron4j.Task" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
    /**
     * 등록된 Task 의 정보를 확인
     */
%>
<html lang="en">
<body>
<h1>Task</h1>
<ol>
    <%
        SScheduler s = SScheduler.getInstance();

        List<Task> list =  s.getTasks();

        for (Task item : list) {
            System.out.println(item.toString());

    %>
    <li><%= item.getId()%>/<%= item.getSchedulingPattern().getOriginalString() %></li>
    <%
        }
    %>
</ol>
</body>

</html>