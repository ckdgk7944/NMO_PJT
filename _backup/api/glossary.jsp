<%--
  Created by IntelliJ IDEA.
  User: jhgo
  Date: 2017-05-23
  Time: 오후 1:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Glossary</title>
    <script src="/xplugin/jquery/jquery-3.7.1.min.js"></script>
</head>
<body>
<section>

    <article>
        명칭:<input type="text" name="gls_name" class="gls_name"> >>> 결과:
        <div class="gls-result" style="display: inline-block;"></div>
    </article>

    <article>
        명칭: 약어:
        <button onclick="">등록</button>
    </article>

    <article>
        <textarea class="gls-names" style="width:500px;height:300px;"></textarea>
        <button class="btn-start">시작</button>
    </article>

    <article>
        <table class="gls-table">

        </table>
    </article>

</section>

<script>
    $(document).ready(function () {
        $('.gls_name').keyup(function () {
            var s = $('.gls_name').val();
            var result = searchAddreviation(s);
            $('.gls-result').text(result);
        });

        $('.btn-start').click(function () {
            var name_arr = $('.gls-names').val().split('\n');
            for (var i = 0; i < name_arr.length; i++) {
                var result = searchAddreviation(name_arr[i]);
                //$('.gls-table').append('<tr><td>'+name_arr[i]+'</td><td>'+result+'</td></tr>')
            }

            for (var key in words) {
                $('.gls-table').append('<tr><td>' + key + '</td><td>' + words[key] + '</td></tr>')
            }
        });
    });

    var words = {};

    function searchAddreviation(input) {
        var s_a = input.split(' ');
        var i = 0;
        var result = '';

        if (s_a.length > 0) {
            getAddreviation(s_a[i]);
        }

        function getAddreviation(name) {
            $.ajax({
                type: 'POST',
                url: '../../xefc/jsp/ui/bizajax/getBizData.jsp',
                data: {sql_id: 'GLS.Select', gls_name: name},
                async: false,
                success: function (data) {
                    var j = JSON.parse(data);
                    if (j && j.gls_addreviation) {
                        result = result + j.gls_addreviation;
                    } else {
                        result = result + name;
                    }

                    if (!words[name]) {
                        if (j && j.gls_addreviation) {
                            words[name] = j.gls_addreviation;
                        } else {
                            words[name] = name;
                        }
                    }

                    i++;
                    if (i < s_a.length) {
                        result = result + '_';
                        getAddreviation(s_a[i]);
                    }
                }
            });
        }

        return result;
    }
</script>
</body>
</html>
