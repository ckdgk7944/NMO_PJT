<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@page import="org.apache.commons.lang.RandomStringUtils"%>
<%@ include file="/xefc/jsp/include/session.jspf" %>
<%@ include file="/xefc/jsp/common/html_begin.jspf" %>
<head>
	<title>jdbc Connection</title>

<%@ include file="/xefc/jsp/common/script.jspf" %>
	<%@ include file="/xefc/jsp/common/script.jspf" %>
	<link href="/xplugin/jquery-confirm/jquery-confirm.min.css" rel="stylesheet" type="text/css">

<!-- Form Style CSS -->
<link href="/css/ui_form.css" rel="stylesheet" type="text/css">
<link href="/xplugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/xplugin/jqwidgets/styles/jqx.base.css" rel="stylesheet">
<link href="/xplugin/jqwidgets/styles/jqx.energyblue.css" rel="stylesheet">
<link href="/css/mgr/style.css" rel="stylesheet" type="text/css">
<link href="/css/mgr/style_ui.css" rel="stylesheet" type="text/css" />
<link href="/css/mgr/style_tab.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="/css/button.css" /><!-- Button, Condition -->

</head>
<style>
.body {
	height: 100%; width: 100%;
}
.wrapper {
	height: 100%; width: 100%;
}
.left {
	width: 40%; height: 100%;
	float: left; padding: 5px;
}
.right {
	width: 60%; height: 100%;
	float: left;
	border-left: 1px solid #CFDBE2;
}
.field_label {
	width: 30%;
	border: 1px solid #CFDBE2;
}
.field_value {
	width: 70%;
	border: 1px solid #CFDBE2;
}
.field_rq, .field {
	width: 100%;
}
.title {
	background-color: #009EDF;
	color : #FFFFFF;
	height:30px;
	text-align: center; vertical-align: middle;
	font-weight: bold; font-size: 13px;
	padding-top: 7px;
}
.res {
	padding: 10px;
}
</style>
<%
	com.steg.efc.Texts texts = com.steg.efc.Texts.getInstance();

	String label = texts.getText("연결테스트", session);
	String type = "lst-action";
	String align = "left";
	String fn = "handlerBtn()";

	ArrayList arry = getDBInfo();
	String etc = " class='field_rq' id='db_name' onChange=\"handlerDB_name(this)\" style='padding: 1px; width: 100%;' title='" + texts.getText("DB", session) + "'";
%>
<script type="text/javascript">
<!--
var db_obj = [];
<%
	for(int i = 0; i < arry.size(); i++) {
		Data d = (Data) arry.get(i);
		out.print("db_obj.push({ db: '" + d.get("DB") + "', db_class: '" + d.get("class")
			+ "', url: '" + d.get("url") + "', gbn_url: '" + d.get("gbn_url") + "', gbn_sid: '" + d.get("gbn_sid") + "', gbn_etc: '" + d.get("gbn_etc") + "' }); \n");
	}
%>

//연결 page call
callAjaxPage = function() {
	var frm = $jq("#frm_db");
	var params = "className=" + frm.find('[name=className]').val()
				+ "&url=" + frm.find('[name=url]').val()
				+ "&user=" + frm.find('[name=user]').val()
				+ "&pw=" + frm.find('[name=pw]').val()
				+ "&tab=" + frm.find('[name=tab]').val();
	var url = "jdbcConnectionTest.jsp?" + params.replace(/\s/gi, "");
	var div = "#res";

	$jq.ajax({
		url: url,
		async: true,
		type: "POST",
		success: function(result) {
			result = result.replace(/td>\s+<td/g,'td><td');
			$jq(div).html(result);
		}
	}).fail(function() {
		$jq(div).html("<%= texts.getText("관리자에게 문의하세요.", session) %>");
	});
}

//연결테스트 버튼 클릭
handlerBtn = function() {
	var bool = true;
	//필수체크
	$jq("#frm_db").find('input, select').each(function(idx){
		if("" == $jq(this).val() && "field" != $jq(this).attr("class")) {
			$egene.alert($jq(this).attr("title") + "<%= texts.getText("을(를) 입력하세요.", session)%>");
			$jq(this).focus();
			bool = false;
			return false;
		}
	});

	if(bool) {
		callAjaxPage(); //연결 page call
	}
}

