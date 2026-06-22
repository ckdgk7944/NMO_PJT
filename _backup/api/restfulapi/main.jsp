<%@ page import="org.apache.http.impl.client.HttpClientBuilder" %>
<%@ page import="org.apache.http.client.methods.HttpPost" %>
<%@ page import="org.apache.http.NameValuePair" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.apache.http.message.BasicNameValuePair" %>
<%@ page import="org.apache.http.client.entity.UrlEncodedFormEntity" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="com.steg.org.json.simple.JSONObject" %>
<%@ page import="com.steg.org.json.simple.JSONValue" %>
<%@ page import="org.apache.http.impl.client.CloseableHttpClient" %>
<%@ page import="org.apache.http.client.methods.CloseableHttpResponse" %>
<%@ page import="org.sdf.log.Log" %>
<%@ page import="org.sdf.slim.BizException" %>
<%--
  Created by IntelliJ IDEA.
  User: jhgo
  Date: 2021-08-03
  Time: 오후 4:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%

    com.steg.efc.Texts Texts = com.steg.efc.Texts.getInstance();
%>
<html>
<head>
    <title>REST API</title>

    <link href="/xplugin/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">

    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="_csrf_param" content="${_csrf.parameterName}"/>

    <style>
        html, body {
            height: 100%;
        }

        .flex-full {
            flex: 1;
        }

        .container {
            height: 100%;
            padding: 15px;
        }

        .nav-link.active {
            background: #edf1ff;
            color: #2051ff;
            font-weight: bold;
        }

        .restapi-information {
            width: 100%;
            border: 1px solid #cccccc;
        }

        .restapi-information th {
            background: #a9a9a9;
            border-right: 1px solid #cccccc;
            border-bottom: 1px solid #cccccc;
        }

        .restapi-information tr:last-child th {
            border-bottom: none;
        }

        .restapi-information td {
            background: #EFEFEF;
            border-bottom: 1px solid #cccccc;
        }

        .restapi-information tr:last-child td {
            border-bottom: none;
        }

    </style>

    <script type="text/javascript" src="/xplugin/jquery/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="/xplugin/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/xplugin/bootstrap/js/bootstrap.bundle.min.js"></script>

    <script type="text/javascript" src="/script/egeneClient.js"></script>

</head>
<body>
<header style="height: 30px; border-bottom: 1px solid #c7c7c7; text-align: center;"><%=Texts.getText(
        "EGENE 표준 인터페이스(REST API)", session)%>
