<%--
  User: gojaehag
  Date: 12/11/2019
  Time: 10:18 AM
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ include file="/xefc/jsp/common/form.jsp" %>
<!doctype html>
<html lang="ko">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1">
    <link rel="shortcut icon" href="/favicon.ico"><!-- Chrome, Safari, IE -->
    <link rel="icon" href="/favicon.png"><!-- Chrome, Safari, IE -->
    <link rel="apple-touch-icon-precomposed" href="/favicon.ico"><!-- iphone -->
    <meta name="author" content="STEG">
    <meta http-equiv="Publisher" content="STEG"/>
    <meta name="description" content="eGene Lightning">
    <meta name="Keywords" content="egene, itsm, steg, itom"/>
    <meta name="Robots" content="noindex, nofollow"/>
    <!-- 검색엔진 제외 https://webclub.tistory.com/354 -->
    <!-- Cache 사용 하지 않도록 -->
    <%--<meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Pragma" content="no-cache" />--%>


    <link href="/xplugin/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="/xplugin/jquery/ui/1.13.2/jquery-ui.css" rel="stylesheet" type="text/css">
    <link href="/xplugin/jquery-confirm/jquery-confirm.min.css" rel="stylesheet" type="text/css">
    <link href="/xplugin/jqwidgets/styles/jqx.base.css" rel="stylesheet" type="text/css"/>
    <link href="/xplugin/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>

    <link rel="stylesheet" type="text/css" href="/css/stylesheet-pure-css.css">
    <link rel="stylesheet" type="text/css" href="/css/ui_preform.css">
    <link rel="stylesheet" type="text/css" href="/css/jqx.custom.css">
    <link rel="stylesheet" type="text/css" href="/css/ui_stab.css">
    <link rel="stylesheet" type="text/css" href="/css/ui_daepicker.css">
    <link rel="stylesheet" type="text/css" href="/css/style.css">
    <link rel="stylesheet" type="text/css" href="/css/ui_atom.css">
    <link rel="stylesheet" type="text/css" href="/css/dtree.css">
    <link rel="stylesheet" type="text/css" href="/css/userInfo.css">
    <link rel="stylesheet" type="text/css" href="/css/contents.css">
    <link rel="stylesheet" type="text/css" href="/css/ui_form.css">
    <link rel="stylesheet" type="text/css" href="/css/ui_list.css">
    <link rel="stylesheet" type="text/css" href="/css/ui_grid.css">
    <link rel="stylesheet" type="text/css" href="/css/category_list.css">
    <link rel="stylesheet" type="text/css" href="/css/button.css">
    <link rel="stylesheet" type="text/css" href="/css/ui_wfm.css">
    <link rel="stylesheet" type="text/css" href="/css/colors/main.css" id="colors">
    <link rel="stylesheet" type="text/css" href="/css/ect.css">
    <link rel="stylesheet" type="text/css" href="/css/media.css">
    <link rel="stylesheet" type="text/css" href="/xplugin/jquery-mentions-input-master/jquery.mentionsInput.css">
    <link rel="stylesheet" type="text/css" href="/xplugin/jQuery-Upload-File/4.0.11/uploadfile.css">
    <link rel="stylesheet" type="text/css" href="/css/lit.css">
    <link rel="stylesheet" type="text/css" href="/css/atom.css">

    <!-- Portal css -->
    <link href="/css/xportal/style.css" rel="stylesheet" type="text/css"/>


    <%@ include file="/xefc/jsp/common/script.jspf" %>


    <style>

        #search {
            position: relative;
            font-size: 18px;
            padding-top: 40px;
            margin: -20px auto 0;
        }

        #search label {
            position: absolute;
            left: 17px;
            top: 48px;
        }

        #search #search-keyword, #search .hint {
            padding-left: 43px;
            padding-right: 43px;
            /*border-radius: 23px;*/
        }

        .input-lg {
            height: 46px;
            padding: 10px 16px;
            font-size: 18px;
            line-height: 1.3333333;
            border-radius: 6px;
        }

        .form-control {
            display: block;
            width: 100%;
            height: 34px;
            padding: 6px 12px;
            font-size: 14px;
            line-height: 1.42857143;
            color: #555;
            background-color: #fff;
            background-image: none;
            border: 1px solid #ccc;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
            -webkit-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
            -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
            transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
        }

        #search-suggest {
            padding: 5px 10px;
        }

        #search-suggest ul, #search-suggest li,
        .list_info ul, .list_info li,
        #search_title_result ul, #search_title_result li {
            list-style: none;
        }

        #search_title_result li {
            padding: 5px;
        }

        #search_title_result {
            border-left: 1px solid #dee2e6;
            border-right: 1px solid #dee2e6;
            border-bottom: 1px solid #dee2e6;
            font-size: 14px;
        }


        #search-suggest li {
            float: left;
            padding-right: 10px;
        }

        .list_info li {
            padding-top: 17px;
        }

        /* 결과 없음 */
        .list_cont li {
            padding-top: 0px;
        }

        .list_info .s_title {
            float: left;
            padding-bottom: 3px;
            font-size: 14px;
            line-height: 15px;
        }

        /* 검색 결과 타이틀 */
        .list_info .search_link_t {
            text-decoration: underline;
            white-space: nowrap;
            font-size: 14px;
            letter-spacing: -0.03em;
            cursor: pointer;
        }

        .list_info .desc {
            color: #333;
            padding-top: 10px;
            line-height: 18px;
            clear: both;
        }

        .result_info {
            height: 27px;
            padding-top: 19px;
            margin-bottom: 10px;
        }

        .result_info .sort_comm {
            display: inline;
            float: left;
            margin: 7px 0 0 16px;
            font-size: 12px;
        }

        .result_info .sub_expander {
            display: inline;
            float: right;
            margin-top: 2px;
            margin-right: 20px;
        }

        .pagingArea {
            padding: 23px 20px 19px;
            text-align: center;
        }

        em.searchToken {
            font-weight: bold;
            background: yellow;
        }
    </style>
