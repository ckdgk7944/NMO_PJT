<%@ page contentType="text/html; charset=utf-8"  %>
<%@ include file="include/Field.Common.jsp" %>
<%@ include file="include/Field.Begin.jsp" %>
<%@ include file="/xefc/jsp/common/ui.jsp" %>

<%
    //if(_readonly) return;
    String label = "";
    String type = "";
    String align = "left";

    JSONObject json = (JSONObject) JSONValue.parse(fld_val_config);
    
    if (json != null) {
    
	    label = json.getString("label");
	    label = texts.getText(label, session);
	    type = json.getString("type");
	    align = json.getString("align");
	
	    if(type.equals("")){
	    	type = "small";
	    }
    
    }

    String fn = "handler" + fid +"()";
%>

<div>
    <table width="100%">
        <tr>
            <td width="100%" align=<%= align %>>
            <%= createButton(label, fn, type, session) %>
            </td>
        </tr>
    </table>
</div>

<%-- <%= createButton(label, fn, type, session) %> --%>

<script language=javascript>
 handler<%= fid %> = function(){
    <%= fld_act_script %>


     // Search UIITem 구현 시작
     // Search Custom Dialog
     var dialog_form = $jq('.custom-dialog');

     if (dialog_form.length == 0) {
         // Custom Dialog 생성
         dialog_form = $jq('<div class="custom-dialog"></div>');
         // append Dialog to body
         $jq('body').append(dialog_form);
     }

     // 선택된 CM ID 설정
     // cmids는 커스텀 속성
     dialog_form.attr('cmids', 'CM1902-01000,CM1902-01100');

     //var url = '/sample/nice/Catalog.Selector.jsp';
     var url = '/sample/nice/CM.Selector.jsp';

     // CM.Selector.jsp 로딩
     dialog_form.load(url, function(){
         // 로딩이 완료되면 dialog 팝업모듈 생성
         var dialog = dialog_form.dialog({
             title: "구성항목 선택",
             autoOpen: false,
             height: 500,
             width: 700,
             modal: true,
             buttons: {
                 "1": {
                     id: 'save', text: '선택', tabIndex: -1, click: function () {
                         // 선택된 CM 처리 시작
                         callActScript();
                     }
                 },
                 "2": {
                     id: 'close', text: '닫기', tabIndex: -1, click: function () {
                         // 팝업 닫기
                         closeModalDlg();
                     }
                 }
             },
             close: function () {
                 dialog.dialog("close");
                 dialog.remove();
             }
         });

         // 팝업 화면 표시
         dialog.dialog("open");

         /**
          * 선택된 CM 처리 시작
          */
         function callActScript() {
             // 선택한 아이템 정보를 가져온다.
             var rowindexes = $jq('#cmList').jqxGrid('getselectedrowindexes');
             var cmids = '';
             rowindexes.forEach(index => {
                 var rowdata = getRowData($jq('#cmList'), index);
                 console.log(rowdata);
                 if (rowdata) {
                     cmids += rowdata.cm_id + ',';
                 }
             });

             console.log('cmids :: ' + cmids);

             closeModalDlg();
         }

         /**
          * 팝업 닫기 처리
          */
         function closeModalDlg() {
             dialog.dialog("close");
             dialog.remove();
         }

         /**
          * list index 번호를 이용하여 rowdata를 찾아서 리턴한다.
          * @param index
          * @returns {*|jQuery}
          */
         function getRowData($grid, index) {
             var data = $grid.jqxGrid('getrowdata', index);
             if (!data) {
                 var rowid = $grid.jqxGrid('getrowid', index);
                 data = $grid.jqxGrid('getrowdatabyid', rowid);
             }
             return data;
         }
     });


 }

</script>

<%@ include file="include/Field.End.jsp" %>