//DB select box 선택
handlerDB_name = function(opt) {
	//console.log(opt);
	var info = selectDBInfo(opt.value);

	var frm = $jq("#frm_db");
	frm.find('[name=className]').val(info.db_class);
	frm.find('[name=url]').val(info.url);

	setConnectionURL(frm, info); //connection URL 정보 셋팅
}

//connection URL 정보 셋팅
setConnectionURL = function(frm, info) {
	var ip = frm.find('[name=ip]').val();
	var port = frm.find('[name=port]').val();
	var sid = frm.find('[name=sid]').val();

	var connUrl = info.url + ip + info.gbn_url + port + info.gbn_sid + sid + info.gbn_etc;
	frm.find('[name=url]').val(connUrl.replace(/\s/gi, ""));
}

//DB 정보 조회
selectDBInfo = function(val){
	var db_info = { db: "", db_class: "", url:"", gbn_url: "", gbn_sid: "", gbn_etc:""};

	$jq.each(db_obj, function(idx, item){

		//각 항목에 값을 셋팅
		if(val == item.db_class) {
			db_info.db = item.db;
			db_info.db_class = item.db_class;
			db_info.url = item.url;
			db_info.gbn_url = item.gbn_url;
			db_info.gbn_sid = item.gbn_sid;
			db_info.gbn_etc = item.gbn_etc;
			return false;
		}
	});
	return db_info;
}

$jq(document).ready(function(event) {
	var frm = $jq("#frm_db");

	//event
	frm.find('[name=ip], [name=port], [name=sid]').focusout(function(event) {
		var info = selectDBInfo(frm.find('[name=db]').val());
		//console.log(info);
		setConnectionURL(frm, info); //connection URL 정보 셋팅
	});
});

//-->
</script>
<body>
<div class="wrapper">
	<div class="left" id="info">
		<div class="f_ctrl_box">
			<table width="100%" class="lst-action">
			<tr>
				<td align="right"><%= createButton(label, fn, type, session) %></td>
			<tr>
			</table>
		</div>
		<div class="frm_area">
			<form id="frm_db" name="frm_db" action="">
			<table class="field_layout">
			<tr class="field_tr">
				<td class="field_label" title="<%= texts.getText("DB", session) %>"><%= texts.getText("DB", session) %></td>
				<td class="field_value">
					<%= getSelect("db", arry, "", texts.getText("[선택]", session), etc) %>
				</td>
			</tr>
			<tr class="field_tr">
				<td class="field_label" title="<%= texts.getText("Driver Class", session) %>"><%= texts.getText("Driver Class", session) %></td>
				<td class="field_value">
					<input type="text" class="field_rq" name="className" title="<%= texts.getText("Driver Class", session) %>" value="" />
				</td>
			</tr>
			<tr class="field_tr">
				<td class="field_label"><nobr><%= texts.getText("IP", session) %></nobr></td>
				<td class="field_value">
					<input type="text" class="field_rq" name="ip" title="<%= texts.getText("IP", session) %>" value=""/>
				</td>
			</tr>
			<tr class="field_tr">
				<td class="field_label"><nobr><%= texts.getText("Port", session) %></nobr></td>
				<td class="field_value">
					<input type="text" class="field_rq" name="port" title="<%= texts.getText("Port", session) %>" value=""/>
				</td>
			</tr>
			<tr class="field_tr">
				<td class="field_label"><nobr><%= texts.getText("SID/DB명", session) %></nobr></td>
				<td class="field_value">
					<input type="text" class="field_rq" name="sid" title="<%= texts.getText("SID/DB명", session) %>" value=""/>
				</td>
			</tr>
			<tr class="field_tr">
				<td class="field_label" title="<%= texts.getText("User ID", session) %>"><%= texts.getText("User ID", session) %></td>
				<td class="field_value">
					<input type="text" class="field_rq" name="user" title="<%= texts.getText("User ID", session) %>" value=""/>
				</td>
			</tr>
			<tr class="field_tr">
				<td class="field_label" title="<%= texts.getText("Password", session) %>"><%= texts.getText("Password", session) %></td>
				<td class="field_value">
					<input type="text" class="field_rq" name="pw" title="<%= texts.getText("Password", session) %>" value=""/>
				</td>
			</tr>
			<tr class="field_tr">
				<td class="field_label" title="<%= texts.getText("Connection URL", session) %>"><%= texts.getText("Connection URL", session) %></td>
				<td class="field_value">
					<input type="text" class="field_rq" name="url" title="<%= texts.getText("Connection URL", session) %>" value=""/>
				</td>
			</tr>
			<tr class="field_tr">
				<td class="field_label" title="<%= texts.getText("Select Table", session) %>"><%= texts.getText("Select Table", session) %></td>
				<td class="field_value">
					<input type="text" class="field" name="tab" title="<%= texts.getText("Select Table", session) %>" value=""/>
				</td>
			</tr>
			</table>
			</form>
		</div>
	</div>
	<div class="right">
		<div class="title"><%= texts.getText("Connection Result", session) %></div>
		<div class="res" id="res"><font style="font-size: 20px;"><%= texts.getText("Connection Test", session) %></font></div>
	</div>