</head>


<body>
<div class="container">
    <div class="row">
        <div class="col-sm-10">
            <section id="search">
                <label for="search-keyword">
                    <i class="fa fa-search" aria-hidden="true"></i>
                </label>
                <input id="search-keyword"
                       name="keyword"
                       class="form-control input-lg"
                       placeholder="Search"
                       autocomplete="off" spellcheck="false" autocorrect="off" tabindex="1">
                <input id="search-pageindex" type="hidden"/>
                <input id="search-bekeyword" type="hidden"/>

                <div id="search_title_result" style="display: none;">
                </div>
            </section>

        </div>
    </div>
    <div class="row">
        <div class="col-sm-10">
            <section id="search-suggest">
                <ul>
                    <li><a>서비스요청</a></li>
                    <li>에스티이지</li>
                    <li>코로나</li>
                </ul>
            </section>
        </div>
    </div>

    <div class="row result_info">
        <div class="col-sm-10">
            <div class="sort_comm">

            </div>
            <div class="sub_expander">
                   <span>
                       약 <span class="result_total_cnt">0</span>건
                       ...<span class="result_ms"></span>ms
                   </span>
            </div>
        </div>

    </div>
    <div class="row search_result">
        <div class="col-sm-10">
            <div class="list_info">
            </div>
        </div>
    </div>

    <div class="row pagingArea">
        <<%--span> &lt; </span>
           <span>
               <a>1</a>
               <a>2</a>
               <a>3</a>
               <a>4</a>
           </span>
           <span> &gt; </span>--%>
        <span class="addCollection fa-icon">수집</span>
    </div>

    <div class="row pagingArea">
        <<%--span> &lt; </span>
           <span>
               <a>1</a>
               <a>2</a>
               <a>3</a>
               <a>4</a>
           </span>
           <span> &gt; </span>--%>
        <span class="reindex fa-icon">재수집</span>
    </div>

</div>
</body>

