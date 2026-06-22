<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="com.steg.pkg.target.impl.EntityPackager" %>
<%@ page import="com.steg.pkg.vo.PackageResult" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>

<%!

    public void sendToClient(HttpServletResponse response, String resp) throws IOException
    {
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"package.egene\"");

        try (BufferedInputStream  bis = new BufferedInputStream(new ByteArrayInputStream(resp.getBytes(StandardCharsets.UTF_8)));
             BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream()))
        {
            int readBytes = 0;
            while ((readBytes = bis.read()) != -1)
            {
                bos.write(readBytes);
            }
        }
    }
%>
<%
    Box box = HttpUtility.getBox(request);
    String entIds = box.get("ent_id");

    if (StringUtil.invalid(entIds))
    {
%>
<script>
alert('ENT ID DOESN\'T PROVIDED');
</script>
<%
        return;
    }

    String[] entIdArray = entIds.split(",");
    EntityPackager packager = new EntityPackager(entIdArray);
    PackageResult packed = packager.pack();
    String checksum = packed.getChecksum();

    if (packed.isOk())
    {
        sendToClient(response, packed.getResult());
    }

    if (StringUtil.valid(checksum))
    {
%>
<script>
alert('<%= checksum%>');
</script>
<%
    }
%>