<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="com.steg.pkg.target.impl.EntityPackager" %>
<%@ page import="com.steg.pkg.vo.PackageResult" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="com.steg.pkg.Installer" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>

<%
    Box box = AttachUtil.getBox(request);

    File uploadFile = new File(box.get("packageFile.dir"), box.get("packageFile.name"));

    byte[] bytes = Files.readAllBytes(uploadFile.toPath());
    String content = new String(bytes, StandardCharsets.UTF_8);

    Installer installer = new Installer(content, session, request);
    PackageResult result = installer.install();

    Log.biz.info(result.getStatus().toString());
%>