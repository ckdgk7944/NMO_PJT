<%@page import="eu.bitwalker.useragentutils.UserAgent"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/xefc/jsp/common/import.jspf"%>
<%
	String userAgentString = request.getHeader("User-Agent").toLowerCase(Locale.ENGLISH).;
	String userAgent = getUserAgent(userAgentString);
	
	out.println("contents : "+userAgent);
%>
<%!

	public String getUserAgent(String userAgentString) 
			throws Exception {
		UserAgent userAgent = UserAgent.parseUserAgentString(userAgentString);
	
		String contents = "";
	
		contents += "\r\n\r\n\r\n User Broswer : " + userAgent.getBrowser().getName() + " ("
				+ userBrowserBit(userAgentString) + " - "
				+ userAgent.getBrowser().getManufacturer().getName() + ")";
	
		contents += "\r\n User OS : " + userAgent.getOperatingSystem().getName() + " ("
				+ userOsBit(userAgentString) + " - "
				+ userAgent.getOperatingSystem().getManufacturer().getName() + ")";
	
		contents += "\r\n User Device : " + userAgent.getOperatingSystem().getDeviceType().getName();
	
		contents += "\r\n User IE compatible Mode : " + isCompatibleMode(userAgentString);	
		
		return contents;
	}

	public Boolean isCompatibleMode(String userAgent)
			throws Exception {
		if (userAgent.indexOf("MSIE 7") > 0 && userAgent.indexOf("Trident") > 0) {
			return true;
		} else {
			return false;
		}
	}

	public String userOsBit(String userAgent)
			throws Exception {
		if (userAgent.indexOf("x64") > 0 || userAgent.indexOf("wow64") > 0) {
			return "64bit";
		} else {
			return "32bit";
		}
	}

	public String userBrowserBit(String userAgent)
			throws Exception {
		if (userAgent.indexOf("win64") > 0) {
			return "64bit";
		} else {
			return "32bit";
		}
	}
%>