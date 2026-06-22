<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ include file="/xefc/jsp/common/form.jsp" %>
<%@ include file="/xefc/jsp/common/page.jsp" %>
<%@ include file="/xefc/jsp/ui/list/include/format.jsp" %>

<div class="page-main">

    <style>
        .left-box {
            float: left;
            width: 200px;
            height: 100%;
        }

        .tree-box {
            height: 100%;
        }

        .content-box {
            padding-left: 210px;
            height: 100%;
        }

    </style>

    <div class="left-box">
        <div class="tree-box">
            <div id="treeGrid" style="height: 100%; overflow: auto;"></div>
        </div>
    </div>

    <div class="content-box">
        <div id="cmList"></div>
    </div>
</div>

<script type="text/javascript">
    $jq(document).ready(function () {
        // CM 유형 트리
        // prepare the data
        var source = {
            datatype: "json",
            url: '/api/egene/sql/XTree.CMCAT.Select.LIT',
            datafields: [
                {name: 'id', type: 'string'},
                {name: 'pid', type: 'string'},
                {name: 'name', type: 'string'},
                {name: 'lev', type: 'string'}
            ],
            id: 'id'
        };

        // create data adapter. 비동기 데이타 가져오고 실행
        var dataAdapter = new $jq.jqx.dataAdapter(source, {async: false});
        // perform Data Binding.
        dataAdapter.dataBind();
        var records = dataAdapter.getRecordsHierarchy('id', 'pid', 'items', [{name: 'name', map: 'label'}]);
        $jq('#treeGrid').jqxTree({source: records});
        //펼침 default 설정
        $jq('#treeGrid').jqxTree('expandAll');

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

        // CM 목록 조회

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
                {datafield: 'cm_cat_nm', text: '분류', width: '100px', align: 'center', cellsalign: 'center'}
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

        // 구성 유형 선택 시
        $jq('#treeGrid').on('itemClick', function (event) {
            if (event.args) {
                var item = event.args.owner.selectedItem;
                if (item) {
                    var key = item.label;

                    // 그리드 filtering
                    var filtertype = 'stringfilter';
                    var datafield = 'cm_cat_nm';
                    var filtergroup = new $jq.jqx.filter();

                    var filter_or_operator = 1;
                    var filtercondition = 'equal';
                    var filter = filtergroup.createfilter(filtertype, key, filtercondition);
                    filtergroup.addfilter(filter_or_operator, filter);

                    $jq("#cmList").jqxGrid('addfilter', datafield, filtergroup);
                    // apply the filters.
                    $jq("#cmList").jqxGrid('applyfilters');
                }
            }
        });

    });
</script>