</header>
<div style="padding-top: 30px; margin-top: -30px; height: 100%;">
    <div style="float: left; width: 200px; height: 100%;border-right: 1px solid #c7c7c7;">
        <div style="height:100%;">
            <ul classs="nav flex-column" style="width: 100%; list-style: none; padding: 0;">
                <li class="nav-item menu"><a class="nav-link link" data-id="SRM" data-method="POST"
                                             data-uri="/entity/SRM"><%=Texts.getText("SRM서비스요청 등록", session)%>
                </a></li>
                <li class="nav-item menu"><a class="nav-link link" data-id="SRM" data-method="GET"
                                             data-uri="/entity/SRM/:key"><%=Texts.getText("SRM서비스요청 조회", session)%>
                </a></li>
                <li class="nav-item menu"><a class="nav-link link" data-id="SRM" data-method="PUT"
                                             data-uri="/entity/SRM/:key"><%=Texts.getText("SRM서비스요청 수정", session)%>
                </a></li>
                <li class="nav-item menu"><a class="nav-link link" data-id="SRM" data-method="DELETE"
                                             data-uri="/entity/SRM/:key"><%=Texts.getText("SRM서비스요청 삭제", session)%>
                </a></li>
                <li class="nav-item menu"><a class="nav-link link" data-id="CM" data-method="GET"
                                             data-uri="/entity/CM/:key"><%=Texts.getText("Configuation Item 조회",
                        session)%>
                </a></li>
                <li class="nav-item menu"><a class="nav-link link" data-id="CM" data-method="POST"
                                             data-uri="/entity/CM"><%=Texts.getText("Configuation Item 생성", session)%>
                </a></li>
                <li class="nav-item menu"><a class="nav-link link" data-id="CM" data-method="PUT"
                                             data-uri="/entity/CM/:key"><%=Texts.getText("Configuation Item 수정",
                        session)%>
                </a></li>
                <li class="nav-item menu"><a class="nav-link link" data-id="LIST"
                                             data-uri="/list/:id/data"><%=Texts.getText("리스트", session)%>
                </a></li>
                <li class="nav-item menu"><a class="nav-link link" data-id="SQL"
                                             data-uri="/sql/:id/data"><%=Texts.getText("SQL", session)%>
                </a></li>
                <li class="nav-item menu"><a class="nav-link link" data-id="RELATION"
                                             data-uri="/relation/:id/data/:rel_key"><%=Texts.getText("릴레이션", session)%>
                </a></li>
                <li class="nav-item menu"><a class="nav-link link" data-id="multi" data-method="POST"
                                             data-uri="/entities/SRM"><%=Texts.getText("Multi 등록(SRM)", session)%>
                </a></li>
                <li class="nav-item menu"><a class="nav-link link" data-id="multi" data-method="PUT"
                                             data-uri="/entities/SRM"><%=Texts.getText("Multi 수정(SRM)", session)%>
                </a></li>
                <li class="nav-item menu"><a class="nav-link link" data-id="multi" data-method="DELETE"
                                             data-uri="/entities/SRM"><%=Texts.getText("Multi 삭제(SRM)", session)%>
                </a></li>
            </ul>
        </div>
    </div>
    <div style="padding-left: 200px; height: 100%">
        <div class="container" style="height: 100%; display: flex; flex-direction: column;">
            <div class="form-group row">
                <div class="label col-md-2">Grant Type</div>
                <div class="col-md-10" style="position: relative;">
                    <div class="form-check form-check-inline">
                        <input id="grantType01" name="grantType" type="radio" value="client_credentials"
                               class="form-check-input" checked>
                        <label for="grantType01" class="form-check-label">Client Credentials</label>
                    </div>
                </div>
            </div>

            <div class="form-group row">
                <div class="label col-md-2">Client ID</div>
                <div class="col-md-4" style="position: relative;">
                    <input name="clientId" value="" autocomplete="off">
                </div>
                <div class="label col-md-2">Client Secret</div>
                <div class="col-md-4" style="position: relative;">
                    <input name="clientSecret" value="" autocomplete="off">
                </div>
            </div>

            <div class="form-group row">
                <div class="label col-md-2">scopes</div>
                <div class="col-md-4" style="position: relative;">
                    <input name="scopes" value="" autocomplete="off">
                </div>
            </div>

            <div class="form-group row">
                <div class="label col-md-2">Token</div>
                <div class="col-md-10" style="position: relative;">
                    <textarea name="accessToken"
                              style="width: 100%;" disabled>
                    </textarea>
                </div>
            </div>

            <div class="form-group row">
                <div class="col">
                    <button class="btn-auth"><%=Texts.getText("인증확인", session)%>
                    </button>
                    <span class="auth-msg"></span>
                </div>
            </div>

            <div class="form-group row">
                <div class="label col-md-2">Method</div>
                <div class="col-md-4" style="position: relative;">
                    <div class="form-check form-check-inline">
                        <input id="method01" name="method" type="radio" value="GET" class="form-check-input">
                        <label for="method01" class="form-check-label">GET</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input id="method02" name="method" type="radio" value="POST" class="form-check-input">
                        <label for="method02" class="form-check-label">POST</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input id="method03" name="method" type="radio" value="PUT" class="form-check-input">
                        <label for="method03" class="form-check-label">PUT</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input id="method04" name="method" type="radio" value="DELETE" class="form-check-input">
                        <label for="method04" class="form-check-label">DELETE</label>
                    </div>
                </div>
                <div class="label col-md-2">Entity</div>
                <div class="col-md-4" style="position: relative;">
                    <select name="entity">
                        <option value="">:::<%=Texts.getText("선택", session)%>:::</option>
                        <option value="SRM">SRM</option>
                        <option value="ICM">ICM</option>
                        <option value="CHM">CHM</option>
                        <option value="CM">CM</option>
                    </select>
                </div>
            </div>

            <div class="form-group row">
                <div class="label col-md-2">URI</div>
                <div class="col-md-10" style="position: relative; padding-right: 100px;">
                    <input name="restUri" value="" autocomplete="off"
                           style="width: 100%; padding-right: 100px;">
                    <button class="callApi" style="position: absolute; right: 30px;">callApi</button>
                </div>
            </div>

            <div class="form-group row flex-full">
                <div class="col flex-full" style="display: flex;flex-direction: column;">
                    <div class="label">Request Body</div>
                    <textarea id="requestBody" class="flex-full" style="width: 100%; resize: none;"></textarea>
                </div>
                <div class="col flex-full" style="display: flex;flex-direction: column;">
                    <div class="label">Response</div>
                    <textarea id="result" class="flex-full" style="width: 100%; resize: none;" disabled></textarea>
                </div>
                <div class="col flex-full" style="display: flex;flex-direction: column;">
                    <div class="label">* status</div>
                    <table class="restapi-information">
                        <tr>
                            <th>000</th>
                            <td><%=Texts.getText("정상처리 상태코드", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>001</th>
                            <td><%=Texts.getText("비정상처리 상태코드", session)%>
                            </td>
                        </tr>

                    </table>
                    <div class="label">* error_code</div>
                    <table class="restapi-information">
                        <tr>
                            <th>LIT000</th>
                            <td><%=Texts.getText("정상처리", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT001</th>
                            <td><%=Texts.getText("필수값 없음", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT002</th>
                            <td><%=Texts.getText("업데이트 정보 없음", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT003</th>
                            <td><%=Texts.getText("엔터티가 없을 경우", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT100</th>
                            <td><%=Texts.getText("파일사이즈의 제한이 있을 경우", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT101</th>
                            <td><%=Texts.getText("업로드가 제한된 확장자일 경우", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT102</th>
                            <td><%=Texts.getText("대상 확장자만 등록해야하는 경우", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT103</th>
                            <td><%=Texts.getText("파일업로드중 오류가 경우", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT004</th>
                            <td><%=Texts.getText("시스템 변수의 값이 없을 경우 (ex. act)", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT005</th>
                            <td><%=Texts.getText("입력값이 잘못된 경우", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT006</th>
                            <td><%=Texts.getText("User 없는 경우", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT007</th>
                            <td><%=Texts.getText("Password 다른 경우", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT008</th>
                            <td><%=Texts.getText("로그인 권한 없는 사용자", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT009</th>
                            <td><%=Texts.getText("로그인 권한 없는 사용자", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT010</th>
                            <td><%=Texts.getText("로그인 횟수 초과", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT011</th>
                            <td><%=Texts.getText("계정 잠김", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT012</th>
                            <td><%=Texts.getText("다중 로그인 오류", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT013</th>
                            <td><%=Texts.getText("IP가 다른 사용자 오류", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT014</th>
                            <td><%=Texts.getText("Entity ID 확인 필요", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT015</th>
                            <td><%=Texts.getText("Entity Row ID 확인 필요", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT016</th>
                            <td><%=Texts.getText("키 중복 오류", session)%>
                            </td>
                        </tr>
                        <tr>
                            <th>LIT999</th>
                            <td><%=Texts.getText("Exception, 알수없는 오류", session)%>
                            </td>
                        </tr>


                    </table>

                </div>

            </div>
        </div>
    </div>
</div>
<script>
    var access_token = '';
    var restApi = '/egene/rest/api/1.0';
    // API 리소스 선택 처리
    $('.nav-link').click(function () {
        var resourceUri = $(this).data('uri'),
            method = $(this).data('method'),
            entId = $(this).data('id');

        changeRequestAPI(entId, method, resourceUri, restApi);
    });

    function changeRequestAPI(entId, method, resourceUri, restApi) {
        if (resourceUri) {
            restApi += resourceUri;
        }

        if (!method) {
            method = 'GET';
        }

        if (entId) {
            $('select[name=entity]').val(entId);
        }

        // 요청본문 초기화
        $('#requestBody').val('');

        $('input[name=restUri]').val(restApi);

        $('input[name=method][value=' + method + ']').prop('checked', true);

        $('.nav-link').removeClass('active');
        $(this).addClass('active');


        if (entId != 'multi') {
            if (method != 'GET') {
                setRequestBody(entId, method);
            }
        } else {
            if (method == 'POST') {
                $('#requestBody').val(JSON.stringify(createObject, null, 2));
            } else if (method == 'PUT') {
                $('#requestBody').val(JSON.stringify(updateObject, null, 2));
            } else if (method == 'DELETE') {
                $('#requestBody').val(JSON.stringify(deleteObject, null, 2));
            }

            $('input[name=method][value=POST]').prop('checked', true);
        }
    }

    // Method 선택 처리
    $('input[name=method]').click(function () {

        var entId = $('select[name=entity]').val();
        var method = $('input[name=method]:checked').val();

        var uri = '/entity/' + entId;

        if (method != 'POST') {
            uri += '/:key';
        }

        changeRequestAPI(entId, method, uri, restApi);
    });

    // create
    $('.callApi').on('click', function () {
        var restUrl = $('input[name=restUri]').val();
        var restParam = $('#requestBody').val();
        var method = $('input[name=method]:checked').val();

        if (method == 'GET') {
            restParam = '';
        }

        if (restUrl) {
            $.ajax({
                url: restUrl,
                type: method,
                data: restParam,
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                headers: {
                    'Authorization': 'Bearer ' + access_token
                },
                success: function (result) {
                    $('#result').val(JSON.stringify(result, null, 2));
                },
                error: function (result) {
                    result.responseJSON
                    $('#result').val('HTTP Status ::: ' + result.status + '\nresult.responseJSON ::: ' + JSON.stringify(result.responseJSON, null, 2));
                    console.log(result);
                }
            });
        }
    });


    var egeneClient;

    $('.btn-auth').click(function () {

        var grantType = $('input[name=grantType]:checked').val();

        var clientId = $('input[name=clientId]').val();

        var clientSecret = $('input[name=clientSecret]').val();

        var scopes = $('input[name=scopes]').val();


        if (grantType == 'refresh_token') {

            if (egeneClient && egeneClient.refreshToken) {
                var result = egeneClient.requestRefreshToken();
                access_token = '';
                $('textarea[name=accessToken]').val('');
                $('.auth-msg').text('');
                if (result) {
                    $('textarea[name=accessToken]').val(egeneClient.accessToken);
                    access_token = egeneClient.accessToken;
                } else {
                    $('.auth-msg').text(egeneClient.message);
                }

            } else {
                $('.auth-msg').text('인증 정보 또는 Refresh Token이 없습니다.');
            }

        } else {
            //
            $('.auth-msg').text('');
            // grant_type
            egeneClient = new EgeneClient(clientId, clientSecret, scopes, grantType);
            var result = egeneClient.requestAuthentication();
            access_token = '';
            $('textarea[name=accessToken]').val('');
            $('.auth-msg').text('');
            if (result) {
                $('textarea[name=accessToken]').val(egeneClient.accessToken);
                access_token = egeneClient.accessToken;
            } else {
                $('.auth-msg').text(egeneClient.message);
            }

            // $.ajax({
            //     type: 'post',
            //     url: '/logout',
            //     beforeSend: function(xhr) {
            //         // 데이터를 전송하기 전에 헤더에 csrf값을 설정한다
            //         xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
            //     },
            //     success: function() {
            //         //
            //         $('.auth-msg').text('');
            //         // grant_type
            //         egeneClient = new EgeneClient(clientId, clientSecret, scopes, grantType);
            //         var result = egeneClient.requestAuthentication();
            //         access_token = '';
            //         $('textarea[name=accessToken]').val('');
            //         $('.auth-msg').text('');
            //         if (result) {
            //             $('textarea[name=accessToken]').val(egeneClient.accessToken);
            //             access_token = egeneClient.accessToken;
            //         } else {
            //             $('.auth-msg').text(egeneClient.message);
            //         }
            //     }
            // });
        }
    });


    $('select[name=entity]').change(function () {

        var entId = $(this).val();
        var method = $('input[name=method]:checked').val();

        if (!method) {
            method = 'GET';
            $('input[name=method][value=GET]').prop('checked', true);
        }

        var uri = '/entity/' + entId;

        if (method != 'POST') {
            uri += '/:key';
        }

        changeRequestAPI(entId, method, uri, restApi);

    });

    function setRequestBody(entId, method) {
        if (entId && method) {
            $('#requestBody').val(JSON.stringify(requestBodyMap[entId][method], null, 2));
        }
    }

    var requestBodyMap = {
        SRM: {
            GET: {},
            POST: {
                curEmp: "admin",
                ctrlId: "CTL02538",
                curTaskId: "",
                nextTaskId: "",
                act: 1,
                data: {
                    srm_id: "SRMRESTTEST001",
                    srm_cat_cd: "SRMCAT01010",
                    srm_req_title: "restFulApiTest",
                    srm_req_content: "This is restFulApi Test~~",
                    relations: [
                        {
                            rltId: "RLT_TMPT_101",
                            type: "sync",
                            rows: [
                                {
                                    key: "",
                                    tmp_text_05: "test1",
                                    tmp_text_06: "test2",
                                    tmp_text_07: "test3",
                                    tmp_text_08: "test4",
                                    tmp_text_09: "test5",
                                    tmp_text_10: "test6",
                                    tmp_text_11: "test7"
                                }
                            ]
                        }
                    ]
                }
            },
            PUT: {
                ctrlId: '',
                curEmp: 'admin',
                curTaskId: "TAS01635",
                nextTaskId: "TAS01635",
                act: 2,
                data: {
                    srm_id: "SRMRESTTEST001",
                    srm_req_emp_id: "admin",
                    srm_dead_dttm: "20201015090000",
                    srm_med_cd: "SRMMED010",
                    srm_sys_id: "CM1902-05401",
                    srm_req_title: "restFulApiTest Modify",
                    srm_req_content: "This is restFulApi Modify Test~~",
                    relations: [
                        {
                            rltId: "RLT_TMPT_101",
                            type: "sync",
                            rows: [
                                {
                                    key: "TMPRESTTEST001",
                                    tmp_text_05: "test1 Modify",
                                    tmp_text_06: "test2",
                                    tmp_text_07: "test3",
                                    tmp_text_08: "test4",
                                    tmp_text_09: "test5",
                                    tmp_text_10: "test6",
                                    tmp_text_11: "test7"
                                }
                            ]
                        }
                    ]
                }
            },
            DELETE: {}
        },
        ICM: {
            POST: {
                curEmp: "admin",
                ctrlId: "CTL02431",
                curTaskId: "",
                nextTaskId: "",
                act: 1,
                data: {
                    icm_cat_cd: "SRMCAT01010",
                    icm_req_title: "서버다운 장애",
                    icm_req_content: "서버다운 장애 내용",
                    icm_sys_id: ''
                }
            },
            PUT: {
                curEmp: "admin",
                ctrlId: "",
                curTaskId: "",
                nextTaskId: "",
                act: 2,
                data: {
                    icm_req_title: "서버다운 장애",
                    icm_req_content: "서버다운 장애 내용"
                }
            }
        },
        CM: {
            POST: {
                curEmp: "admin",
                ctrlId: "CTL02290",
                curTaskId: "",
                nextTaskId: "",
                act: 1,
                data: {
                    cm_cat_cd: "APP",
                    cm_name: "표준인터페이스 등록",
                    cm_sta_cd: "CMSTA010",
                    cm_used: 1,
                    relations: [
                        {
                            rltId: "RLTCM_REL",
                            type: "sync",
                            rows: [
                                {
                                    key: "APPCM00112312312",
                                    cmr_cat_cd: "CMRCAT010"
                                }
                            ]
                        }
                    ]
                }
            },
            PUT: {
                curEmp: "admin",
                ctrlId: "",
                curTaskId: "",
                nextTaskId: "",
                act: 2,
                data: {
                    cm_cat_cd: "APP",
                    cm_name: "표준인터페이스 업데이트",
                    cm_sta_cd: "CMSTA010",
                    cm_used: 1,
                    relations: [
                        {
                            rltId: "RLTCM_REL",
                            type: "sync",
                            rows: [
                                {
                                    key: "APPCM00112312312",
                                    cmr_cat_cd: "CMRCAT010"
                                }
                            ]
                        }
                    ]
                }
            }
        }
    }


    var createObject = {
        rows: [
            {
                curEmp: "admin",
                ctrlId: "CTL02538",
                curTaskId: "",
                nextTaskId: "",
                act: 1,
                data: {
                    srm_id: "SRMRESTTEST001",
                    srm_cat_cd: "SRMCAT01010",
                    srm_req_title: "restFulApiTest #001",
                    srm_req_content: "This is restFulApi Test~~ #001",
                    relations: [
                        {
                            rltId: "RLT_TMPT_101",
                            type: "sync",
                            rows: [
                                {
                                    key: "",
                                    tmp_text_05: "test1",
                                    tmp_text_06: "test2",
                                    tmp_text_07: "test3",
                                    tmp_text_08: "test4",
                                    tmp_text_09: "test5",
                                    tmp_text_10: "test6",
                                    tmp_text_11: "test7"
                                }
                            ]
                        }
                    ]
                }
            },
            {
                curEmp: "admin",
                ctrlId: "CTL02538",
                curTaskId: "",
                nextTaskId: "",
                act: 1,
                data: {
                    srm_id: "SRMRESTTEST002",
                    srm_cat_cd: "SRMCAT02010",
                    srm_req_title: "restFulApiTest #002",
                    srm_req_content: "This is restFulApi Test~~ #002"
                }
            }
        ]
    };

    var updateObject = {
        rows: [
            {
                ctrlId: "",
                curEmp: "admin",
                curTaskId: "TAS01635",
                nextTaskId: "TAS01635",
                act: 2,
                data: {
                    srm_id: "SRMRESTTEST001",
                    srm_req_emp_id: "admin",
                    srm_dead_dttm: "20201015090000",
                    srm_med_cd: "SRMMED010",
                    srm_sys_id: "CM1902-05401",
                    srm_req_title: "restFulApiTest #001 Modify",
                    srm_req_content: "This is restFulApi Modify Test~~",
                    relations: []
                }
            },
            {
                ctrlId: "",
                curEmp: "admin",
                curTaskId: "TAS01635",
                nextTaskId: "TAS01635",
                act: 2,
                data: {
                    srm_id: "SRMRESTTEST002",
                    srm_req_emp_id: "admin",
                    srm_dead_dttm: "20201015090000",
                    srm_med_cd: "SRMMED010",
                    srm_sys_id: "CM1902-05401",
                    srm_req_title: "restFulApiTest #002 Modify",
                    srm_req_content: "This is restFulApi Modify Test~~"
                }
            }
        ]
    };

    var deleteObject = {
        rows: [
            {
                ctrlId: "",
                curEmp: "admin",
                curTaskId: "",
                nextTaskId: "",
                act: 3,
                data: {
                    srm_id: "SRMRESTTEST001",
                    relations: [
                        {
                            rltId: "RLT_TMPT_101",
                            type: "sync",
                            rows: []
                        }
                    ]
                }
            },
            {
                ctrlId: "",
                curEmp: "admin",
                curTaskId: "",
                nextTaskId: "",
                act: 3,
                data: {
                    srm_id: "SRMRESTTEST002",
                    relations: [
                        {
                            rltId: "RLT_TMPT_101",
                            type: "sync",
                            rows: []
                        }
                    ]
                }
            }
        ]
    };


</script>
</body>
</html>

<%!
    private void jspSample(HttpServletRequest request) {
        String access_token = "";

        CloseableHttpClient httpClient = null;
        CloseableHttpResponse httpResponse = null;
        BufferedReader reader = null;
        InputStreamReader isr = null;

        try {

            String tokenURI = request.getScheme() + "://" + request.getServerName();
            if (request.getServerPort() != 80) {
                tokenURI += ":" + request.getServerPort();
            }
            tokenURI += "/oauth/token";

            httpClient = HttpClientBuilder.create().build();
            HttpPost httpPost = new HttpPost(tokenURI);
        /*
        httpPost.setHeader("Accept", "application/json");
        httpPost.setHeader("Content-Type", "application/json");
*/
            List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(1);
            nameValuePairs.add(new BasicNameValuePair("grant_type", "client_credentials"));
            nameValuePairs.add(new BasicNameValuePair("client_id", "egene"));
            nameValuePairs.add(new BasicNameValuePair("client_secret", "asdf1234!"));

            httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));

            httpResponse = httpClient.execute(httpPost);

            isr = new InputStreamReader(httpResponse.getEntity().getContent());
            reader = new BufferedReader(isr);

            String line = "";
            StringBuffer sb = new StringBuffer();
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            System.out.println("================");
            System.out.println(sb.toString());
            System.out.println("================");

            JSONObject resultObj = (JSONObject)JSONValue.parse(sb.toString());

            //access_token = resultObj.getString("access_token");

        } catch (BizException e) {
            Log.biz.err("Close Err" + e);
        } catch (Exception ex) {
            Log.biz.err("Close Err" + ex);
        } finally {
            if (isr != null) {
                try {
                    isr.close();
                } catch (Exception ex) {
                    Log.biz.err("Close Err" + ex);
                }
            }
            if (reader != null) {
                try {
                    reader.close();
                } catch (Exception ex) {
                    Log.biz.err("Close Err" + ex);
                }
            }
            if (reader != null) {
                try {
                    reader.close();
                } catch (Exception ex) {
                    Log.biz.err("Close Err" + ex);
                }
            }
            if (httpClient != null) {
                try {
                    httpClient.close();
                } catch (Exception ex) {
                    Log.biz.err("Close Err" + ex);
                }
            }
        }
    }
%>