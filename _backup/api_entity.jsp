<%@ page import="org.sdf.tool.JspCaller" %>
<%@ page import="org.apache.http.impl.client.CloseableHttpClient" %>
<%@ page import="org.apache.http.impl.client.HttpClients" %>
<%@ page import="org.apache.http.client.methods.HttpPost" %>
<%@ page import="org.apache.http.client.config.RequestConfig" %>
<%@ page import="com.oreilly.servlet.Base64Encoder" %>
<%@ page import="org.apache.http.HttpHeaders" %>
<%@ page import="org.apache.http.HttpEntity" %>
<%@ page import="org.apache.http.entity.StringEntity" %>
<%@ page import="org.apache.http.entity.ContentType" %>
<%@ page import="org.apache.http.client.methods.CloseableHttpResponse" %>
<%@ page import="org.apache.http.HttpStatus" %>
<%@ page contentType="text/html; charset=utf-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
    InputStream inputStream = null;
    BufferedReader reader = null;
    JSONObject result = new JSONObject();
    String errMessage = "";
    int addCount = 0;
    int updateCount = 0;

    try {
        inputStream = request.getInputStream();
        StringBuffer sb = new StringBuffer();
        if (inputStream != null) {
            reader = new BufferedReader(new InputStreamReader(inputStream, "utf-8"));
            char[] charBuffer = new char[128];
            int bytesRead = -1;
            while ((bytesRead = reader.read(charBuffer)) > 0) {
                sb.append(charBuffer, 0, bytesRead);
            }
        }

        String requestBody = sb.toString();


        JSONObject _body = (JSONObject) JSONValue.parse(requestBody);
        String ent_id = _body.getString("ent_id");
        JSONArray rows = _body.getArray("rows");

        System.out.println("=======================");
        System.out.println(_body.getString("ent_id"));
        System.out.println("=======================");

        if (StringUtil.valid(ent_id)) {
            if (rows != null && rows.size() > 0) {
                Entity entity = ICE.getInstance().map().getEntity(ent_id);
                if (entity != null) {
                    for (int i = 0; i < rows.size(); i++) {
                        // 저장할 엔터티 정보
                        JSONObject item = (JSONObject) rows.get(i);
                        // key 검증:
                        String key = String.valueOf(item.get("key"));

                        Row row = null;
                        if (StringUtil.valid(key)) {
                            row = entity.open(key);
                            Box data = convertJSONToBox(item);
                            if (StringUtil.invalid(row.getID())) {
                                 // 신규 등록 수행
                                row = entity.openNew(key);
                                data.put(entity.prefix + "_id", key);
                            }
                            entity.save(row, null, data, session, request);
                        } else {

                        }

                        // act값이 1이면 등록
                        if (row != null) {
                            if (row.getAct() == 1) {
                                addCount++;
                            } else if(row.getAct() == 2){
                                updateCount++;
                            }
                        }
                    }
                } else {
                    // 엔터티가 존재하지 않습니다.
                }

            } else {
                // 저장할 정보가 없습니다.
            }
        } else {
            // 엔터티정보가 누락된 잘못된 요청입니다.
        }

    } catch (SQLException ex) {
        Log.biz.err(ex);
    } catch (Exception ex) {
        Log.biz.err(ex);
        errMessage = ex.getMessage();
    }  finally {
        if (reader != null && inputStream != null) inputStream.close();
    }

    // 인터페이스 결과 설정
    if (StringUtil.valid(errMessage)) {
        // 에러
        result.put("status", "err");
        result.put("message", errMessage);
    } else {
        // 정상 처리 결과
        result.put("status", "success");
        result.put("add", addCount);
        result.put("updateCount", updateCount);

    }

    out.println(result.toString());
%>

<%!
    private static Box convertJSONToBox(JSONObject obj) {
        Box box = new Box("box");
        if (obj != null) {
            Iterator<String> keys = obj.keySet().iterator();
            while (keys.hasNext()) {
                String key = keys.next();
                box.put(key, obj.get(key));
            }
        }
        return box;
    }
%>