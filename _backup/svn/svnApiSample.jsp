<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>SVN REST API 샘플</title>
    <script src="/xplugin/jquery/jquery-3.7.1.min.js"></script>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .section { margin-bottom: 30px; }
        textarea { width: 100%; height: 100px; }
        .result { background: #f8f8f8; border: 1px solid #ccc; padding: 10px; margin-top: 10px; white-space: pre-wrap; }
        label { display: inline-block; width: 100px; }
    </style>
</head>
<body>
<h2>SVN REST API 연동 샘플</h2>
<div class="section">
    <h3>1. SVN 연결 및 루트 디렉토리 트리 조회</h3>
    <label>URL</label><input type="text" id="svnUrl" value="" size="50"> <br>
    <label>Username</label><input type="text" id="svnUser" value=""> <br>
    <label>Password</label><input type="password" id="svnPass" value=""> <br>
    <button id="btnConnect">연결 및 트리 조회</button>
    <div id="treeResult" class="result"></div>
</div>
<div class="section">
    <h3>2. 디렉토리/파일 목록 조회</h3>
    <label>경로</label><input type="text" id="dirPath" value=""> <button id="btnList">조회</button>
    <div id="listResult" class="result"></div>
</div>
<div class="section">
    <h3>3. 파일 내용 조회</h3>
    <label>파일 경로</label><input type="text" id="filePath" value=""> <button id="btnFile">조회</button>
    <div id="fileResult" class="result"></div>
</div>
<div class="section">
    <h3>4. 파일 커밋 내역 조회</h3>
    <label>파일 경로</label><input type="text" id="commitFilePath" value=""> <button id="btnFileCommits">조회</button>
    <div id="commitResult" class="result"></div>
</div>
<script>
function getBaseReq() {
    return {
        url: $("#svnUrl").val(),
        username: $("#svnUser").val(),
        password: $("#svnPass").val()
    };
}
// CSRF 토큰/헤더명 추출
var csrfToken = $("meta[name='_csrf']").attr("content");
var csrfHeader = $("meta[name='_csrf_header']").attr("content");

function addCsrf(xhr) {
    if (csrfToken && csrfHeader) {
        xhr.setRequestHeader(csrfHeader, csrfToken);
    }
}

$(function() {
    $("#btnConnect").click(function() {
        var req = getBaseReq();
        $("#treeResult").text("조회 중...");
        $.ajax({
            url: "/api/svn/connect",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify(req),
            beforeSend: addCsrf,
            success: function(data) {
                $("#treeResult").text(JSON.stringify(data, null, 2));
            },
            error: function(xhr) {
                $("#treeResult").text("오류: " + xhr.responseText);
            }
        });
    });
    $("#btnList").click(function() {
        var req = getBaseReq();
        req.path = $("#dirPath").val();
        $("#listResult").text("조회 중...");
        $.ajax({
            url: "/api/svn/list",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify(req),
            beforeSend: addCsrf,
            success: function(data) {
                $("#listResult").text(JSON.stringify(data, null, 2));
            },
            error: function(xhr) {
                $("#listResult").text("오류: " + xhr.responseText);
            }
        });
    });
    $("#btnFile").click(function() {
        var req = getBaseReq();
        req.path = $("#filePath").val();
        $("#fileResult").text("조회 중...");
        $.ajax({
            url: "/api/svn/file",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify(req),
            beforeSend: addCsrf,
            success: function(data) {
                $("#fileResult").text(data.content ? data.content : JSON.stringify(data, null, 2));
            },
            error: function(xhr) {
                $("#fileResult").text("오류: " + xhr.responseText);
            }
        });
    });
    $("#btnFileCommits").click(function() {
        var req = getBaseReq();
        req.path = $("#commitFilePath").val();
        $("#commitResult").text("조회 중...");
        $.ajax({
            url: "/api/svn/file-commits",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify(req),
            beforeSend: addCsrf,
            success: function(data) {
                $("#commitResult").text(JSON.stringify(data, null, 2));
            },
            error: function(xhr) {
                $("#commitResult").text("오류: " + xhr.responseText);
            }
        });
    });
});
</script>
</body>
</html> 