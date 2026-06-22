<%@ page import="com.google.api.client.http.javanet.NetHttpTransport" %>
<%@ page import="com.google.api.client.googleapis.javanet.GoogleNetHttpTransport" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.api.client.json.JsonFactory" %>
<%@ page import="com.google.api.client.json.gson.GsonFactory" %>
<%@ page import="com.google.api.services.sheets.v4.SheetsScopes" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.api.client.auth.oauth2.Credential" %>
<%@ page import="com.google.api.client.googleapis.auth.oauth2.GoogleCredential" %>
<%@ page import="com.google.api.services.calendar.Calendar" %>
<%@ page import="com.google.api.client.util.DateTime" %>
<%@ page import="com.google.api.services.calendar.model.Events" %>
<%@ page import="com.google.api.services.calendar.model.Event" %>
<%@ page import="com.google.auth.oauth2.GoogleCredentials" %>
<%@ page import="org.springframework.util.ResourceUtils" %>
<%@ page import="com.google.api.services.calendar.CalendarScopes" %>

<%--
  Created by IntelliJ IDEA.
  User: jae-haggo
  Date: 2023/06/02
  Time: 4:15 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/include/session.jspf" %>
<%
    /*
    String keyFileName = "credentials.json";
    InputStream keyFile = ResourceUtils.getURL("classpath:" + keyFileName).openStream();
    GoogleCredentials credentials = GoogleCredentials.fromStream(keyFile).createScoped(Arrays.asList(CalendarScopes.CALENDAR)).createDelegated("jhgo@steg.co.kr");
    */

    // 엔터티 정보
    Entity entity = ICE.getInstance().map().getEntity("ICM");
    //entity.fields;
    //entity.masterTable.fields;

    // 엔터티 티켓 조회
    Row row = entity.open("SR2306-00353");

    // 엔터티 티켓 신규 생성
    Row newRow = entity.openNew();

    // 엔터티 티켓 업데이트
    Data data = new Data();
    data.put("icm_req_title", "업데이트 정보");
    data.put("icm_req_content", "업데이트 정보");

    // 컨트롤 버튼 정보
    Wfms wfms = Wfms.getInstance();
    Control ctl = wfms.getControl("CTL02431");
    entity.save(newRow, ctl, data, request);



    // Build a new authorized API client service.
    final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();

    // get Google Access Token
    String accessToken = _user.get("emp_google_access_token");

    if (StringUtil.valid(accessToken)) {

        Credential credential = new GoogleCredential().setAccessToken(accessToken);

        Calendar service =
                new Calendar.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential)
                        .setApplicationName(APPLICATION_NAME)
                        .build();

        // List the next 10 events from the primary calendar.
        DateTime now = new DateTime(System.currentTimeMillis());
        Events events = service.events().list("primary")
                .setMaxResults(10)
                .setTimeMin(now)
                .setOrderBy("startTime")
                .setSingleEvents(true)
                .execute();
        List<Event> items = events.getItems();
        if (items.isEmpty()) {
            System.out.println("No upcoming events found.");
        } else {
            System.out.println("Upcoming events");
            for (Event event : items) {
                DateTime start = event.getStart().getDateTime();
                if (start == null) {
                    start = event.getStart().getDate();
                }
                System.out.printf("%s (%s)\n", event.getSummary(), start);
            }
        }
    }
%>

<%!
    private static final String APPLICATION_NAME = "EGENE";
    private static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();

%>