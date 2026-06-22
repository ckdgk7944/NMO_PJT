<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="org.sdf.log.Log" %><%--
  Created by IntelliJ IDEA.
  User: jhgo
  Date: 2022-01-03
  Time: 오후 1:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // sql cond 표현식 추출 정규식
    Pattern pattern = Pattern.compile("#\\{\\S+\\}");
    // 예약어 표현식 키 추출 정규식
    Pattern keyPattern = Pattern.compile("[^#\\{]\\S+[^\\}]");

    Matcher matcher = pattern.matcher(source);

    while(matcher.find()){
        String condExp = matcher.group();
        Matcher keyMatcher = keyPattern.matcher(condExp);
        if (keyMatcher.find()) {

            Log.biz.info(keyMatcher.group());
        }
    }

%>