<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="org.sdf.secure.AES" %>
<%--
  Created by IntelliJ IDEA.
  User: sinru
  Date: 2021-12-17
  Time: 오전 1:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%
    String txt = "012345678.";
    String secretKey = GlobalResource.getInstance().get("AES.secretKey");
    String sessionId = session.getId();

    AES aes128 = (AES)SecureUtil.getInstance().getSecure(SecureUtil.AES);
    ISecure aes256 = SecureUtil.getInstance().getSecure(SecureUtil.AES256);

    // AES128 암호화 with Hex
    System.out.println("########## AES128 ##########");
    String aesValue = aes128.encrypt(txt, secretKey);
    System.out.println("encrypt :: " + aesValue);
    System.out.println("decrypt :: " + aes128.decrypt(aesValue, secretKey));

    // AES128 암호화
    System.out.println("########## AES128 ##########");
    String encValue = aes128.encryptBasic(txt, secretKey);
    String decValue = aes128.decryptBasic(encValue, secretKey);
    System.out.println("encrypt :: " + encValue);
    System.out.println("decrypt :: " + decValue);

    // AES256 암호화
    System.out.println("########## AES256 ##########");
    encValue = aes256.encrypt(txt, sessionId);
    decValue= aes256.decrypt(encValue, sessionId);
    System.out.println("encrypt :: " + encValue);
    System.out.println("decrypt :: " + decValue);



    // 암호화 모듈 테스트 (EGENE 6.2)
    String encValue2 = "";
    String txtValue = "0987654321";

    //encValue2 =  SecureUtil.encryptBasic(txtValue, secretKey);


%>
<%@ include file="/xefc/jsp/common/html_begin.jspf" %>
    <title>CryptoJS</title>

    <%@ include file="/xefc/jsp/common/script.jspf" %>
    <%-- crypt-js --%>
    <script src="/xplugin/crypto-js/crypto-js.min.js"></script>
    <script src="/script/common.js"></script>
</head>
<body>

<button type="button" class="btn-reg">등록</button>
<script>

    $egene.setSessionId('<%=session.getId()%>');

    $('.btn-reg').click(function(){
        debugger;
        $service.ajax({
            url: '/api/egene/sql/exec/WSQL00649',
            contentType: 'application/json',
            type:'post',
            data:JSON.stringify({
                'test_aes128':'암호화 확인1',
                'test_aes256':'암호화 확인2'
            })
        }, function (result){
            console.log(result);
        })
    });



    var txt = '<%=txt%>';
    var passphrase = '<%=sessionId%>';
    var secretKey = '<%=secretKey%>';
    var base64 = btoa(passphrase);
    var encVal, decrypt, decryptedData, decryptTxt;

    console.log("::::CryptoJS 암호화 확인::::");
    encVal = CryptoJS.AES.encrypt(txt, CryptoJS.enc.Base64.parse(base64), {
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.Pkcs7
    });

    decryptedData = encVal.toString();

    console.log("문자열 값::" + txt);
    console.log("암호화 문자열::" + decryptedData);

    /*
    let ivvar   = CryptoJS.enc.Hex.parse('00000000000000000000000000000000');
    const encryptedStringHex = CryptoJS.AES.encrypt(txt, CryptoJS.enc.Base64.parse(base64), {
        iv: ivvar,
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.Pkcs7
    }).ciphertext.toString();

     */
    let encValue = _encryptAESHex(passphrase, txt);
    let decValue = _decryptAESHex(passphrase, encValue)

    console.log("원본 문자열::" + txt);
    console.log("암호화 문자열 HEX::" + encValue);
    console.log("복호화 문자열 HEX::" + decValue);




    console.log("::::CryptoJS 복호화 확인::::");
    decrypt = CryptoJS.AES.decrypt(decryptedData, CryptoJS.enc.Base64.parse(base64), {
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.Pkcs7
    });

    console.log("암호화 문자열::" + decryptedData);
    console.log("복호화 문자열::" + decrypt.toString(CryptoJS.enc.Utf8));


    encVal = CryptoJS.AES.encrypt(txt, CryptoJS.enc.Base64.parse(base64), {
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.Pkcs7
    });

    decryptedData = encVal.toString();

    console.log("::::함수 사용 확인::::");
    encValue  = '<%=aesValue%>';

    base64 = btoa(passphrase);
    decrypt = CryptoJS.AES.decrypt(encValue, CryptoJS.enc.Base64.parse(base64), {
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.Pkcs7
    });

    decryptTxt = decrypt.toString(CryptoJS.enc.Utf8)

    console.log("암호화 문자열::" + encValue);
    console.log("복호화 문자열::" + decryptTxt);

    //======================================================
    console.log("::::모듈 사용 확인(EGENE 6.2)::::");

    var encValue2 = '<%=encValue2%>';

    var decrypt2 = CryptoJS.AES.decrypt(encValue2, CryptoJS.enc.Base64.parse(btoa(secretKey)), {
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.Pkcs7
    });


    console.log("###############  암호화 API 확인  ##################");


</script>
</body>
</html>
<%!
    /*
    public SecretKeySpec generateKey(String key) throws Exception {
        SecretKeySpec keySpec;

        byte[] keyBytes = new byte[key.length()];
        byte[] b = key.getBytes("UTF-8");

        int len = b.length;
        if (len > keyBytes.length) {
            len = keyBytes.length;
        }

        System.arraycopy(b, 0, keyBytes, 0, len);
        keySpec = new SecretKeySpec(keyBytes, "AES");

        return keySpec;
    }

    public String encryptBasic(String text, String key) {
        try {
            SecretKeySpec ks = (SecretKeySpec) this.generateKey(key);
            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, ks);
            byte[] encryptedBytes = cipher.doFinal(text.getBytes());
            String base64 = new String(Base64.getEncoder().encode(encryptedBytes));
            return base64;
        } catch (Exception e) {
            Log.biz.err(e);
        }

        return text;
    }

    public String decryptBasic(String enStr, String key) throws Exception {
        SecretKeySpec ks = (SecretKeySpec) this.generateKey(key);

        Cipher c = Cipher.getInstance("AES/ECB/PKCS5Padding");
        c.init(Cipher.DECRYPT_MODE, ks);

        byte[] byteStr = Base64.getDecoder().decode(enStr.getBytes("UTF-8"));
        String decStr = new String(c.doFinal(byteStr), "UTF-8");

        return decStr;
    }

     */
%>