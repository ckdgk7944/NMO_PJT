<%@ page contentType="text/html; charset=utf-8" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <script src="/xplugin/jquery/jquery-3.7.1.min.js"></script>
    <script src="/xplugin/jquery/ui/1.13.2/jquery-ui.js"></script>
    <script>
        function openCalendar(dt, handler, nofocus) {

            var id;
            var dt_val;
            if (dt) {
                id = dt.attr("id");
                dt_val = dt.val();
            }

            $("#" + id).datepicker({
                changeMonth: true,
                changeYear: true,
                yearRange: "c-60:c+20",
                onSelect: function (v, o) {

                    if (handler) {
                        handler(v);
                    }
                },
                beforeShow: function () {

                    //Active-X의 아래로 레이어가 숨는 문제 해결을 위한 방안.
                    //일반적인 경우 jQuery CSS 함수로 "auto"설정을 하면 자동으로 위치를 잡아줌
                    //예외1) jQuery Tab안에 속한 Object는 jQuery CSS 함수로 "auto"설정을 해야만 위치를 잡아줌
                    //예외2) Other Group이 들어가 있는 Form의 경우에는 "offset - top"으로 값을 설정해야 위치를 잡아줌
                    //예외3) 특이 Case가 계속있기 때문에 발생 시 마다 여기에 추가.

                    //Tab안의 Object구분
                    var tab_cls = $(".set_tab #" + id);

                    // #div의 현재 위치
                    var obj = $("#" + id).offset();


                    var top_pos = obj.top + "px";
                    var left_pos = $("#" + id).css("left");
                    if (tab_cls.length > 0) {
                        top_pos = $("#" + id).css("top");
                    }

                    setTimeout(function () {
                        $("#" + id).before("<iframe id='ui-datepicker-div-bg-iframe' frameborder='0' scrolling='no' style='filter: alpha(opacity=0); position: absolute; left: " + left_pos + "; top: " + top_pos + "; width: 215px; height: 195px;'></iframe>");
                    }, 50);
                },
                onClose: function () {
                    $("#ui-datepicker-div-bg-iframe").remove();
                }
            });

            $("#" + id).datepicker("option", "dateFormat", "yymmdd");
            if (dt_val) {
                $("#" + id).val(dt_val);
            }

            if (!nofocus) {
                $("#" + id).focus();
            }
        }
    </script>
    <!-- Popup Style CSS -->
    <link href="/xplugin/jquery/ui/1.13.2/jquery-ui.css" rel="stylesheet" type="text/css">
    </link>
    <style>
        .ui-widget {
            font-size: 12px;
            font-family: "맑은 고딕", Malgun Gothic, Dotum, "돋움", Arial, Tahoma;
        }

        .ui-widget-content {
            border: 1px solid #CFDBE2;
            margin-bottom: 10px;
        }

        .ui-tabs .ui-tabs-panel {
            padding: 0;
        }

        .ui-corner-all {
            border-radius: 0;
        }

        input, select {
            color: #606060;
            background-color: #ffffff;
            border: 1px solid #CFDBE2;;
            height: 25px;
            box-sizing: border-box;
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;

            border-radius: 0.3em;
        }
    </style>
</head>

<body>
<table width=200px>
    <tr>
        <td width="170px">
            <input type=text id='dt' style="width: 100%;" maxlength=8 value="">
        </td>
        <td style="width: 30px; text-align: center;">
            <img class="fa-icon" src="/images/icon/btn_calendar.png" tabindex=-1 onClick="openCalendar($('#dt'))">
        </td>
    </tr>
</table>
</body>
</html>