<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/script.jspf" %>

<div class="load" ></div>
<script>
    $('.load').load('/xefc/jsp/ui/manual/egenedoc_download_content.jsp', function(a, b, c){
        let CardViewControl = {

            fnGeneralCategory: function (result) {

                let html = '';
                let subHtml = '';
                let tabTitle = '';
                let newHtml = '';

                $.each(result, function (idx, obj) {

                    tabTitle = obj.name;
                    obj['p_name'] = tabTitle;

                    // new module
                    if(obj['hlp_top'] =='1'){
                        $('.new-list').show();
                        newHtml +=  CardViewControl.fnCreateCard(obj);
                    }
                    //module 대상
                    if(obj['lev'] == '1'){
                        //module
                        if(obj['hlp_cat_cd'] == 'HLPTYPE070'){
                            html += CardViewControl.fnCreateCard(obj);
                            // api/function
                        }else if(obj['hlp_cat_cd'] == 'HLPTYPE080'){
                            subHtml += CardViewControl.fnCreateCard(obj);
                        }
                    }
                });

                $('.main-list ul').append(html);
                $('.new-list ul').append(newHtml);
                $('.sub-list ul').append(subHtml);
            },

            //module
            fnCreateCard: function (item) {
                let temp = '';
                temp = '<li data-sid="' + getText(item.sid) + '"   data-name="' + getText(item.cat_name) + '" data-id="' + item.id + '">' +
                    '<h5>' + getText(item.cat_name) + '</h5>'+
                    '<div class = "sub-title-group">' + getText(item.hlp_descr) + '</div></li>';
                return temp;
            }
        };


        /**
         * nav 2레벨 하위
         * @param item
         * @param subtitle h2의 타이틀
         * @param subTmpId 현재 temp Id
         * @param bsubTmpId 이전 temp Id
         * @param i 현재 loop 수
         */
        function fnCreateSubAppendView(item,subtitle,subTmpId,bsubTmpId,i){

            if(item.root_id){
                var sub_li =
                    '<li data-name="' + getText(subtitle) + '" data-id="'+ getText(subTmpId) +'"> \
		            	<span class = "sub_li_name sub_level3">\
		            	<a href="#'+ subTmpId + '">\
		                	' + getText(subtitle) + '\
		            	</a></span>\
		         </li>';
                if(i == 0){
                    $(sub_li).insertAfter($('#nav_'+item.root_id+' li[data-id=' +  item.id + ']'));
                }else{
                    $(sub_li).insertAfter($('#nav_'+item.root_id+' li[data-id=' + bsubTmpId + ']'));
                }
            }
        }


        //카테고리  표시
        let CardContentViewControl = {

            fnGeneralCategory: function (result) {

                let html = '';
                var rootHtml = '';
                let contentHtml = '';
                let isStart = false;
                let tabTitle = '';

                var topArr = [];
                var subArr = [];

                $.each(result, function (idx, obj) {

                    if (obj.pid == '') {
                        topArr.push(obj);

                        if (isStart) {
                            isStart = !isStart;
                            html += CardContentViewControl.fnCreateCard(obj, isStart);
                        }

                        isStart = true;
                        tabTitle = obj.name;
                        obj['p_name'] = tabTitle;

                        html += CardContentViewControl.fnCreateCard(obj, isStart);
                    } else {
                        subArr.push(obj);
                    }
                });

                // 왼쪽 최상위 카테고리 화면 구성
                $('.nav-tree').html(html);

                for(var i=0; i<topArr.length; i++){
                    rootHtml += CardContentViewControl.fnCreateRootView(topArr[i]);
                }

                console.log(rootHtml);
                $('#mnl-container').html(rootHtml);

                for(var i=0; i<subArr.length; i++){
                    CardContentViewControl.fnCreateRootSubView(subArr[i]);
                }

                for(var i=0; i< result.length; i++){

                    if(result[i].pid == ''){
                        result[i].p_name = tabTitle;
                        contentHtml += CardContentViewControl.fnCreateMainView(result[i]);
                    }else{
                        CardContentViewControl.fnCreateSubView(result[i]);
                    }

                    $('.mnl-area#'+ result[i].id).append(contentHtml);
                    contentHtml = '';
                }
            },

            //대제목
            fnCreateCard: function (item, isStart) {
                let temp = '';
                if (isStart) {
                    temp =
                        '<li data-cat2="' + getText(item.id) + '" data-name="' + getText(item.name) + '" data-id="' + item.id + '"> \
                     <a href="#'+ item.id + '">'+ getText(item.name) + '</a></li>';
                } else {
                    temp += '';
                }
                return temp;
            },

            /**
             *  1레벨 root 기준으로 하위 nav 리스트 틀 생성 html
             * @param item
             */
            fnCreateRootView : function (item){
                let temp = '';
                temp = '<div class="mnl-area" data-cat2=' + getText(item.id) + ' id="' +item.id+ '">' +
                    '<nav class ="area-nav" id="area_nav_'+item.id+ '"> ' +
                    '<ul class="nav-brch" id=nav_' +item.id+ '>'+
                    '</ul>' +
                    '</nav>' +
                    ' </div>';
                return temp;
            },

            /**
             *  sid root 기준으로 하위 nav 리스트 데이터 생성 html
             * @param item
             */
            fnCreateRootSubView : function (item){
                var sid = item.root_id;
                var lev = item.lev;
                var lpadding = 0
                if(lev >= 3){
                    lpadding = (lev * 2)
                }
                if(sid){
                    var sub_li =
                        '<li  data-cat="' + getText(item.pid) + '" data-name="' + getText(item.name) + '" data-id="' + item.id + '"> \
		            	<span class = "sub_li_name" style= "padding-left: '+lpadding+'px;">\
		            	<a href="#'+ item.id + '">\
		                	' + getText(item.name) + '\
		            	</a></span>\
		         </li>';
                    $('#nav_'+sid).append(sub_li)
                }
            },

            /**
             *  1레벨 content html
             * @param item
             * @returns {string}
             */
            fnCreateMainView : function (item){
                let temp = '';
                temp = 	'<article class="mnl-article">' +
                    '<div class="mnl-article-box">'+
                    '<h2 id='+item.id+' class="atc-title">'+item.name+'</h2><div class ="article-editor" id='+item.id+'>'
                    +item.content+'</div></div></article>';
                return temp;
            },

            /**
             *  2레벨이후의  content html , 3레벨 이상일 경우 css 클래스 추가
             * @param item
             * @returns {string}
             */
            fnCreateSubView : function (item){

                let temp = '';
                if(item.lev > 2){
                    temp = '<article class="mnl-article level3"'
                }else{
                    temp = '<article class="mnl-article"'
                }

                temp +=  ' id=' +item.id+ '>' +
                    '<div class="mnl-article-box">'+
                    '<h2 id='+item.id+' class="atc-title">'+item.name+'</h2><div class ="article-editor" id='+item.id+'>'
                    +item.content+'</div></div></article>'

                $('.mnl-area#'+ item.root_id).append(temp);

                let cnt = $('.article-editor[id=' + item.id +']').find('h2 strong').length;

                var subtitle = '';

                for(var i = 0 ; i < cnt ; i++){

                    let elemenet = $('.article-editor[id=' + item.id +']').find('h2 strong')[i];
                    let elemenetParent = $(elemenet).parent();
                    subtitle = elemenet.innerText;
                    // id의 속성을 임의로 추가
                    $(elemenetParent).attr('id',item.id+'_'+i+'_tmp');
                    // 임의로 만들어진 ID로 nav append
                    fnCreateSubAppendView(item,subtitle,$(elemenetParent).attr('id'),item.id+'_'+(i-1)+'_tmp',i);
                }
            }
        }

        //css 초기값 반영
        function setCodeContent(hlp_id){
            let id = hlp_id;

            $('.nav-tree li[data-cat2='+ id +'] a').addClass('active');
            $('div[data-cat2='+ id +']').addClass('active');
            $('.nav-tree li[data-cat2='+ id +'] a').trigger('click', function (e) {
                $('.nav-tree a').removeClass('active');
                $('.mnl-area').removeClass('active');
                $(this).addClass('active');
                var activeID = $(this).attr('href');
                $(activeID).addClass('active');
            });


        }


        //카테고리 목록조회
		let manualList;

        $service.ajax({
            url: '/api/egene/sql/manual_Catagory',
            type: 'get',
            async: false,
        }, function(result){
            manualList = result;
            CardViewControl.fnGeneralCategory(manualList);
            $service.ajax({
                url: '/api/egene/sql/ED_Catagory',
                type: 'get',
                async: false,
            }, function(result){
                //카테고리 목록조회
                categoryList = result;
                CardContentViewControl.fnGeneralCategory(categoryList);
                const loadHtml = $('.load').html();

                // file 로직
                var ajaxUrl = '/api/egene/document/createDocument';
                var ajaxData = {html: loadHtml};
                var filePrefix = getText("DOCUMENT");
                var fileSuffix = "zip";
                downloadAjax(ajaxUrl, ajaxData, filePrefix, fileSuffix);
            });

		});
       /* debugger;
        var ajaxUrl = '/api/egene/document/createDocZip';
        var ajaxData = {html: loadHtml};
        var filePrefix = getText("DOCUMENT");
        var fileSuffix = "zip";
        downloadAjax(ajaxUrl, ajaxData, filePrefix, fileSuffix);*/

    });





</script>
