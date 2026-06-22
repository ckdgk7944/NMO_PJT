<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script type ="text/javascript" src="https://code.jquery.com/jquery-3.2.1.js">
</script>
<script>
$(document).ready(function(){
	$("p").hover(
		function(){ //mouse in
			$("p").css("background-color","yellow");
		},
		function(){ //mouse leave
			$("p").css("background-color","pink");
		}
	);
});
</script>
</head>
<body bgcolor=#8dfc74>
	<p>이곳에 마우스 커서를 올려보세요</p>
</body>
</html>


