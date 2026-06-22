<%@ page contentType="text/html; charset=utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script type="text/javascript"
	src="https://code.jquery.com/jquery-3.2.1.js">

</script>
<link rel="stylesheet" href="/css/stylesheet-pure-css.css">
<script>

</script>
</head>
<body>
	<table width="100%" border=1>
		<col width='25'>
		<col align=center width=100>
		<col align=center width=150>
		<col align=left width=200>
		<col align=center width=50>
		<col align=center width=90>
		<col align=center width=50>
		<col align=center width=60>
		<col align=center width=60>
		<col align=center width=80>
		<col align=left width=100>
		<tr class=header height=19>
			<th style='text-align: center;'>
				<div style='width:20px;height:10px;margin:0 auto;'>
					<input type=checkbox onClick="checkAllByEdit(this.checked, 22) "
						id="chkAll" name="" value=""> <label for="chkAll">
						<span>&nbsp;</span>
					</label>
				</div>
			</th>
			<th align=center class='grid_header_lb'>구분</th>
			<th align=center class='grid_header_lb'>업체명</th>
			<th align=center class='grid_header_lb'>계약명</th>
			<th align=center class='grid_header_lb'>평가인원</th>
			<th align=center class='grid_header_lb'>Key-담당자</th>
			<th align=center class='grid_header_lb'>설문평가</th>
			<th align=center class='grid_header_lb'>보안Test</th>
			<th align=center class='grid_header_lb'>총점</th>
			<th align=center class='grid_header_lb'>설문평가결과</th>
			<th align=center class='grid_header_lb'>비고</th>
		</tr>
	</table>
</body>
</html>


