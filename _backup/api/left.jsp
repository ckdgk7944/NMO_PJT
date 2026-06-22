<%@ page contentType="text/html; charset=utf-8"%>
<html>
<style>
html,body{
	font: 12px dotum;
}

li {
	padding: 5px;
}
</style>
<body>
	
* Query
<ul>
	<li><a href="query1.jsp" target=svc>단순</a> [<a href="src.jsp?fname=query1.jsp" target=svc>소스</a>][<a href="sql.jsp?sql_id=Sample.Query.1" target=svc>Sql</a>]</li>
	<li><a href="query2.jsp" target=svc>동적변수</a> [<a href="src.jsp?fname=query2.jsp" target=svc>소스</a>][<a href="sql.jsp?sql_id=Sample.Query.2" target=svc>Sql</a>]</li>
	<li><a href="query5.jsp" target=svc>동적변수2</a> [<a href="src.jsp?fname=query5.jsp" target=svc>소스</a>][<a href="sql.jsp?sql_id=Sample.Query.5" target=svc>Sql</a>]</li>
	<li><a href="query3.jsp" target=svc>Cond 변수</a> [<a href="src.jsp?fname=query3.jsp" target=svc>소스</a>][<a href="sql.jsp?sql_id=Sample.Query.3" target=svc>Sql</a>]</li>
	<li><a href="query3_p.jsp" target=svc>Cond 변수&Page</a> [<a href="src.jsp?fname=query3_p.jsp" target=svc>소스</a>][<a href="sql.jsp?sql_id=Sample.Query.3" target=svc>Sql</a>]</li>
	<li><a href="query4.jsp" target=svc>Sql 자동변수</a> [<a href="src.jsp?fname=query4.jsp" target=svc>소스</a>][<a href="sql.jsp?sql_id=Sample.Query.4" target=svc>Sql</a>]</li>
</ul>
* DML
<ul>
	<li><a href="dml1.jsp" target=svc>추가</a> [<a href="src.jsp?fname=dml1.jsp" target=svc>소스</a>][<a href="sql.jsp?sql_id=Sample.Dml.Insert" target=svc>Sql</a>]</li>
	<li><a href="dml2.jsp" target=svc>멀티 추가</a> [<a href="src.jsp?fname=dml2.jsp" target=svc>소스</a>][<a href="sql.jsp?sql_id=Sample.Dml.MInsert" target=svc>Sql</a>]</li>
	<li><a href="dml3.jsp" target=svc>수정/삭제</a> [<a href="src.jsp?fname=dml3.jsp" target=svc>소스</a>]
			[<a href="sql.jsp?sql_id=Sample.Dml.Update" target=svc>수정Sql</a>][<a href="sql.jsp?sql_id=Sample.Dml.Delete" target=svc>삭제Sql</a>]</li>
	<li><a href="dml4.jsp" target=svc>멀티수정/삭제</a> [<a href="src.jsp?fname=dml4.jsp" target=svc>소스</a>]
			[<a href="sql.jsp?sql_id=Sample.Dml.MUpdate" target=svc>수정Sql</a>][<a href="sql.jsp?sql_id=Sample.Dml.MDelete" target=svc>삭제Sql</a>]</li>
	<li><a href="dml5.jsp" target=svc>트랜잭션유지 </a> [<a href="src.jsp?fname=dml5.jsp" target=svc>소스</a>]
		[<a href="sql.jsp?sql_id=Sample.Dml.Insert" target=svc>삽입Sql</a>][<a href="sql.jsp?sql_id=Sample.Dml.Update" target=svc>수정Sql</a>]</li>
	<li><a href="dml6.jsp" target=svc>트랜잭션유지_new </a> [<a href="src.jsp?fname=dml6.jsp" target=svc>소스</a>]
		[<a href="sql.jsp?sql_id=Sample.Dml.Insert1" target=svc>삽입Sql</a>][<a href="sql.jsp?sql_id=Sample.Dml.Update" target=svc>수정Sql</a>]</li>

</ul>

* ECR_SQL
<ul>
	<li><a href="ecr_sql.jsp" target=svc>ECR_SQL Query</a>  [<a href="src.jsp?fname=ecr_sql.jsp" target=svc>소스</a>] </li>
</ul>


* Ajax Sample
<ul>
	<li><a href="ajax/ajax_test.jsp" target=svc>Ajax Test</a>  <br>
			[<a href="src.jsp?fname=ajax/ajax_test.jsp" target=svc>Test소스</a>] <br>
			[<a href="src.jsp?fname=ajax/ajax_json.jsp" target=svc>Json Return 소스</a>] <br>
			[<a href="src.jsp?fname=ajax/ajax_script.jsp" target=svc>Script 실행 소스</a>] <br>
			[<a href="src.jsp?fname=ajax/ajax_contents.jsp" target=svc>getContents 소스</a>] 
	</li>
</ul>

* Restful API Sample
<ul>
	<li><a href="restfulapi/restFulTest_ajax.jsp" target=svc>Entity Test</a>
		[<a href="src.jsp?fname=restfulapi/restFulTest_ajax.jsp" target=svc>Test소스</a>]
	</li>
	<li><a href="restfulapi/restFulTest_Entities.jsp" target=svc>Entities Test</a>
		[<a href="src.jsp?fname=restfulapi/restFulTest_Entities.jsp" target=svc>Test소스</a>]
	</li>
</ul>
</body>
</html>
