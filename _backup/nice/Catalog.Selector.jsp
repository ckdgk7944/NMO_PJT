<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ include file="/xefc/jsp/common/form.jsp" %>
<%@ include file="/xefc/jsp/common/page.jsp" %>
<%@ include file="/xefc/jsp/ui/list/include/format.jsp" %>

<div class="page-main">

    <style>
        .content-box {
            height: 100%;
        }

    </style>

    <div class="content-box">
        <div id="cmList"></div>
    </div>
</div>

<script type="text/javascript">
    $jq(document).ready(function () {

        // CM 목록 조회

        // jqx Adapter
        var cmSource = {
            datatype: 'json',
            url: '/api/egene/sql/UI.CM.Select.All',
            datafields: [
                {name: 'cm_id', type: 'string'},
                {name: 'cm_name', type: 'string'},
                {name: 'cm_pid', type: 'string'},
                {name: 'cm_cat_cd', type: 'string'},
                {name: 'cm_cat_nm', type: 'string'}
            ]
        };

        var cmDataAdapter = new $jq.jqx.dataAdapter(cmSource);

        // set jqxgrid setting config
        $jq("#cmList").jqxGrid({
            width: '100%',
            height: '100%',
            source: cmDataAdapter,
            editable: false,
            selectionmode: 'checkbox',
            pageable: true,
            showfilterrow: true,
            filterable: true,
            columns: [
                {datafield: 'cm_id', text: 'CM ID', align: 'center', cellsalign: 'center'},
                {datafield: 'cm_name', text: 'CM 이름', width: '200px', align: 'center', cellsalign: 'center'},
                {datafield: 'cm_cat_nm', text: '분류', width: '150px', align: 'center', cellsalign: 'center', filtertype: 'list'}
            ],
            filterable: true
        });

        // jqxgrid 데이터 로딩되고 바인딩 완료된 후 수행한다.
        // 로딩된 정보중에 선택된 CM이 있다면 선택 상태로 표시한다.
        $jq("#cmList").on("bindingcomplete", function (event) {
            // jqxgrid에 바인딩된 데이터 리스트
            var records = event.owner.source.records;
            // 기존에 선택된 id 정보
            var ids = $jq('.custom-dialog').attr('cmids');

            for (var i = 0; i < records.length; i++) {
                var record = records[i];
                var id = record.cm_id;
                if (ids && ids.indexOf(id) >= 0) {
                    $('#cmList').jqxGrid('selectrow', i);
                }
            }
        });
    });
</script>
