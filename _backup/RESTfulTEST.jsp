<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
    List l = new ArrayList();



    for(int i=0; i < 10; i++) {
        Map m = new HashMap();
        m.put("EMP_ID",         "t_user_" + i);
        m.put("EMP_NAME",       "t_이름_" + i);
        m.put("EMP_PASSWORD",   "a#t_user_" + i);
        m.put("EMP_ORG_ID",     "STEG");
        m.put("EMP_DPT_ID",     "IT담당");
        m.put("EMP_TITLE_CD",   "팀원");
        m.put("EMP_USED",       "1");
        m.put("EMP_EMAIL",      "t_user_" + i + "@steg.co.kr");

        l.add(m);
    }
    Map jsonObject = new HashMap();
    jsonObject.put("rows", l);


%>
<%= JSONObject.toJSONString(jsonObject) %>

