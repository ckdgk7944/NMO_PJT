<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="ch.qos.logback.classic.LoggerContext" %>
<%@ page import="org.slf4j.LoggerFactory" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
    /**
     * 로그를 감시하여 특정 단어가 들어간 내용을 선별하여 전달한다.
     * 여러 로그파일에서 특정 단어가 들어간 내용을 확인하여 전달한다.
     *
     * {
     *    "filters": ["exception", "error"],
     *    "path": ["/egene/logs/cfg.log", "/egene/logs/biz.log"],
     *    "mail: ["test@steg.co.kr"],
     *    "sendrow": 5
     * }
     */

    String o = GlobalConfig.getInstance().getValue("log_watcher");
    JSONObject confObj = null;

    if(o == null) {
        confObj = new JSONObject();

        JSONArray conf_filters = new JSONArray();
        conf_filters.add("Exception");
        conf_filters.add("IndicatorError");
        confObj.put("filters", conf_filters);

        JSONArray conf_path = new JSONArray();
        conf_path.add(getLogHome() + "\\cfg.log");
        conf_path.add(getLogHome() + "\\biz.log");
        confObj.put("path", conf_path);

        JSONArray conf_email = new JSONArray();
        conf_email.add("");
        confObj.put("mail", conf_email);
        confObj.put("sendrow", 5);

    } else {
        confObj = (JSONObject) JSONValue.parse(o);

    }
    String[] filters = new String[0];
    int sendRow = 5;
    String path[] = new String[0];
    String to[] = new String[0];
    String[] cc = new String[]{};

    // 감시 문구
    // String filters[] = new String[]{"Config IndicatorError"};
    if(confObj.get("filters") != null) {
        filters = (String[]) confObj.getArray("filters").toArray(new String[0]);
    }

    // 전달에 필요한 Row
    if(confObj.get("sendrow") != null) {
        sendRow = confObj.getInt("sendrow");
    }


    // 감사 파일
//    String path[] =  new String[]{"C:\\egene\\logs\\cfg.log", "C:\\egene\\logs\\biz.log"};
    if(confObj.get("path") != null) {
        path = (String[]) confObj.getArray("path").toArray(new String[0]);
    }

//    String to = "jwpark@steg.co.kr";

    if(confObj.get("mail") != null) {
        to =(String[]) confObj.getArray("mail").toArray(new String[0]);
    }

    StringBuffer logTail = new StringBuffer();

    if(filters.length == 0 || path.length == 0) {
        logTail.append("=========================================================<br>");
        logTail.append("              ").append("설정된 필터나 파일이 없습니다.").append(Time.cur_dttm()).append("<br>");
        logTail.append("=========================================================<br>");
    }
    else {


        logTail.append("=========================================================<br>");
        logTail.append("              ").append("Log Watcher         ").append(Time.cur_dttm()).append("<br>");
        logTail.append("              ").append("Send Line         ").append(sendRow).append("<br>");
        logTail.append("=========================================================<br>");

        for (String p : path) {

            logTail.append("=========================================================<br>");
            logTail.append("              ").append(p).append("                      <br>");
            logTail.append("=========================================================<br>");
            logTail.append(checkLogFile(p, filters, sendRow, "<br>"));
        }
    }

    String from_emp_id = "Log Watcher";
    String to_emp_id = "LogWatcher";
    String title = "[LogWatcher] " + Time.cur_dttm();
    Data data = new Data();

    for(String to_addr : to) {
        boolean b1 = sendMail(to_addr, cc, from_emp_id, to_emp_id, title, logTail.toString(), data);
    }

%>

