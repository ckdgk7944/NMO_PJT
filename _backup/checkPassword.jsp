<%--
  Created by IntelliJ IDEA.
  User: jhgo
  Date: 2023-04-11
  Time: 오후 4:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>

<%
    // 연속 문자열 확인
    String checkStr = "ABCD";
    byte[] bytes = checkStr.getBytes();


    int preCode = -999;
    int cnt = -1;
    for (byte b : bytes) {
        //System.out.println(b);
        if ((preCode + 1) == b) {
            cnt++;
        } else {
            cnt = 1;
        }
        System.out.println(cnt);
        if (cnt >= 4) {
            System.out.println("Invalid :: " + cnt);
            break;
        }
        preCode = b;
    }

    //checkPattern();

%>

<%!
    private void checkPattern() {

        // Test Set
        String[] testSet = {
                "votmdnj&em123"
                , "kjs@aldkjfklj43"
                , "QBWfklj4543"
                , "abct438983"
                , "acdf@sabcer9182"
                , "alfl234kdd"
                , "asd@fasdf987"
                // Blank 테스트 문자열
                , "xp@tmxm85 84"
                // 공백 테스트 문자열
                , ""
                // 문자 길이 테스트 문자열
                , "OJHDSJK@HFzDLKDJLJoiejwf42^%wij"
                , "xyz47@"
                , "1lkjvneim@"
                // ASCII Overflow 테스트 문자열
                , "/01alkjdffn"
                , "9:;aslkdjfkja2"
                , "?@alakjlkiie3"
                , "Z[\\ekjmvkfd4"
                , "@abieofinv2"
                , "89:8973589723dfasb"
                , "YZ[qoe irnvk35"
                , "s3d@\"!$%&\'()*+,"
                , "bb2/:;<>=?@[\\]"
                , "abe1aseb_`|~-.{}"
        };

        for (String s : testSet) {
            System.out.println("Password: \"" + s + "\"");
            try {
                Utils.validPassword(s, null);
                System.out.println("valid");
            } catch (BizException ex) {
                System.out.println(ex.getMessage());
            } catch (Exception ex) {
                System.out.println(ex.getMessage());
            }

            System.out.println("--------------------------------");
        }
    }
%>