</div>

</body>
</html>
<%!
	//DB 목록
	ArrayList getDBInfo() {
		ArrayList arry = new ArrayList();

		Data d = new Data();
		d.put("DB", "Oracle11");
		d.put("class", "oracle.jdbc.driver.OracleDriver");
		d.put("url", "jdbc:oracle:thin:@"); //db url 설정
		d.put("gbn_url", ":"); //ip 조합
		d.put("gbn_sid", ":"); //sid 조합
		d.put("gbn_etc", ""); //url 기타 설정
		arry.add(d);

		d = new Data();
		d.put("DB", "MySQL");
		d.put("class", "com.mysql.jdbc.Driver");
		d.put("url", "jdbc:mysql://");
		d.put("gbn_url", ":");
		d.put("gbn_sid", "/");
		d.put("gbn_etc", "");
		arry.add(d);

		d = new Data();
		d.put("DB", "Tibero6");
		d.put("class", "com.tmax.tibero.jdbc.TbDriver");
		d.put("url", "jdbc:tibero:thin:@");
		d.put("gbn_url", ":");
		d.put("gbn_sid", ":");
		d.put("gbn_etc", "");
		arry.add(d);

		d = new Data();
		d.put("DB", "CUBRID");
		d.put("class", "cubrid.jdbc.driver.CUBRIDDriver");
		d.put("url", "jdbc:cubrid:");
		d.put("gbn_url", ":");
		d.put("gbn_sid", ":");
		d.put("gbn_etc", ":dba::?charset=utf-8");
		arry.add(d);

		d = new Data();
		d.put("DB", "DB2(AS400)");
		d.put("class", "com.ibm.db2.jcc.DB2Driver");
		d.put("url", "jdbc:as400:");
		d.put("gbn_url", ":");
		d.put("gbn_sid", ";");
		d.put("gbn_etc", "prompt=false;");
		arry.add(d);

		d = new Data();
		d.put("DB", Texts.getInstance().getText("Select"));
		d.put("class", "-");
		d.put("url", "");
		d.put("gbn_url", "");
		d.put("gbn_sid", "");
		d.put("gbn_etc", "");
		arry.add(d);

		return arry;
	}

	//select box 구성
	String getSelect(String name, ArrayList arry, String dval, String dlabel, String etc) {

		String str = "<select id='" + name + "' name='" + name + "' " + etc + ">";

		if(dval != null) {
			str += "<option value='" + dval + "'>" + dlabel + "</option>";
		}

		for(int i = 0; i < arry.size(); i++) {
			Data d = (Data)arry.get(i);
			str += "<option value='" + d.get("class") + "' info='" + d.get("url") + "'>" + d.get("DB") + "</option>";
		}

		str += "</select>";
		return str;
	}
%>
<%@ include file="/xefc/jsp/common/ui.jsp" %>