<h1>Log Watcher</h1>
<div>
<%= logTail.toString() %>
</div>
<%!

    StringBuffer checkLogFile(String path, String[] filters, int sendRow, String delim) {
        String curLine;
        int curLineCount = 0;
        int curSendRow = 0;
        boolean isSendRow = false;

        StringBuffer logTail = new StringBuffer();

        if(filters == null && filters.length == 0) {
            Log.biz.err("Filter null or size zero");
            return logTail;
        }


        String lowFilters[] = new String[filters.length];
        for(int i=0; i < filters.length; i++) {
            lowFilters[i] = filters[i].toLowerCase(Locale.ROOT);
        }

        // 파일 읽기 모드
        try (RandomAccessFile raf = new RandomAccessFile(path, "r")) {

            while ((curLine = raf.readLine()) != null) {

                // UTF-8파일의 경우 한글깨짐으로 변환 작업
                String msg = (new String(curLine.getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8));
                String lowMsg = msg.toLowerCase(Locale.ROOT);

                curLineCount++;

                if(isSendRow) {
                    //Log.biz.info("Line{} //{}", curLineCount, msg);
                    logTail.append(curLineCount).append(" ").append(msg).append(delim); // 개행 문자 추가
                    curSendRow++;

                    if(sendRow < curSendRow) {
                        isSendRow = false;
                        curSendRow = 0;
                    }
                    continue;
                }


                for(String s : lowFilters) {
                    int idx = lowMsg.indexOf(s);

                    if(idx == -1) continue;
                    else {
                        //Log.biz.info("Line{} //{}", curLineCount, msg);
                        logTail.append(curLineCount).append(" ").append(msg).append(delim); // 개행 문자 추가

                        isSendRow = true;
                        curSendRow = 1;
                    }
                }
            }


        } catch (IOException ioe) {
            Log.biz.err(ioe);
        }

        return logTail;

    }
%>
<%!
    boolean sendMail(String to, String[] cc, String from_id, String to_id, String title, String content, Data d) {

        GlobalConfig gcfg = GlobalConfig.getInstance();
        String strMail = gcfg.value("mail");
        String smtpServer = "";
        int port = 25;
        String user = "";
        String passwd = "";

        String from = "";
        String from_name = "";

        boolean ssl = false;
        boolean tls = false;

        boolean test_mode = false;
        String[] test_to = null;
        String[] test_cc = null;

        JSONObject mobj = (JSONObject) JSONValue.parse(strMail);

        if (mobj != null) {

            JSONObject smtp = (JSONObject) mobj.getObject("smtp");
            smtpServer = smtp.getString("server");
            port = smtp.getInt("port");
            boolean debug = smtp.getBoolean("debug");
            String security = smtp.getString("security");

            if(port == 0) {
                port = 25;
            }
            user = smtp.getString("user");
            passwd = smtp.getString("passwd");
            ssl = smtp.getBoolean("ssl");

            from = mobj.getString("from");
            from_name = mobj.getString("from_name");
            test_mode = mobj.getBoolean("test_mode");
            String tmp_email = mobj.getString("test_to");
            String tmp_cc_email = mobj.getString("test_cc");

            test_to = StringUtil.getArray(tmp_email, ",");
            test_cc = StringUtil.getArray(tmp_cc_email, ",");

            org.sdf.tool.MailTool mtool = null;
            if("".equals(user)) {
                mtool = new org.sdf.tool.MailTool(smtpServer, port);
            } else {
                mtool = new org.sdf.tool.MailTool(smtpServer, port, user, passwd);
            }

            if("ssl".equals(security)) {
                mtool.setSSL(true);
            } else if("tls".equals(security)) {
                mtool.setTLS(true);
            }

            mtool.setDebug(debug);

            boolean b = false;
            if(test_mode) {

                for(int i = 0; i < test_to.length; i++) {

                    to = test_to[i];
                    boolean b1 = mtool.send(from_name, from, to, cc, title, content, null);
                    b = b || b1;
                    Log.act.info("> Send Mail[Test Mode] : [" + d.get("key") + "](" + from + ":" + from_id + ")->(" + to + ":" + to_id + "):" + b1 + ":" + title);
                }
            } else {
                b = mtool.send(from_name, from, to, cc, title, content, null);
            }

            insertMailLog(b, d);
            return b;

        } else {
            Log.act.err("sendMail :" + strMail);
        }

        insertMailLog(false, d);
        return false;
    }

    public void insertMailLog(boolean status, Data msgData){
        String sql_id = "Mail.Dml.logging";

        Data d = new Data();

        d.putAll(msgData);

        if(status) {
            d.put("result", "true");
        } else {
            d.put("result", "false");
        }
        Sqls sqls = Sqls.getInstance();
        TrxResult tr = sqls.execute(sql_id, d, true); // 이력 저장
    }

    public String getLogHome() {
        LoggerContext lc = (LoggerContext) LoggerFactory.getILoggerFactory();
        return lc.getProperty("LOG_HOME");
    }
%>