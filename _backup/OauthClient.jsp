<%--
  Created by IntelliJ IDEA.
  User: sinru
  Date: 2021-07-24
  Time: 오후 9:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link href="/xplugin/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">

    <script type="text/javascript" src="/xplugin/jquery/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="/xplugin/jquery/ui/1.13.2/jquery-ui.min.js"></script>
</head>
<body>
<script>
    // token login
    // var token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJyZWFkIiwid3JpdGUiXSwiZXhwIjoxNjM0MTA1ODU3LCJhdXRob3JpdGllcyI6WyJST0xFX1VTRVIiXSwianRpIjoiZjc5ZDE4MzItNGMwMC00MzViLWFmYzAtNzBlMWIxNjE2Y2FjIiwiY2xpZW50X2lkIjoiaXRzbSJ9.kXomnYz7ld-xPUQeBekVFskwh0kJw8GpLRVH4Lipmgs';
    //
    // $.ajax({
    //     url: '/egene/rest/api/entity/SRM/SR2107-00136?access_token=' + token,
    //     success: function (result) {
    //         console.log(result);
    //     }
    // });

    // password,client_credentials
    $.ajax({
        url: '/oauth/token',
        type: 'POST',
        data: {
            grant_type: 'password',
            client_id: 'pureClient1',
            client_secret: 'asdf1234!',
            username: 'admin',
            password: 'asdf1234!'
        },
        success: function (result) {
            console.log(result);

            $.ajax({
                url: '/egene/rest/api/entity/SRM/SR2107-00136?access_token=' + result.access_token,
                success: function (result) {
                    console.log(result);
                }
            });


        }
    });

    /*
                grant_type:'client_credentials',
            client_id: 'pureClient2',
            client_secret: 'asdf1234!'
     */
</script>
</body>
</html>
