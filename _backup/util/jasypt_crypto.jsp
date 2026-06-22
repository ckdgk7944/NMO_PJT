<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2024-10-16
  Time: 오후 5:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.jasypt.encryption.StringEncryptor" %>
<%@ page import="org.jasypt.encryption.pbe.PooledPBEStringEncryptor" %>
<%@ page import="org.jasypt.encryption.pbe.config.SimpleStringPBEConfig" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="_csrf_param" content="${_csrf.parameterName}"/>
    <title>Jasypt 암호화/복호화 도구</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .container {
            max-width: 600px;
            margin: auto;
        }
        h2 {
            text-align: center;
        }
        form {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-top: 10px;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 8px;
        }
        input[type="submit"] {
            margin-top: 10px;
            padding: 10px 20px;
        }
        .result {
            background-color: #f0f0f0;
            padding: 10px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Jasypt 암호화/복호화 도구</h2>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // POST 요청 처리
        String operation = request.getParameter("operation");
        String inputText = request.getParameter("inputText");
        String jasyptKey = request.getParameter("jasyptKey");

        StringEncryptor stringEncryptor = null;
        String result = null;
        String message = null;

        if (operation != null && inputText != null && jasyptKey != null) {
            stringEncryptor = stringEncryptor(jasyptKey);
            try {
                if ("encrypt".equals(operation)) {
                    result = stringEncryptor.encrypt(inputText);
                    message = "암호화된 텍스트:";
                } else if ("decrypt".equals(operation)) {
                    result = stringEncryptor.decrypt(inputText);
                    message = "복호화된 텍스트:";
                } else {
                    message = "유효하지 않은 작업입니다.";
                }
            } catch (Exception e) {
                result = "오류: " + e.getMessage();
                message = "복호화에 실패했습니다. 비밀번호가 올바르지 않거나 텍스트가 손상되었습니다.";
            }
        }

        // TRUST_BOUNDARY_VIOLATION: 사용자 입력 검증 후 세션 저장
        if (!"encrypt".equals(operation) && !"decrypt".equals(operation)) {
            operation = null;
        }
        if (inputText != null && inputText.length() > 4096) {
            inputText = inputText.substring(0, 4096);
        }
        if (jasyptKey != null && jasyptKey.length() > 256) {
            jasyptKey = jasyptKey.substring(0, 256);
        }
        session.setAttribute("resultMessage", message);
        session.setAttribute("resultText", result);
        session.setAttribute("savedOperation", operation);
        session.setAttribute("savedInputText", inputText);
        session.setAttribute("savedJasyptKey", jasyptKey);

        // Post 요청일 시 Get 요청으로 Redirect -> 새로고침 시 Post 유지를 하지 않기 위함
        response.sendRedirect(request.getRequestURI());
        return;
    }

    // GET : Post후 Get redirect 일시 session 값 유지 후 get & Get 요청 시 session 값 null
    String message = (String) session.getAttribute("resultMessage");
    String result = (String) session.getAttribute("resultText");
    String savedOperation = (String) session.getAttribute("savedOperation");
    String savedInputText = (String) session.getAttribute("savedInputText");
    String savedJasyptKey = (String) session.getAttribute("savedJasyptKey");

    // 세션 초기화
    session.removeAttribute("resultMessage");
    session.removeAttribute("resultText");
    session.removeAttribute("savedOperation");
    session.removeAttribute("savedInputText");
    session.removeAttribute("savedJasyptKey");
%>

<form method="post">
    <label for="operation">작업 선택:</label>
    <select name="operation" id="operation">
        <option value="encrypt" <%= "encrypt".equals(savedOperation) ? "selected" : "" %>>암호화</option>
        <option value="decrypt" <%= "decrypt".equals(savedOperation) ? "selected" : "" %>>복호화</option>
    </select>
    <input type="hidden" class="csrf-field" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <label for="jasyptKey">Jasypt Key 입력:</label>
    <% request.setAttribute("_savedJasyptKey", savedJasyptKey != null ? savedJasyptKey : ""); %>
    <% request.setAttribute("_savedInputText", savedInputText != null ? savedInputText : ""); %>
    <input type="text" name="jasyptKey" id="jasyptKey" required value="${fn:escapeXml(_savedJasyptKey)}"/>
    <label for="inputText">텍스트 입력:</label>
    <input type="text" name="inputText" id="inputText" required value="${fn:escapeXml(_savedInputText)}"/>
    <input type="submit" value="실행"/>
</form>

<% if (result != null) {
    request.setAttribute("_message", message);
    request.setAttribute("_result", result);
%>
<div class="result">
    <strong>${fn:escapeXml(_message)}</strong><br/>
    <p>${fn:escapeXml(_result)}</p>
</div>
<% } %>

</div>

<%!
    private StringEncryptor stringEncryptor(String key) {
        PooledPBEStringEncryptor encryptor = new PooledPBEStringEncryptor();
        SimpleStringPBEConfig config = new SimpleStringPBEConfig();
        Class<?> c = org.jasypt.encryption.pbe.config.SimpleStringPBEConfig.class;
        System.out.println("SimpleStringPBEConfig codeSource = " +
                c.getProtectionDomain().getCodeSource());
        // 암호화키
        config.setPassword(key);
        // 알고리즘
        config.setAlgorithm("PBEWITHHMACSHA512ANDAES_256");
        // 반복할 해싱 회수
        config.setKeyObtentionIterations("1000");
        // 인스턴스 pool
        config.setPoolSize("1");
        config.setProviderName("SunJCE");
        // salt 생성 클래스
        config.setSaltGeneratorClassName("org.jasypt.salt.RandomSaltGenerator");
        config.setIvGeneratorClassName("org.jasypt.iv.RandomIvGenerator");
        //인코딩 방식
        config.setStringOutputType("base64");
        encryptor.setConfig(config);
        return encryptor;
    }
%>
</body>
</html>