<!-- 칼럼 항목 UX -->
<script type="x/template" id="search_noresult_template">
    <div>
        <div class="mg_cont">
            <strong class="tit"><b>{{keyword}}</b> 에 대한 검색결과가 없습니다.</strong>
            <ul class="list_cont">

                <li>ㆍ검색어의 단어 수를 줄이거나, 보다 일반적인 단어로 검색해 보세요.</li>
                <li>ㆍ두 단어 이상의 키워드로 검색 하신 경우, 정확하게 띄어쓰기를 한 후 검색해 보세요.</li>
                <li>ㆍ키워드에 있는 특수문자를 뺀 후에 검색해 보세요.</li>
            </ul>
        </div>
    </div>
</script>
<script type="x/template" id="search_resulttitle_template">
    <ul>
        <li data-ent_id="{{ent_id}}" data-key="{{id}}" data-id="{{_id}}" data-link="{{link}}">
            <i class="fa {{icon}}"></i>{{highlight_title}}
        </li>
    </ul>
</script>
<script type="x/template" id="search_result_template">
    <ul>
        <li>
            <div>
                <div class="s_title">
                    <span class="search_link_t" data-ent_id="{{ent_id}}" data-key="{{id}}">
                        <i class="fa fa-icon {{icon}}"></i>
                        <span>[{{ent_name}}]</span>
                        <span>{{highlight_title}}</span>
                    </span>
                </div>
            </div>
            <p class="desc">{{highlight_content}}</p>
            <div>
                <span>{{req_emp_name}}</span>
                <span>{{dt}}</span>
            </div>

        </li>
    </ul>
</script>

