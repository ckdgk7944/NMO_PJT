<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%

  StringBuffer data = new StringBuffer();
  BufferedReader in = null;
  String inputLine;
  // body 에서 데이터 수신 후

  try {
      in = request.getReader();

      while((inputLine = in.readLine()) != null) {

        System.out.println(inputLine);
          data.append(inputLine);
      }
  } catch(IOException ex){
      ex.printStackTrace();

  } finally {
      if(in != null) {
          try {
              in.close();
          } catch(IOException ex) {
              throw ex;
          }
      }
  }

  JSONObject json = null;


  System.out.println(data.toString());
  json = (JSONObject) JSONValue.parse(data.toString());

  if(json != null) {
    System.out.println(json.toString());
    response.getWriter().print(json.toString());
  } else {
    System.out.println("JSON NULL");
    return;
  }


  JSONObject docinfo =  (JSONObject)(json.getArray("docinfo")).get(0);

  JSONArray appline = (JSONArray)(json.getArray("appline"));

  createApproval(appline.toJSONString(), data.toString(), docinfo.getString("title"), docinfo.getString("ent_id"), docinfo.getString("key"));


%>
<%!

  void createApproval(String items, String doc, String title, String ent_id, String src_id) {
      String sqlText = "INSERT INTO tmp_appr_test(apprt_status, apprt_reg_dttm, apprt_items, apprt_doc" +
        ", apprt_title, apprt_ent_id, apprt_src_id) " +
        "VALUES('C', GET_SYSDATE(), ?, ?, ?, ?, ?) ";


      TrxContext trx = null;
      JPreparedStatement pstmt = null;

    try {
      trx = new TrxContext(GlobalConfig.getInstance().getDbName());
      Connection con = trx.getConnection();
      // DB 트랜젝션 시작
      trx.begin();

      pstmt = new JPreparedStatement(con, sqlText);
      pstmt.setString(1, items);
      pstmt.setString(2, doc);
      pstmt.setString(3, title);
      pstmt.setString(4, ent_id);
      pstmt.setString(5, src_id);

      pstmt.execute();


      trx.commit();
    } catch (SQLException se) {
        Log.biz.err(se);
        if(trx != null)
            trx.rollback();
    } catch(Exception e) {
        Log.biz.err(e);
        if(trx != null)
            trx.rollback();
    } finally {
        if(pstmt != null) pstmt.close();
        if(trx != null) trx.close();
    }

  }
%>