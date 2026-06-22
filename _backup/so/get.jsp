<%@ page contentType="application/json; charset=UTF-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ page import="com.steg.org.json.simple.*" %>
<%
    response.setHeader("Access-Control-Allow-Origin", "*");
    String layoutId = request.getParameter("id");
    JSONObject resp = new JSONObject();
    Connection con = null;
    try {
        if (layoutId == null || layoutId.isEmpty()) throw new Exception("id 파라미터 필요");
        con = new DBSource().getConnection("egene");

        // 레이아웃 (캔버스 JSON = sol_descr)
        PreparedStatement ps = con.prepareStatement(
            "SELECT sol_id, sol_name, sol_descr, sol_reg_dttm" +
            " FROM ESO_SO_LAYOUT WHERE sol_id = ?"
        );
        ps.setString(1, layoutId);
        ResultSet rs = ps.executeQuery();
        if (!rs.next()) throw new Exception("레이아웃 없음: " + layoutId);

        JSONObject layout = new JSONObject();
        layout.put("layoutId",   rs.getString("sol_id"));
        layout.put("layoutName", rs.getString("sol_name"));
        layout.put("canvasJson", rs.getString("sol_descr"));   // CLOB → 캔버스 JSON
        layout.put("createdAt",  rs.getString("sol_reg_dttm"));
        rs.close(); ps.close();
        resp.put("layout", layout);

        // 공간 요소 목록
        PreparedStatement ep = con.prepareStatement(
            "SELECT sos_id, sos_fabric_id, sos_name, sos_type, sos_cap, sos_dept" +
            " FROM ESO_SO_SPACE" +
            " WHERE sos_layout_id = ?" +
            " ORDER BY sos_id"
        );
        ep.setString(1, layoutId);
        ResultSet er = ep.executeQuery();
        JSONArray elements = new JSONArray();
        while (er.next()) {
            JSONObject el = new JSONObject();
            el.put("id",        er.getString("sos_id"));
            el.put("fabricId",  er.getString("sos_fabric_id"));
            el.put("name",      er.getString("sos_name"));
            el.put("type",      er.getString("sos_type"));
            el.put("capacity",  er.getInt("sos_cap"));
            el.put("dept",      er.getString("sos_dept"));
            elements.add(el);
        }
        er.close(); ep.close();
        resp.put("elements", elements);
        resp.put("ok", true);

    } catch (Exception e) {
        resp.put("ok",    false);
        resp.put("error", e.getMessage());
        Log.biz.err("SO_GET", e);
    } finally {
        if (con != null) try { con.close(); } catch (Exception ignore) {}
    }
    out.print(resp.toJSONString());
%>
