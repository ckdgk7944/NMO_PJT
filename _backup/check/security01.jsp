<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%

    Box box = HttpUtility.getBox(request);
    String p = box.get("param");
    String src = new String(p.getBytes("KSC5601"), "8859_1");
    Log.act.info("box : " + src);

    //Java AES방식의 암복호화 예제
    String txt = "1234";
    //String encStr = SimpleAES.encrypt(txt);
    String encStr = SecureUtil.getInstance().getSecure(SecureUtil.AES).encrypt(txt);
    String decStr = "";
    try {
        //    decStr = SimpleAES.decrypt(encStr);
        decStr = SecureUtil.getInstance().getSecure(SecureUtil.AES).decrypt(encStr);
    } catch (BizException e) {
        Log.biz.err(e);
    } catch (Exception e) {
        Log.biz.err(e);
    }

    out.println("encStr : " + encStr);
    out.println("<br>");
    out.println("decStr : " + decStr);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<!-- <meta http-equiv="X-UA-Compatible" content="IE=edge" /> -->
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
<link href="/css/default.css" rel="stylesheet" type="text/css">

<script type="text/javascript" src="/xefc/script/prototype.js"></script>
<script src="/xplugin/jquery/jquery-3.7.1.min.js"></script>
<script src="/xplugin/jquery/ui/1.13.2/jquery-ui.js"></script>

<!--javascript AES방식의 암복호화 예제 -->
<!--javascript AES방식의 암복호화 기본설정 시작 -->
<script src="/xefc/script/aes-dec.js"></script>
<script src="/xefc/script/aes-enc.js"></script>
<script src="/xefc/script/aes-test.js"></script>
<script>
    blockSizeInBits = 128;
    keySizeInBits = 128;

    var aesKey = "0987654321098765";    // 16 byte = 128 bit 키

    // 공백 문자 padding
    function padding16(sVal) {
        var nCount = 16 - (sVal.length % 16);
        for (i = 0; i < nCount; i++)
            sVal += ' ';
        return sVal;
    }

    // trim 함수
    function trim(str) {
        return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
    }

    // 암호화
    function doEnc(i) {
        var output = '';
        if ((i != null)) {
            var text = padding16(i);
            text = byteArrayToHex(rijndaelEncrypt(text, aesKey, "ECB"));
            output = text;//.replace(/^\s+|\s+$/g,"");
        }
        return output;
    }

    // 복호화
    function doDec(i) {
        var output = '';

        if ((i != null)) {
            var text = hex2s(i);
            output = trim(hex2s(byteArrayToHex(rijndaelDecrypt(text, aesKey, "ECB"))));
        }
        return output;
    }

    <!--javascript AES방식의 암복호화 기본설정 끝 -->
    <!--javascript AES방식의 암복호화 예제 -->
    test01 = function () {
        var txt = '1234';
        var encStr = doEnc(txt);
        var decStr = doDec(encStr);
        alert(encStr);
        alert(decStr);
    }
</script>
</link>
<body>
<div>
    <input type='button' name='btnA' value='btn' onClick='test01();'>
</div>
</body>
</html>
