<%@ page contentType="application/json; charset=UTF-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ page import="java.io.*" %>
<%@ page import="com.steg.org.json.simple.*, com.steg.org.json.simple.parser.*" %>
<%
    StringBuilder sb = new StringBuilder();
    BufferedReader br = request.getReader();
    String line;
    while ((line = br.readLine()) != null) sb.append(line);

    JSONObject resp = new JSONObject();
    Connection con  = null;
    try {
        JSONParser parser = new JSONParser();
        JSONObject req = (JSONObject) parser.parse(sb.toString());

        String spaceId   = (String) req.get("spaceId");
        String layoutId  = (String) req.get("layoutId");
        String spaceName = (String) req.getOrDefault("spaceName", "");
        String startDttm = (String) req.get("start");  // YYYYMMDDHHMMSS
        String endDttm   = (String) req.get("end");
        String note      = (String) req.getOrDefault("note", "");

        User user    = (User) session.getAttribute("egene.user");
        String empId   = (user != null) ? user.emp_id          : "guest";
        String empName = (user != null) ? user.get("emp_name") : "비회원";

        if (spaceId == null || startDttm == null || endDttm == null)
            throw new Exception("필수 파라미터 누락");

        if (startDttm.compareTo(endDttm) >= 0)
            throw new Exception("종료 시간은 시작 시간 이후여야 합니다");

        con = new DBSource().getConnection("egene");

        // 중복 예약 확인
        PreparedStatement chk = con.prepareStatement(
            "SELECT COUNT(*) FROM ESO_SO_BOOKING" +
            " WHERE sob_space_id = ? AND sob_status != 'CANCEL'" +
            " AND sob_start < ? AND sob_end > ?"
        );
        chk.setString(1, spaceId);
        chk.setString(2, endDttm);
        chk.setString(3, startDttm);
        ResultSet cr = chk.executeQuery();
        cr.next();
        int overlap = cr.getInt(1);
        cr.close(); chk.close();

        if (overlap > 0) {
            resp.put("ok",    false);
            resp.put("error", "해당 시간에 이미 예약이 있습니다");
        } else {
            String bookKey = "SOB-" + System.currentTimeMillis();
            PreparedStatement ins = con.prepareStatement(
                "INSERT INTO ESO_SO_BOOKING " +
                "(sob_id, sob_layout_id, sob_space_id, sob_space_name," +
                " sob_start, sob_end, sob_emp_id, sob_emp_name, sob_status, sob_note)" +
                " VALUES (?,?,?,?,?,?,?,?,?,?)"
            );
            ins.setString(1,  bookKey);
            ins.setString(2,  layoutId);
            ins.setString(3,  spaceId);
            ins.setString(4,  spaceName);
            ins.setString(5,  startDttm);
            ins.setString(6,  endDttm);
            ins.setString(7,  empId);
            ins.setString(8,  empName);
            ins.setString(9,  "CONFIRM");
            ins.setString(10, note);
            ins.executeUpdate();
            ins.close();

            resp.put("ok",     true);
            resp.put("bookId", bookKey);
        }
    } catch (Exception e) {
        resp.put("ok",    false);
        resp.put("error", e.getMessage());
        Log.biz.err("SO_BOOK", e);
    } finally {
        if (con != null) try { con.close(); } catch (Exception ignore) {}
    }
    out.print(resp.toJSONString());
%>
