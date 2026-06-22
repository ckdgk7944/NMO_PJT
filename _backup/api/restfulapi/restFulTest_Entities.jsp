<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2020-07-28
  Time: 오후 3:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>RestFulAPI Entity Test</title>
    <script type="text/javascript" src="/xplugin/jquery/jquery-3.7.1.min.js"></script>
    <style>
        .flex-row {
            display: flex;
            flex-direction: row;
        }

        .flex-col {
            display: flex;
            flex-direction: column;
        }

        .flex-full {
            flex: 1;
        }

        .container {
            height: 100%;
        }

        .content {
            padding: 10px 5px;
            margin: 5px;
            border: 1px solid #999999;
        }

        .test, .result {
            width: 50%;
            /*margin-right: 10px;*/
        }

        .label {
            padding-bottom: 10px;
        }

        .item {
            padding-bottom: 10px;
        }

        .text-wrap {
            background: #eeeeee;
        }

        #data_format {
            height: 100%;
            width: 100%;
            margin: 0;
            border: 1px solid #999999;
        }
    </style>
</head>
<body>
<div class="container flex-row">
    <div class="content test flex-col">
        <div class="item flex-col">
            <div class="label">호출 API</div>
            <div class="flex-row">
                <input name="restUrl" class="flex-full" value="/egene/rest/api/entities/SRM">
                <button class="callApi">callApi</button>
            </div>
        </div>
        <div class="item">
            <input type="radio" id="type_post" name="type" value="post" checked>
            <label for="type_post">생성</label>
            <input type="radio" id="type_put" name="type" value="put">
            <label for="type_put">수정</label>
            <input type="radio" id="type_delete" name="type" value="delete">
            <label for="type_delete">삭제</label>
        </div>
        <div class="item flex-full">
            <pre id="data_format"></pre>
        </div>
    </div>
    <div class="content result flex-col">
        <div class="label"> 결과</div>
        <textarea id="result" class="text-wrap flex-full" style="width: 100%; resize: none;" disabled></textarea>
    </div>
</div>
<script>
    $(document).ready(function () {
        var el_data_format;
        var createObject = {
            rows: [
                {
                    curEmp: "admin",
                    ctrlId: "CTL02538",
                    curTaskId: "",
                    nextTaskId: "",
                    act: 1,
                    data: {
                        srm_id: "SRMRESTTEST001",
                        srm_cat_cd: "SRMCAT01010",
                        srm_req_title: "restFulApiTest #001",
                        srm_req_content: "This is restFulApi Test~~ #001",
                        relations: [
                            {
                                rltId: "RLT_TMPT_101",
                                type: "sync",
                                rows: [
                                    {
                                        key: "",
                                        tmp_text_05: "test1",
                                        tmp_text_06: "test2",
                                        tmp_text_07: "test3",
                                        tmp_text_08: "test4",
                                        tmp_text_09: "test5",
                                        tmp_text_10: "test6",
                                        tmp_text_11: "test7"
                                    }
                                ]
                            }
                        ]
                    }
                },
                {
                    curEmp: "admin",
                    ctrlId: "CTL02538",
                    curTaskId: "",
                    nextTaskId: "",
                    act: 1,
                    data: {
                        srm_id: "SRMRESTTEST002",
                        srm_cat_cd: "SRMCAT02010",
                        srm_req_title: "restFulApiTest #002",
                        srm_req_content: "This is restFulApi Test~~ #002"
                    }
                }
            ]
        };

        var updateObject = {
            rows: [
                {
                    ctrlId: "",
                    curEmp: "admin",
                    curTaskId: "TAS01635",
                    nextTaskId: "TAS01635",
                    act: 2,
                    data: {
                        srm_id: "SRMRESTTEST001",
                        srm_req_emp_id: "admin",
                        srm_dead_dttm: "20201015090000",
                        srm_med_cd: "SRMMED010",
                        srm_sys_id: "CM1902-05401",
                        srm_req_title: "restFulApiTest #001 Modify",
                        srm_req_content: "This is restFulApi Modify Test~~",
                        relations: []
                    }
                },
                {
                    ctrlId: "",
                    curEmp: "admin",
                    curTaskId: "TAS01635",
                    nextTaskId: "TAS01635",
                    act: 2,
                    data: {
                        srm_id: "SRMRESTTEST002",
                        srm_req_emp_id: "admin",
                        srm_dead_dttm: "20201015090000",
                        srm_med_cd: "SRMMED010",
                        srm_sys_id: "CM1902-05401",
                        srm_req_title: "restFulApiTest #002 Modify",
                        srm_req_content: "This is restFulApi Modify Test~~"
                    }
                }
            ]
        };

        var deleteObject = {
            rows: [
                {
                    ctrlId: "",
                    curEmp: "admin",
                    curTaskId: "",
                    nextTaskId: "",
                    act: 3,
                    data: {
                        srm_id: "SRMRESTTEST001",
                        relations: [
                            {
                                rltId: "RLT_TMPT_101",
                                type: "sync",
                                rows: []
                            }
                        ]
                    }
                },
                {
                    ctrlId: "",
                    curEmp: "admin",
                    curTaskId: "",
                    nextTaskId: "",
                    act: 3,
                    data: {
                        srm_id: "SRMRESTTEST002",
                        relations: [
                            {
                                rltId: "RLT_TMPT_101",
                                type: "sync",
                                rows: []
                            }
                        ]
                    }
                }
            ]
        };

        // editor
        el_data_format = ace.edit("data_format");
        el_data_format.setTheme("ace/theme/textmate");

        // init setting
        el_data_format.setValue(JSON.stringify(createObject, null, 2) || '');
        el_data_format.clearSelection();

        // type 변경 시 action
        $('input[name=type]').on('click', function () {
            var clickValue = $(this).val();
            if (clickValue === 'post') {
                el_data_format.setValue(JSON.stringify(createObject, null, 2) || '');
                el_data_format.clearSelection();
            } else if (clickValue === 'put') {
                el_data_format.setValue(JSON.stringify(updateObject, null, 2) || '');
                el_data_format.clearSelection();
            } else if (clickValue === 'delete') {
                el_data_format.setValue(JSON.stringify(deleteObject, null, 2) || '');
                el_data_format.clearSelection();
            }
        });

        // create
        $('.callApi').on('click', function () {
            var restUrl = $('input[name=restUrl]').val();
            var restParam = el_data_format.getValue();
            var type = 'POST';
            $.ajax({
                url: restUrl,
                type: type,
                data: restParam,
                success: function (result) {
                    $('#result').html(JSON.stringify(result, null, 2));
                }
            });
        });
    });
</script>
</body>
</html>
