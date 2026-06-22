<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="org.sdf.servlet.*,
                 org.sdf.rdb.*,
                 org.sdf.util.*,
                 org.sdf.log.*,
                 org.sdf.lang.*,
                 com.steg.org.json.simple.*"
         import="java.util.*,java.sql.*"
         import="com.steg.efc.*"
         import="java.text.SimpleDateFormat"

%>

<%
    ICE ice = ICE.getInstance();
    Sqls sqls = ice.sqls();

    try {
        String sql_id = "IF.Dbsafer.Update";

        Result r = sqls.getResult("IF.NodeSafer.Select");
        RecordSet rs = r.getRecordSet();

        rs.next();

        //  지금 insert into psync.itsm_account(sno,name,part,mail,position,activate,expire,mobile,apply)
        // values('1607882','성정은','테스트','1607882@mobis.co.kr','사원','2018-06-28 00:00:00','2018-06-30 00:00:00','010-1111-11111',0)

        String name = rs.get("name");
        out.println("org_name : " + name);

        String tmp_name = new String("성정은".getBytes("utf-8"), "latin1");
        out.println("tmp_name : " + tmp_name);
    } catch (UnsupportedEncodingException e) {
        Log.biz.err(e);
    } catch (Exception e) {
        Log.biz.err(e);
    }

%>
<html>
<style>
    html, body {
        font: 11px dotum;
    }

    th {
        font: bold 11px dotum;
        background-color: #afafaf;
    }

    td {
        font: 11px dotum;
    }
</style>
<body>
<%-- 
결과 :<%= tr.getCount() %><br>
--------------------------<br>	
Key : <%= tr.getKey() %><br>
--------------------------<br>	
	Error : <%= tr.isError %><br>
	<%= tr.getException() %>
 --%>
</body>
</html>		
