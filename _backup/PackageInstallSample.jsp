<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="com.steg.pkg.target.impl.EntityPackager" %>
<%@ page import="com.steg.pkg.vo.PackageResult" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="com.steg.pkg.Installer" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<html>
<head>
    <script type="text/javascript" src="../../xplugin/jquery/jquery-3.7.1.min.js"></script>
</head>
<body>
<div>
    <form action="PackageInstallSample.jsp" method="POST" enctype="multipart/form-data" id="formElem">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="file" name="packageFile" id="packageFile"/>
    </form>
    <input type="button" value="Upload" id="submit"/>
</div>

<script language="javascript">
    $('#submit').on("click", function (e) {
        var formData = new FormData($('#formElem')[0]);

        $.ajax({
            url: '/sample/PackageInstaller.jsp',
            type: 'POST',
            data: formData,
            cache: false,
            contentType: false,
            processData: false,
            beforeSend: function (xhr) {
                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}")
            },
            success: function (result) {
            },
            error: function (result) {
            }
        });
    });
</script>
</body>
</html>