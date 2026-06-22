<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.sdf.rdb.*, java.sql.*" %>
<%
    Connection con = null;
    StringBuilder log = new StringBuilder();
    try {
        con = new DBSource().getConnection("egene");

        String[] ddls = {
            "CREATE TABLE IF NOT EXISTS so_layout (" +
            "  so_layout_id   VARCHAR(50)   NOT NULL PRIMARY KEY," +
            "  so_layout_name VARCHAR(200)  NOT NULL," +
            "  so_canvas_json LONGTEXT," +
            "  so_created_at  DATETIME      DEFAULT NOW()" +
            ")",

            "CREATE TABLE IF NOT EXISTS so_element (" +
            "  so_ele_id        VARCHAR(200)  NOT NULL PRIMARY KEY," +
            "  so_layout_id     VARCHAR(50)   NOT NULL," +
            "  so_ele_fabric_id VARCHAR(50)," +
            "  so_ele_name      VARCHAR(200)," +
            "  so_ele_type      VARCHAR(50)," +
            "  so_ele_cap       INT           DEFAULT 0," +
            "  so_ele_dept      VARCHAR(200)," +
            "  INDEX idx_so_ele_layout (so_layout_id)" +
            ")"
        };

        for (String ddl : ddls) {
            Statement st = con.createStatement();
            st.executeUpdate(ddl);
            st.close();
            log.append("OK: ").append(ddl.substring(0, 50)).append("...<br>");
        }
        log.append("<b style='color:green'>테이블 생성 완료</b>");
    } catch (Exception e) {
        log.append("<b style='color:red'>오류: ").append(e.getMessage()).append("</b>");
    } finally {
        if (con != null) try { con.close(); } catch (Exception ignore) {}
    }
%>
<!DOCTYPE html><html><body style="font-family:monospace;padding:20px">
<h3>Smart Office — DB Setup</h3>
<%= log %>
<br><br><a href="/sample/so_list.jsp">목록 페이지로 이동</a>
</body></html>
