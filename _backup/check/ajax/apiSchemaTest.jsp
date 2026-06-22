<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.commons.codec.digest.Md5Crypt" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
    Box box = HttpUtility.getBox(request);

    Log.biz.info("here");
    Log.biz.info(box.toString());

    Connection src_connection = null;
    Connection tgt_connection = null;

    Map<String, Object> result = new HashMap<>();

    try {
        src_connection = getConnection(box.get("src_driver"), box.get("src_url"), box.get("src_id"), box.get("src_pw"));

        List src_tables = export(src_connection);

        tgt_connection = getConnection(box.get("tgt_driver"), box.get("tgt_url"), box.get("tgt_id"), box.get("tgt_pw"));

        List tgt_tables = export(tgt_connection);

        result.put("src", src_tables);
        result.put("tgt", tgt_tables);

    } catch (SQLException ex){
        Log.biz.err(ex);
        close(src_connection);
        close(tgt_connection);
    } catch (Exception ex){
        Log.biz.err(ex);
        close(src_connection);
        close(tgt_connection);
    }finally {
        close(src_connection);
        close(tgt_connection);
    }

    Gson gson = new Gson();
    gson.toJson(result, response.getWriter());
    response.getWriter().flush();

%>

<%!

    protected Connection getConnection(String driver, String url, String id, String pw) throws
            ClassNotFoundException,
            SQLException {

        Class.forName(driver);

        Connection connection = DriverManager.getConnection(url, id, pw);

        return connection;
    }

    public void close(Connection connection) {

        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ex) {
                Log.biz.err(ex);
            }
        }
    }

    public List export(Connection con) throws SQLException {

        List<Map> tables = new ArrayList();

        try (PreparedStatement preparedStatement = con.prepareStatement(SELECT_TABLES);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

            int colsize = resultSetMetaData.getColumnCount();
            //      System.out.println("colsize=" + colsize);
            //
            //      for(int i=1; i <= colsize; i++) {
            //        System.out.println("idx=" + i + "/col~" + resultSetMetaData.getColumnName(i));
            //      }

            while (resultSet.next()) {

                String table_name = resultSet.getString("table_name");
                //        System.out.println("table_name=" + table_name);

                printTableInfo(tables, con, table_name);

            }
        }

        return tables;

    }

    public List printTableInfo(List tables, Connection con, String tab) throws SQLException {

        try (PreparedStatement preparedStatement = con.prepareStatement(SELECT_COLUMN)) {
            preparedStatement.setString(1, tab);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                ResultSetMetaData resultSetMetaData = rs.getMetaData();

                int colsize = resultSetMetaData.getColumnCount();
                //    System.out.println("colsize=" + colsize);

                Vector<String> vector = new Vector<>(colsize);

                for (int i = 1; i <= colsize; i++) {
                    //      System.out.println("idx=" + i + "/col~" + resultSetMetaData.getColumnName(i));
                    vector.add(resultSetMetaData.getColumnName(i));
                    //            System.out.println("getColumnType=" + resultSetMetaData.getColumnType(i));
                    //            System.out.println("getColumnTypeName=" + resultSetMetaData.getColumnTypeName(i)); // VARCHAR
                    //            System.out.println("getColumnLabel=" + resultSetMetaData.getColumnLabel(i));
                    //            System.out.println("getCatalogName=" + resultSetMetaData.getCatalogName(i));
                    //            System.out.println("getColumnClassName=" + resultSetMetaData.getColumnClassName(i));
                    //            System.out.println("getColumnDisplaySize=" + resultSetMetaData.getColumnDisplaySize(i)); // 200

                }

                int rows = 0;

                List cols = new ArrayList();
                StringBuffer buf = new StringBuffer();

                buf.setLength(0);
                while (rs.next()) {

                    Map<String, String> col = new Hashtable<>();

                    buf.append(rs.getString("COLUMN_NAME")).append("|").append(rs.getString("column_type"));
                    for (String s : vector) {
                        String v = rs.getString(s);

                        v = (v == null) ? "" : v;

                        //        System.out.println(s + "=" + v);
                        col.put(s, v);

                    }

                    cols.add(col);

                    rows++;
                }

                Map tableInfo = new Hashtable();
                tableInfo.put("table", tab);
                tableInfo.put("colsize", rows);
                tableInfo.put("cols", cols);
                tableInfo.put("md5", createMD5(buf.toString()));
                tables.add(tableInfo);

                System.out.println("Rows= " + rows);
            }
        }

        return tables;
    }

    public String createMD5(String str) {

        String MD5 = "";

        try {

            MessageDigest md = MessageDigest.getInstance("SHA-256");

            md.update(str.getBytes());

            byte byteData[] = md.digest();

            StringBuffer sb = new StringBuffer();

            for (int i = 0; i < byteData.length; i++) {
                sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            }

            MD5 = sb.toString();

        } catch (NoSuchAlgorithmException ex) {
            Log.biz.err(ex);
            MD5 = null;
        }

        return MD5;
    }

    static final String SELECT_TABLES = "SELECT table_schema, TABLE_NAME \n" +
            "            FROM information_schema.TABLES\n" +
            "            WHERE table_schema = DATABASE() ORDER BY TABLE_NAME ";

    static final String SELECT_COLUMN = "SELECT \n" +
            "\tTABLE_NAME \n" +
            "\t,COLUMN_NAME \n" +
            "\t,column_type \n" +
            "\t,is_nullable \n" +
            "\t,column_key\n" +
            "\t,column_default \n" +
            "\t,ordinal_position \n" +
            "\t,data_type\n" +
            "FROM information_schema.COLUMNS\n" +
            "WHERE table_schema=DATABASE()\n" +
            "AND TABLE_NAME= ? \n" +
            "ORDER BY ordinal_position";
%>