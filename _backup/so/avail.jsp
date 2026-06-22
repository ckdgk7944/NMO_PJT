<%@ page contentType="application/json; charset=UTF-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ page import="com.steg.org.json.simple.*" %>
<%
    String spaceId = request.getParameter("space_id");
    String date    = request.getParameter("date"); // YYYYMMDD
    JSONArray arr  = new JSONArray();
    Connection con = null;
    try {
        if (spaceId == null || date == null) throw new Exception("space_id, date 필수");
        con = new DBSource().getConnection("egene");
        PreparedStatement ps = con.prepareStatement(
            "SELECT sob_id, sob_emp_name, sob_start, sob_end, sob_note" +
            " FROM ESO_SO_BOOKING" +
            " WHERE sob_space_id = ? AND sob_start LIKE ? AND sob_status != 'CANCEL'" +
            " ORDER BY sob_start"
        );
        ps.setString(1, spaceId);
        ps.setString(2, date + "%");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            JSONObject row = new JSONObject();
            row.put("id",      rs.getString("sob_id"));
            row.put("empName", rs.getString("sob_emp_name"));
            row.put("start",   rs.getString("sob_start"));
            row.put("end",     rs.getString("sob_end"));
            row.put("note",    rs.getString("sob_note"));
            arr.add(row);
        }
        rs.close(); ps.close();
    } catch (Exception e) {
        Log.biz.err("SO_AVAIL", e);
    } finally {
        if (con != null) try { con.close(); } catch (Exception ignore) {}
    }
    out.print(arr.toJSONString());
%>
