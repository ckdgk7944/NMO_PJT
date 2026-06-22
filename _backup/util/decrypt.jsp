<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.GsonBuilder" %>
<%@ page import="com.google.gson.JsonElement" %>
<%@ page import="com.google.gson.JsonParser" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%

    /**
     * 검증을 위한 복호화 Decrypt Util
     *
     */
    Box box = HttpUtility.getBox(request);


    String act = box.get("act");
    String token = box.get("token");
    String seckey = box.get("seckey");
    String format = "";

    // Key를 전달할 경우 해당 Key로
    if (StringUtil.invalid(seckey)) {
        seckey = Utils.getSessionSecureKey(session);
    }

    if("1".equals(act)) {

        String decValue = SecureUtil.getInstance().getSecure(SecureUtil.AES).decrypt(token, seckey);

        // Json Format
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        JsonParser jsonParser = new JsonParser();


        try {
            JSONObject jo = (JSONObject) JSONValue.parse(decValue);
            format = gson.toJson(jo.toJSONString());

            JsonElement je = jsonParser.parse(jo.toString());
            format = gson.toJson(je);

        } catch (BizException e) {
            Log.biz.err("Format error", e);
            format = "Format or Key IndicatorError";
        } catch (Exception e) {
            Log.biz.err("Format error", e);
            format = "Format or Key IndicatorError";
        }
    }

%>
<!doctype html>
<html lang="ko">
<body>
    <div>

        <h1>Decrypt Util</h1>
        <pre>
            * 전달 인자 중 _enc에 포함된 값을 사용해주세요.
        </pre>

        <form method="post">
            <input name="act" type="hidden" value="1">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <label>Sec Key</label>
            <br/>
            <input name="seckey" value="<%= seckey %>" style="width: 300px;"/>
            <textarea name="token" style="width: 90%; height: 150px;" placeholder="확인이 필요한 값을 입력하세요."><%= token %></textarea>

            <br/>
            <button>복호화</button>
        </form>

        <h1>Result</h1>
        <div>
            <textarea id="dec_val" name="dec_val" style="width: 90%; height: 150px;"><%= format %></textarea>
        </div>

    </div>
</body>
</html>