<script type="text/javascript">
    $(document).ready(function () {

        var template_html = $('#search_result_template').html();
        var template_title_html = $('#search_resulttitle_template').html();
        var tmp_noresult_html = $('#search_noresult_template').html();
        var result_body = $('div.search_result div.list_info');
        var $el = {
            search_title_result: $('#search_title_result'),
            searchKeyword: $('#search-keyword')
        };
        var searchTimer;

        /**
         * KeyInput 검색
         * **/
        $el.searchKeyword.on('keyup', function (e) {
            var keyCode = e.keyCode;
            var data = fnGetParam();

            clearTimeout(searchTimer);
            if (keyCode == 13) {
                fnSearch();
            } else {

                if (data['keyword'].length >= 2) {
                    searchTimer = setTimeout(fnTitleSearch, 300);
                } else {
                    if ($el.search_title_result.attr('display') == 'none') {
                        return;
                    }
                    $el.search_title_result.hide();
                }
            }
        });


        $('span.addCollection').on('click', function () {
            $service.ajax({
                url: '/api/egene/search/collection',
                method: 'GET'
            }, function (result) {

                console.log(result);
            })
        });

        $('span.reindex').on('click', function () {
            $service.ajax({
                url: '/api/egene/search/collection',
                method: 'GET'
            }, function (result) {

                console.log(result);
            })
        });

        result_body.on('click', '.search_link_t', function (e) {
            var el = $(this);

            var key = el.attr('data-key');
            var ent_id = el.attr('data-ent_id');

            var url = '/xefc/jsp/ui/form/form.jsp';
            if (ent_id == 'EMM') {
                url = '/xefc/jsp/ui/manual/tui_viewer.jsp'
            } else if (ent_id == 'MEN') {
                // todo
            }

            showWin('/xefc/jsp/ui/popup_layout.jsp',
                'uri=' + url + '&ent_id=' + ent_id
                + '&key=' + key + '&_title=', '', null, null, '_search' + key);

        });

        /**
         * 조회
         * */
        var fnTitleSearch = function () {
            var data = fnGetParam();
            var keyword = data.keyword || '';

            // keyword 백업
            $('#search-bekeyword').val(keyword);

            $service.ajax({
                url: '/api/egene/searchtitle',
                method: 'GET',
                data: data
            }, function (result) {
                var resultData = result.data;
                var resultInfo = JSON.parse(resultData);

                fnTitleResultShow(resultInfo);
            }, true)
        }

        var fnTitleResultShow = function (result) {

            var html = '';
            var hits = result.hits;
            var arrHits = hits.hits;
            var len = arrHits.length;

            if (len === 0) {
                $el.search_title_result.hide();
            } else {
                for (var i = 0; i < len; i++) {
                    var hit = arrHits[i];
                    var map = hit._source;
                    var highlight = hit['highlight'];
                    var title = map.title;
                    if (highlight) {
                        title = hit.highlight['title'] || map.title;
                    }
                    map['highlight_title'] = title;


                    html += $.fn.fnRenderTemplate(template_title_html, map);
                }
            }

            $el.search_title_result.empty().append(html);
            $el.search_title_result.show();

        }

        /**
         * 조회
         * */
        var fnSearch = function () {
            var data = fnGetParam();
            var keyword = data.keyword || '';

            if (keyword.length <= 1) return false;

            // keyword 백업
            $('#search-bekeyword').val(keyword);

            $service.ajax({
                url: '/api/egene/search',
                method: 'GET',
                data: data
            }, function (result) {
                console.log(result);
                // var resultInfo = result.data;
                var resultData = result.data;
                var resultInfo = JSON.parse(resultData);

                fnResultShow(resultInfo);
            }, true)
        }

        var fnResultShow = function (result) {

            var html = '';
            var hits = result.hits;
            var arrHits = hits.hits;
            var len = arrHits.length;


            if (len === 0) {
                var data = fnGetParam();
                html = $.fn.fnRenderTemplate(tmp_noresult_html, data);
            } else {
                for (var i = 0; i < len; i++) {
                    var hit = arrHits[i];
                    var map = hit._source;
                    var highlight = hit['highlight'];
                    var title = map.title;
                    var content = map.content;
                    if (highlight) {
                        title = hit.highlight['title'] || map.title;
                        content = hit.highlight['content'] || map.content;
                    }
                    map['highlight_title'] = title;
                    map['highlight_content'] = content;
                    map['dt'] = fnGetDateFormat(map['req_dttm']);

                    html += $.fn.fnRenderTemplate(template_html, map);
                }
            }

            result_body.empty().append(html);
            $('span.result_total_cnt').html(hits.total.value);
            $('span.result_ms').html(result.took || 0);

        }
        // 일반검색
        // var fnResultShow = function(result){
        //
        //     var html = '';
        //     var hits = result.internalResponse.hits;
        //     var arrHits = hits.hits;
        //     var len = arrHits.length;
        //
        //
        //     if(len === 0) {
        //         var data = fnGetParam();
        //         html = $.fn.fnRenderTemplate(tmp_noresult_html, data);
        //     } else {
        //         for (var i = 0; i < len; i++) {
        //             var hit = arrHits[i];
        //             var map = hit.sourceAsMap;
        //             var title = hit.highlightFields.title.fragments[0] || hit.sourceAsMap.title;
        //             var content = hit.highlightFields.content.fragments[0] ||  hit.sourceAsMap.content;
        //             map['highlight_title'] = title;
        //             map['highlight_content'] = content;
        //
        //             html += $.fn.fnRenderTemplate(template_html, map);
        //         }
        //     }
        //
        //     result_body.empty().append(html);
        //     $('span.result_total_cnt').html(hits.totalHits.value);
        //     $('span.result_ms').html(result.took.millis);
        //
        // }


        /**
         * 조회 조건 파라메터
         */
        var fnGetParam = function () {

            var data = {
                'formsize': ($('#search-pageindex').val() || 0) * 10,
                'keyword': $('#search-keyword').val(),
                'bekeyword': $('#search-bekeyword').val()
            };

            return data;
        }

        var fnGetDateFormat = function (time) {

            if (!time) return '';
            var format = 'YYYY-MM-DD';

            var yyyy = time.substring(0, 4);
            var mm = time.substring(4, 6);
            var dd = time.substring(6, 8);
            var result = format;

            result = result.replace(/YYYY/ig, yyyy);
            result = result.replace(/MM/ig, mm);
            result = result.replace(/DD/ig, dd);

            return result;


        }

    })
</script>

</html>