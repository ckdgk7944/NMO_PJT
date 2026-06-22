<%@ page import="org.sdf.thread.ThreadPool" %>
<%@ page import="com.steg.util.action.*" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
  /**
   * 원격 접속 모니터링
   */

  ThreadPool pool = ActionReceiver.getInstance().getPool();

  List usedList = pool.getUsedThread();


%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <style>
      .table_component {
          overflow: auto;
          width: 100%;
      }

      .table_component table {
          border: 1px solid #dededf;
          height: 100%;
          width: 100%;
          table-layout: fixed;
          border-collapse: collapse;
          border-spacing: 1px;
          text-align: left;
      }

      .table_component caption {
          caption-side: top;
          text-align: left;
      }

      .table_component th {
          border: 1px solid #dededf;
          background-color: #eceff1;
          color: #000000;
          padding: 5px;
      }

      .table_component td {
          border: 1px solid #dededf;
          background-color: #ffffff;
          color: #000000;
          padding: 5px;
      }
  </style>
</head>
<body>
<div class="table_component">
  <table style="border: 1px solid grey">
    <colgroup>
      <col width="120">
      <col >
      <col width="120">
    </colgroup>
    <tr>
      <th align="center">No</th>
      <th align="center">URL</th>
      <th align="center">Start</th>
    </tr>
  <%
    Iterator i = usedList.iterator();
    int idx=1;
    while (i.hasNext()) {
  %>
    <tr>
  <%
      ActionWorker worker = (ActionWorker)i.next();
      IActionEvent actionEvent = worker.getActionEvent();

      if(actionEvent == null) {
        Log.biz.info("Event is null");
      } else if(actionEvent instanceof UriActionEvent) {
        UriActionEvent uriActionEvent = (UriActionEvent) actionEvent;
  %>
      <td align="center"><%= idx++ %></td>
      <td><%= uriActionEvent.name %></td>
      <td><%= uriActionEvent.getStartTime() %></td>
  <%

        Log.biz.info("Type:" + uriActionEvent.toString());
      } else {
        Log.biz.info(actionEvent.toString());
      }
  %>
    </tr>
  <%
    }

  %>
  </table>
</div>

<button id="btnstop">STOP</button>
<label>Timer</label><input id="timer" />
</body>
<script>


  window.onload= function(){
    let isFlag = true;
    let nTimer = 0;
    let nextTimer = 100;
    let maxTimer = 2000;
    let btnstop = document.getElementById("btnstop");
    let timer = document.getElementById("timer");

    timer.value = nTimer;
    btnstop.onclick = function() {
      isFlag = !isFlag;
      if(isFlag) {
        setTimeout(fnTimeCheck, nextTimer);
      }
    };

    setTimeout(fnTimeCheck, nextTimer);

    function fnTimeCheck(){

      if(isFlag) {
        nTimer += nextTimer;
        timer.value = nTimer;

        if(nTimer > maxTimer) {
          window.location.reload();
        }
        setTimeout(fnTimeCheck, nextTimer);
      }

    }



  }
</script>
</html>