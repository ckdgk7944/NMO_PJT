<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ include file="/xefc/jsp/include/session.jspf" %>
<%
    Box box = HttpUtility.getBox(request);
    String key = box.get("key");
    //key = "152324010400001";

    com.steg.efc.Texts texts = com.steg.efc.Texts.getInstance();
    ICE ice = ICE.getInstance();
    Sqls sqls = ice.sqls();

%>
<%@ include file="/xefc/jsp/common/html_begin.jspf" %>
<!-- CSS Link -->
<!-- Main Style CSS -->
<link href="/css/contents.css" rel="stylesheet" type="text/css">
<!-- Form Style CSS -->
<link href="/css/ui_form.css" rel="stylesheet" type="text/css">
<!-- List Style CSS -->
<link href="/css/ui_grid.css" rel="stylesheet" type="text/css">
<!-- Tab Style CSS -->
<link href="/css/ui_stab.css" rel="stylesheet" type="text/css">
<link href="/xplugin/jquery/ui/1.13.2/jquery-ui.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/css/stylesheet-pure-css.css">
<link rel="stylesheet" href="/css/button.css"/>
<%@ include file="/xefc/jsp/common/script.jspf" %>
<body>
<!-- Top 영역 START -->
<div id="form_header">
    <table id="form_title">
        <tr>
            <td id="form_title_text"><%=texts.getText("설문평가결과 세부조회", session) %>
            </td>
            <td style="width:110px;padding-right:15px">
                <table width="100%">
                    <tr>
                        <td align=right>
                            <table id='pop-title2' class='button-pop-title-action' onclick="window.print();" title='닫기'>
                                <tbody>
                                <tr>
                                    <td class='btnpr'></td>
                                    <td class='btnl'></td>
                                    <td class='btnc'>인쇄</td>
                                    <td class='btnr'></td>
                                </tr>
                                </tbody>
                            </table>
                        </td>

                        <td align=right>
                            <table id='pop-title2' class='button-pop-title-action' onclick="self.close();" title='닫기'>
                                <tbody>
                                <tr>
                                    <td class='btnpr'></td>
                                    <td class='btnl'></td>
                                    <td class='btnc'>닫기</td>
                                    <td class='btnr'></td>
                                </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>
<!-- Top 영역 END -->
<div class="grid_1" style="padding:15px;">
    <div class=grid>
        <table id=table_grid cellspacing=0 cellpadding=0 class=grid style='table-layout: fixed; width: 100%'>
            <tr class=header>
                <th align=center rowspan=1 colspan=2>직원</th>
                <th align=center rowspan=1 colspan=3>부서정보</th>
                <th width=80 align=center rowspan=2 colspan=1>1</th>
                <th width=80 align=center rowspan=2 colspan=1>2</th>
                <th width=80 align=center rowspan=2 colspan=1>3</th>
            </tr>
            <th width=50 align=center>1직원ID</th>
            <th width=50 align=center>직원명</th>
            <th width=80 align=center>회사명</th>
            <th width=110 align=center>부서</th>
            <th width=100 align=center>직위</th>
            </tr>
        </table>
    </div>
</div>
</body>
</html>