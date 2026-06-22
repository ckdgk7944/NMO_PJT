<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<!doctype html>
<html lang="ko">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1, user-scalable=no">
    <link rel="shortcut icon" href="/favicon.ico"><!-- Chrome, Safari, IE -->
    <link rel="icon" href="/favicon.png"><!-- Chrome, Safari, IE -->
    <link rel="apple-touch-icon-precomposed" href="/favicon.ico"><!-- iphone -->
    <meta name="author" content="STEG">
    <meta http-equiv="Publisher" content="STEG"/>
    <meta name="description" content="eGene Lightning">
    <meta name="Keywords" content="egene, itsm, steg, itom"/>
    <meta name="Robots" content="noindex, nofollow"/>
    <!-- 검색엔진 제외 https://webclub.tistory.com/354 -->
    <!-- Cache 사용 하지 않도록 -->
    <%--<meta http-equiv="Cache-Control" content="no-cache" />
  <meta http-equiv="Pragma" content="no-cache" />--%>

    <!-- Basic Page Needs
  ================================================== -->
    <title>Schema TEST</title>
    <link href="/xplugin/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="/xplugin/jquery/ui/1.13.2/jquery-ui.css" rel="stylesheet" type="text/css">
    <link href="/xplugin/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>

    <script type="text/javascript" src="/xplugin/jquery/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="/xplugin/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/xplugin/bootstrap/js/bootstrap.bundle.min.js"></script>


    <style>
        .result_table {
            width: 100%;
        }
    </style>
<body>


<div class="container-fluid">

    <div class="row" id="f_info">


        <div class="col-md-6">
            <h1>Source</h1>

            <div>
                <label>Driver</label><input id="src_driver" name="src_driver">
                <label>URL</label><input id="src_url" name="src_url">
                <label>ID</label><input id="src_id" name="src_id">
                <label>PW</label><input type="password" id="src_pw" name="src_pw" autocomplete="off">
            </div>

        </div>

        <div class="col-md-6">
            <h1>Target</h1>

            <div>
                <label>Driver</label><input id="tgt_driver" name="tgt_driver">
                <label>URL</label><input id="tgt_url" name="tgt_url">
                <label>ID</label><input id="tgt_id" name="tgt_id">
                <label>PW</label><input type="password" id="tgt_pw" name="tgt_pw" autocomplete="off">
            </div>

        </div>

        <div class="col-md-12">
            <button class="btn-success" id="btnSearch">조회</button>
        </div>

    </div>

    <div class="row">

        <div class="col-md-6">
            <table id="src_table" class="table">
                <thead>
                <tr>
                    <th>Table</th>
                    <th>Len</th>
                    <th>MD5</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>

        <div class="col-md-6">
            <table id="tgt_table" class="table">
                <thead>
                <tr>
                    <th>Table</th>
                    <th>Len</th>
                    <th>MD5</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>

    </div>

</div>

</body>
<script type="text/javascript">

    $(document).ready(function () {

        var $el = {
            f_info: $('#f_info'),
            src_table_body: $('#src_table tbody'),
            tgt_table_body: $('#tgt_table tbody'),
        };

        {
            var def_val = {
                src_driver: 'org.mariadb.jdbc.Driver',
                src_url: 'jdbc:mysql://211.251.238.188:3301/egene60',
                src_id: 'egene60',
                src_pw: 'egene60',

                tgt_driver: 'org.mariadb.jdbc.Driver',
                tgt_url: 'jdbc:mysql://211.251.238.188:20006/egene52',
                tgt_id: 'egene52',
                tgt_pw: 'egene52'
            }

            $.each(def_val, function (k, v) {
                $('input[name=' + k + ']', $el.f_info).val(v);
            })
        }

        var fn_drawTable = function (result) {

            var src = result['src'];
            var html = '';

            $.each(src, function (i, v) {
                html += '<tr><td>' + v['table'] + '</td><td>' + v['colsize'] + '</td><td>' + v['md5'] + '</td></tr>';
            });

            $el.src_table_body.empty().html(html);


            var tgt = result['tgt'];
            var tgt_html = '';

            $.each(tgt, function (i, v) {
                tgt_html += '<tr><td>' + v['table'] + '</td><td>' + v['colsize'] + '</td><td>' + v['md5'] + '</td></tr>';
            });

            $el.tgt_table_body.empty().html(tgt_html);

        }

        $('#btnSearch').click(function () {

            var data = {};

            var els = $('input', $el.f_info);
            $.each(els, function (i, e) {
                var $el = $(e);
                data[$el.attr('name')] = $el.val();
            });


            $.ajax({
                url: './ajax/apiSchemaTest.jsp',
                data: data,
                type: 'get',
                dataType: "json",
                success: function (result) {
                    fn_drawTable(result);
                }
            })
        });


    });
</script>


</html>