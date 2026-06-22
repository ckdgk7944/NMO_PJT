<%@ page contentType="application/json; charset=UTF-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ page import="com.steg.org.json.simple.*" %>
<%
    JSONObject resp = new JSONObject();
    try {
        org.sdf.rdb.Sqls sqls = ICE.getInstance().sqls();

        // 엔터티 필드 조회
        com.steg.efc.Entity solEnt = ICE.getInstance().map().getEntity("SO_LAYOUT");
        com.steg.efc.Entity sosEnt = ICE.getInstance().map().getEntity("SO_SPACE");

        JSONObject sol = new JSONObject();
        sol.put("found",  solEnt != null);
        if (solEnt != null) {
            sol.put("prefix", solEnt.prefix);
            sol.put("tableName", solEnt.getTableName());
            JSONArray fields = new JSONArray();
            for (com.steg.efc.Field f : solEnt.getFields()) {
                JSONObject fo = new JSONObject();
                fo.put("id",   f.id);
                fo.put("name", f.name);
                fo.put("type", f.type);
                fields.add(fo);
            }
            sol.put("fields", fields);
        }

        JSONObject sos = new JSONObject();
        sos.put("found", sosEnt != null);
        if (sosEnt != null) {
            sos.put("prefix", sosEnt.prefix);
            sos.put("tableName", sosEnt.getTableName());
            JSONArray fields = new JSONArray();
            for (com.steg.efc.Field f : sosEnt.getFields()) {
                JSONObject fo = new JSONObject();
                fo.put("id",   f.id);
                fo.put("name", f.name);
                fo.put("type", f.type);
                fields.add(fo);
            }
            sos.put("fields", fields);
        }

        resp.put("SO_LAYOUT", sol);
        resp.put("SO_SPACE",  sos);
        resp.put("ok", true);

    } catch (Exception e) {
        resp.put("ok", false);
        resp.put("error", e.getMessage());
    }
    out.print(resp.toJSONString());
%>
