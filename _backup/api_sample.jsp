<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<html>
<head>
    <title>Title</title>
    <script type="text/javascript" src="/xplugin/jquery/jquery-3.7.1.min.js"></script>
</head>
<body>

<form name="_form" method="post">

    <div>
        <div style="float: left; width: 50%;">
            <div>Request Body:</div>
            <textarea name="requestBody" style="width: 100%; height: 500px;">
            </textarea>
        </div>

        <div style="float: left; width: 50%;">
            <div>Result:</div>
            <textarea name="response" style="width: 100%; height: 500px;"></textarea>
        </div>

    </div>

</form>

<script>
    $(document).ready(function () {

        var sendData = {
            ent_id: 'CM',
            rows: [
                {
                    key: 'CM000001',
                    cm_name: '이름'
                }
            ]
        }

        $('textarea[name=requestBody]').val(JSON.stringify(sendData));

        $.ajax({
            url: "/sample/api_entity.jsp",
            type: 'post',
            data: JSON.stringify(sendData),
            success: function (result) {
                console.log(result);

                $('textarea[name=response]').val(result);
            }
        })
    })

</script>
</body>
</html>


