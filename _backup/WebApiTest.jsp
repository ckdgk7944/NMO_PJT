<%@ page import="org.sdf.tool.JspCaller" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%

    Box box = HttpUtility.getBox(request);

    String uri = box.get("uri");

    String requestBody =  HttpUtility.restore(box.get("requestBody"));

    String result = "";

    try {
        if (StringUtil.valid(uri) && StringUtil.valid(requestBody)) {
            Log.act.info(requestBody);
            JSONObject paramMap = (JSONObject) JSONValue.parse(requestBody);

            Log.act.info(paramMap.getString("id"));

            result = JspCaller.callAjax(uri, paramMap);
        }
    } catch(BizException e) {
        Log.biz.err(e);
    } catch (Exception ex) {
        Log.biz.err(ex);
    }

    if (!StringUtil.valid(uri)) {
        uri = "http://dev.egene.io/api/egene/";
        requestBody = "{\n" +
                "    \"id\":\"id\",\n" +
                "    \"name\":\"name\",\n" +
                "    \"cat_dd\":\"code value\",\n" +
                "    \"title\":\"title\",\n" +
                "    \"arr\":[]\n" +
                "}";
    }

%>

<html>
<head>
    <title>Title</title>
</head>
<body>

<form name="_form" method="post">

    <div>
        <button type="submit">테스트</button>
    </div>

    <div>
        <input name="uri" type="text" value="<%=uri%>" style="width: 100%;">
    </div>

    <div>
        <div style="float: left; width: 50%;">
            <div>Request Body:</div>
            <textarea name="requestBody" style="width: 100%; height: 500px;"><%=requestBody%></textarea>
        </div>

        <div style="float: left; width: 50%;">
            <div>Result:</div>
            <textarea name="response" style="width: 100%; height: 500px;"><%=result%></textarea>
        </div>

    </div>

</form>
</body>
</html>


