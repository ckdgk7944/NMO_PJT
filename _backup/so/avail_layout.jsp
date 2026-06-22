<%@ page contentType="application/json; charset=UTF-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ page import="com.steg.org.json.simple.*" %>
<%
    String layoutId = request.getParameter("layout_id");
    String date     = request.getParameter("date"); // YYYYMMDD
    JSONObject result = new JSONObject();
    Connection con = null;
    try {
        if (layoutId == null || date == null) throw new Exception("layout_id, date 필수");
        con = new DBSource().getConnection("egene");
        PreparedStatement ps = con.prepareStatement(
            "SELECT sob_space_id, sob_emp_name, sob_start, sob_end" +
            " FROM ESO_SO_BOOKING" +
            " WHERE sob_layout_id = ? AND sob_start LIKE ? AND sob_status != 'CANCEL'" +
            " ORDER BY sob_start"
        );
        ps.setString(1, layoutId);
        ps.setString(2, date + "%");
        ResultSet rs = ps.executeQuery();
        JSONObject bySpace = new JSONObject();
        while (rs.next()) {
            String spId = rs.getString("sob_space_id");
            if (!bySpace.containsKey(spId)) bySpace.put(spId, new JSONArray());
            JSONObject bk = new JSONObject();
            bk.put("empName", rs.getString("sob_emp_name"));
            bk.put("start",   rs.getString("sob_start"));
            bk.put("end",     rs.getString("sob_end"));
            ((JSONArray) bySpace.get(spId)).add(bk);
        }
        rs.close(); ps.close();
        result.put("ok",       true);
        result.put("bookings", bySpace);
    } catch (Exception e) {
        result.put("ok",    false);
        result.put("error", e.getMessage());
        Log.biz.err("SO_AVAIL_LAYOUT", e);
    } finally {
        if (con != null) try { con.close(); } catch (Exception ignore) {}
    }
    out.print(result.toJSONString());
%>
