<%@ page import="com.google.api.client.http.javanet.NetHttpTransport" %>
<%@ page import="com.google.api.client.googleapis.javanet.GoogleNetHttpTransport" %>
<%@ page import="com.google.api.services.sheets.v4.Sheets" %>
<%@ page import="com.google.api.services.sheets.v4.model.ValueRange" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.api.client.json.JsonFactory" %>
<%@ page import="com.google.api.client.json.gson.GsonFactory" %>
<%@ page import="com.google.api.services.sheets.v4.SheetsScopes" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.api.client.auth.oauth2.Credential" %>
<%@ page import="com.google.api.client.googleapis.auth.oauth2.GoogleCredential" %>

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
    // Build a new authorized API client service.
    final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
    final String spreadsheetId = "1mD7aFrCfEB6nb7K64luHPT30cs7MGxm4j79rQrGge-c";
    final String range = "R&D 개인 주간업무!A2:E";

    // get Google Access Token
    String accessToken = _user.get("emp_google_access_token");

    if (StringUtil.valid(accessToken)) {

        // 1. Credential 생성
        Credential credential = new GoogleCredential().setAccessToken(accessToken);

        // 2. Service 생성
        Sheets service =
                new Sheets.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential)
                        .setApplicationName(APPLICATION_NAME)
                        .build();

        // 3. 처리할 Sheet 정보 가져오기
        ValueRange res = service.spreadsheets().values()
                .get(spreadsheetId, range)
                .execute();

        // 4. 데이터 처리
        List<List<Object>> values = res.getValues();
        if (values == null || values.isEmpty()) {
            System.out.println("No data found.");
        } else {
            System.out.println("Name, Major");
            for (List row : values) {
                // Print columns A and E, which correspond to indices 0 and 4.
                if (row.size() >= 5) {
                    System.out.printf("%s, %s\n", row.get(0), row.get(4));
                }
            }
        }
    }
%>

<%!
    private static final String APPLICATION_NAME = "Google Sheets API Java Quickstart";
    private static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    private static final String TOKENS_DIRECTORY_PATH = "tokens";

    /**
     * Global instance of the scopes required by this quickstart.
     * If modifying these scopes, delete your previously saved tokens/ folder.
     */
    private static final List<String> SCOPES =
            Collections.singletonList(SheetsScopes.SPREADSHEETS_READONLY);
    private static final String CREDENTIALS_FILE_PATH = "/sample/credentials.json";


%>