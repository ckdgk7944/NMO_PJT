<%@ page contentType="application/json; charset=UTF-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ page import="com.steg.org.json.simple.*" %>
<%
    String layoutId  = request.getParameter("layout_id");
    String startDate = request.getParameter("start"); // YYYYMMDD
    String endDate   = request.getParameter("end");   // YYYYMMDD

    JSONObject resp = new JSONObject();
    Connection con  = null;
    try {
        if (layoutId == null || startDate == null || endDate == null)
            throw new Exception("layout_id, start, end 필수");

        con = new DBSource().getConnection("egene");

        /* ── Spaces ── */
        JSONArray spaces = new JSONArray();
        PreparedStatement ps = con.prepareStatement(
            "SELECT sos_id, sos_name, sos_type, sos_cap, sos_dept" +
            " FROM ESO_SO_SPACE" +
            " WHERE sos_layout_id = ? AND sos_type IN ('DESK','MEETING')" +
            " ORDER BY sos_type DESC, sos_name"
        );
        ps.setString(1, layoutId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            JSONObject s = new JSONObject();
            s.put("id",   rs.getString("sos_id"));
            s.put("name", rs.getString("sos_name") != null ? rs.getString("sos_name") : "");
            s.put("type", rs.getString("sos_type"));
            s.put("cap",  rs.getInt("sos_cap"));
            s.put("dept", rs.getString("sos_dept") != null ? rs.getString("sos_dept") : "");
            spaces.add(s);
        }
        rs.close(); ps.close();

        /* ── Bookings ── */
        JSONArray bookings = new JSONArray();
        String rangeStart = startDate + "000000";
        String rangeEnd   = endDate   + "235959";

        PreparedStatement ps2 = con.prepareStatement(
            "SELECT sob_id, sob_space_id, sob_start, sob_end, sob_emp_name, sob_note" +
            " FROM ESO_SO_BOOKING" +
            " WHERE sob_layout_id = ? AND sob_status != 'CANCEL'" +
            " AND sob_start < ? AND sob_end > ?" +
            " ORDER BY sob_start"
        );
        ps2.setString(1, layoutId);
        ps2.setString(2, rangeEnd);
        ps2.setString(3, rangeStart);
        ResultSet rs2 = ps2.executeQuery();
        while (rs2.next()) {
            JSONObject b = new JSONObject();
            b.put("id",      rs2.getString("sob_id"));
            b.put("spaceId", rs2.getString("sob_space_id"));
            b.put("start",   rs2.getString("sob_start"));
            b.put("end",     rs2.getString("sob_end"));
            b.put("empName", rs2.getString("sob_emp_name") != null ? rs2.getString("sob_emp_name") : "");
            b.put("note",    rs2.getString("sob_note")     != null ? rs2.getString("sob_note")     : "");
            bookings.add(b);
        }
        rs2.close(); ps2.close();

        resp.put("ok",       true);
        resp.put("spaces",   spaces);
        resp.put("bookings", bookings);

    } catch (Exception e) {
        resp.put("ok",    false);
        resp.put("error", e.getMessage());
        Log.biz.err("SO_BOOKINGS", e);
    } finally {
        if (con != null) try { con.close(); } catch (Exception ignore) {}
    }
    out.print(resp.toJSONString());
%>
