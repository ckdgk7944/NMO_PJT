<%@ page contentType="text/html; charset=utf-8"  %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%

	Box box = HttpUtility.getBox(request);

	boolean nodelay = true;
	//SRM 요청 메일 테스트
	
	String content_id = "Mail.Content.Satisfy.COPY";
	String sql_to = "Mail.To.ReqEmp.COPY";
	String sql_content = "SRM.Mail.Content.Sql.COPY";
	String key = "SR2105-00349";
	String mail_uri = "/xefc/jsp/acts/sendMailDirect.jsp";
	mail_uri += "?content_id="+content_id+"&sql_to="+sql_to+"&var/key="+key+"&sql_content="+sql_content+"&nodelay=" + nodelay + "&var/ent_id=SRM&mail=true&var/user_charset=kr";
	
	
	/**
	//서비스수준 위반 알림 메일 발송 : 여러 개의 데이터를 보내는 경우
	String content_id = "Mail.SLM.Violet.Content";
	String sql_to = "Mail.SLM.Violet.To";
	//String sql_content = "Mail.SLM.Violet";
	String mail_uri = "/xefc/jsp/acts/sendMailSlmMulti.jsp";

	mail_uri += "?content_id="+content_id+"&sql_to="+sql_to+"&nodelay=" + nodelay;
	**/
%>		
	<jsp:include page="<%= mail_uri %>" flush="true" />
