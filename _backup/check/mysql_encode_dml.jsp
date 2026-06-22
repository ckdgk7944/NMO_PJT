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
<%@ page import="org.sdf.secure.SecureUtil" %>

<%
    ICE ice = ICE.getInstance();
    Sqls sqls = ice.sqls();

    Data data = new Data();
	
/* 	
	update itsm_account
	   set name     = ?,
	       part     = ?,
	       mail     = ?,
	       position = ?,
	       activate = ?,
	       expire   = ?,
	       mobile   = ?,
	       apply    = ?
	 where sno = ?
 */
    try {
        String sql_id = "IF.Dbsafer.Update";

        org.sdf.lang.Time activateTm = new org.sdf.lang.Time("20180401090000");
        org.sdf.lang.Time expireTm = new org.sdf.lang.Time("20180501090000");

        SimpleDateFormat simpleDt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String activateDt = simpleDt.format(activateTm.getTime());
        String expireDt = simpleDt.format(expireTm.getTime());

        //latin1인코딩
        String name = "윤정은";
        String part = "정보화기술팀";
        String position = "사원";

        //SHA-256암호화
        String mail = "";
        String mobile = "010-0000-0000";
        int apply = 0;

        name = new String(name.getBytes("utf-8"), "latin1");
        part = new String(part.getBytes("utf-8"), "latin1");
        position = new String(position.getBytes("utf-8"), "latin1");

        data.put("name", name);
        data.put("part", part);
        data.put("position", position);

        //mail = SHA.encrypt(mail);
        //mobile = SHA.encrypt(mobile);
        mail = SecureUtil.getInstance().getSecure(SecureUtil.SHA).encrypt(mail);
        mobile = SecureUtil.getInstance().getSecure(SecureUtil.SHA).encrypt(mobile);
        data.put("mail", mail);
        data.put("mobile", mobile);

        data.put("activate", activateDt);
        data.put("expire", expireDt);

        data.put("apply", 2);

        Log.act.info("name : " + name);
        Log.act.info("expireDt : " + expireDt);

        Log.act.info("mobile : " + mobile);

        Log.act.info("activateDt : " + activateDt);
        Log.act.info("expireDt : " + expireDt);

        String tran_name = new String(name.getBytes("latin1"), "utf-8");
        Log.act.info("tran_name : " + tran_name);
        TrxResult tr = sqls.execute(sql_id, data);
    } catch (BizError e) {
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
