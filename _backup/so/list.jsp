<%@ page contentType="application/json; charset=UTF-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ page import="com.steg.org.json.simple.*" %>
<%
    response.setHeader("Access-Control-Allow-Origin", "*");
    JSONArray arr = new JSONArray();
    Connection con = null;
    try {
        con = new DBSource().getConnection("egene");
        PreparedStatement ps = con.prepareStatement(
            "SELECT sol_id, sol_name, sol_reg_dttm," +
            "  (SELECT COUNT(*) FROM ESO_SO_SPACE s WHERE s.sos_layout_id = l.sol_id) AS ele_cnt" +
            " FROM ESO_SO_LAYOUT l" +
            " ORDER BY sol_reg_dttm DESC"
        );
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            JSONObject row = new JSONObject();
            row.put("layoutId",   rs.getString("sol_id"));
            row.put("layoutName", rs.getString("sol_name"));
            row.put("createdAt",  rs.getString("sol_reg_dttm"));
            row.put("eleCnt",     rs.getInt("ele_cnt"));
            arr.add(row);
        }
        rs.close(); ps.close();
    } catch (Exception e) {
        JSONObject err = new JSONObject();
        err.put("error", e.getMessage());
        arr.add(err);
        Log.biz.err("SO_LIST", e);
    } finally {
        if (con != null) try { con.close(); } catch (Exception ignore) {}
    }
    out.print(arr.toJSONString());
%>
