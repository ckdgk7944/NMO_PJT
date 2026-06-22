<%@ page contentType="application/json; charset=UTF-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ page import="java.io.*" %>
<%@ page import="com.steg.org.json.simple.*, com.steg.org.json.simple.parser.*" %>
<%
    response.setHeader("Access-Control-Allow-Origin", "*");

    StringBuilder sb = new StringBuilder();
    BufferedReader br = request.getReader();
    String line;
    while ((line = br.readLine()) != null) sb.append(line);

    JSONObject resp = new JSONObject();
    Connection con  = null;
    try {
        JSONParser parser = new JSONParser();
        JSONObject req = (JSONObject) parser.parse(sb.toString());

        String layoutName = (String) req.getOrDefault("layoutName", "이름 없음");
        String canvasJson = (String) req.getOrDefault("canvasJson", "{}");
        JSONArray elements = (JSONArray) req.getOrDefault("elements", new JSONArray());
        String existingId = (String) req.get("layoutId");

        con = new DBSource().getConnection("egene");

        // 기존 레이아웃 존재 여부 확인
        boolean isUpdate = false;
        if (existingId != null && !existingId.isEmpty()) {
            PreparedStatement chk = con.prepareStatement(
                "SELECT COUNT(*) FROM ESO_SO_LAYOUT WHERE sol_id = ?"
            );
            chk.setString(1, existingId);
            ResultSet cr = chk.executeQuery();
            cr.next();
            isUpdate = (cr.getInt(1) > 0);
            cr.close(); chk.close();
        }

        String layoutKey = isUpdate ? existingId : ("SOL-" + System.currentTimeMillis());

        if (isUpdate) {
            PreparedStatement upd = con.prepareStatement(
                "UPDATE ESO_SO_LAYOUT SET sol_name = ?, sol_descr = ? WHERE sol_id = ?"
            );
            upd.setString(1, layoutName);
            upd.setString(2, canvasJson);
            upd.setString(3, layoutKey);
            upd.executeUpdate();
            upd.close();

            PreparedStatement del = con.prepareStatement(
                "DELETE FROM ESO_SO_SPACE WHERE sos_layout_id = ?"
            );
            del.setString(1, layoutKey);
            del.executeUpdate();
            del.close();
        } else {
            PreparedStatement ins = con.prepareStatement(
                "INSERT INTO ESO_SO_LAYOUT (sol_id, sol_name, sol_descr, sol_reg_dttm) VALUES (?, ?, ?, NOW())"
            );
            ins.setString(1, layoutKey);
            ins.setString(2, layoutName);
            ins.setString(3, canvasJson);
            ins.executeUpdate();
            ins.close();
        }

        // SO_SPACE 저장
        int cnt = 0;
        for (Object obj : elements) {
            JSONObject el   = (JSONObject) obj;
            String fabricId = (String) el.getOrDefault("id", "");
            String spaceKey = "SOS-" + System.currentTimeMillis() + "-" + (cnt++);
            Object cap = el.get("capacity");
            int capVal = cap != null ? ((Number) cap).intValue() : 0;

            PreparedStatement ins2 = con.prepareStatement(
                "INSERT INTO ESO_SO_SPACE (sos_id, sos_layout_id, sos_fabric_id, sos_name, sos_type, sos_cap, sos_dept) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            ins2.setString(1, spaceKey);
            ins2.setString(2, layoutKey);
            ins2.setString(3, fabricId);
            ins2.setString(4, (String) el.getOrDefault("name", ""));
            ins2.setString(5, (String) el.getOrDefault("type", ""));
            ins2.setInt   (6, capVal);
            ins2.setString(7, (String) el.getOrDefault("dept", ""));
            ins2.executeUpdate();
            ins2.close();
        }

        resp.put("ok",       true);
        resp.put("layoutId", layoutKey);
        resp.put("count",    cnt);
        resp.put("updated",  isUpdate);

    } catch (Exception e) {
        resp.put("ok",    false);
        resp.put("error", e.getMessage());
        Log.biz.err("SO_SAVE", e);
    } finally {
        if (con != null) try { con.close(); } catch (Exception ignore) {}
    }
    out.print(resp.toJSONString());
%>
