<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="org.sdf.servlet.*,
                           org.sdf.rdb.*,
                           org.sdf.util.*,
                           org.sdf.log.*,
                           org.sdf.lang.*,
                           com.steg.org.json.simple.*"
                import="java.util.*,java.sql.*"     
                import="com.steg.efc.*"
                           
%>
<%@ include file="/xefc/jsp/common/page.jsp" %>
<%
	Box box = HttpUtility.getBox(request);	
	
	Texts texts = Texts.getInstance();
	
	String sql_id = "Sample.Query.3";
	ICE ice = ICE.getInstance();
	Sqls sqls = ice.sqls();
	
	String id = box.get("id");
	String name = box.get("name");
	
	
	Condition cond = new Condition(false);
	cond.add("sam_id", id);
	cond.addLike("sam_name", name);
	
	AList l = new AList();
	l.add("cond", cond);
	
	int curpage = 1;
	int pagesize = 10;
	if(box.valid("curpage")) curpage = box.getInt("curpage");
	if(box.valid("pagesize")) pagesize = box.getInt("pagesize");
	
	Result r = sqls.getResult(sql_id, l, curpage, pagesize);
	
	RecordSet rs = r.getRecordSet();
%>
<html>
<style>
	html,body{
		font:11px dotum;	
	}
	
	th{
		font:bold 11px dotum;	
		background-color:#afafaf;
	}
	
	td{
		font:11px dotum;	
	}
</style>			
<body>

<form name=frm method=post>
<input type=hidden name=curpage>
<input type=hidden name=pagesize>	
	
ID : <input type=text name=id value="<%= box.get("id") %>">
이름 : <input type=text name=name value="<%= box.get("name") %>">
	
	<input type=submit value="확인">

<div>
	<div  >
			<table  >
			<tr><td>
				[<span class=curpage><%= rs.getCurPage() %></span>/<span class=totalpage><%= rs.getTotalPage() %></span>]
			( <%=texts.getText("전체" ,session)%> : <span class=totalcnt><%= rs.getTotalCount() %></span><%=texts.getText("건/페이지 당" ,session)%> : <span class=pagesize><%= rs.getPageSize() %></span><%=texts.getText("건" ,session)%> )
			</td>
		
			<td align=right>
            <%= getPageForm(rs,"frm","","", rs.getPageSize()) %>   
           </td>
          </tr>
        </table>
	</div>  	
	
<table border=1>
	<col width=30>
	<col width=100>	
	<col width=200>
	<col width=150>
	<col width=400>
<tr>	
	<th>No</th>
	<th>ID</th>
	<th>name</th>
	<th>등록일시</th>
	<th>제목</th>
</tr>

<%
	if(rs.getRowCount() == 0){			
%>
	<tr><td colspan=6>데이터가 없습니다.</td></tr>
<%
	}else{
		for(int i=0; rs.next(); i++){
%>
	<tr>	
		<td><%= (i+1) %></td>
		<td><%= rs.get("sam_id") %></td>
		<td><%= rs.get("sam_name") %></td>
		<td><%= rs.get("sam_reg_dttm") %></td>
		<td><%= rs.get("sam_title") %></td>
	</tr>
<%
		}
	}
%>
</tr>
</table>	

</div>
</form>

</body>	
</html>		
