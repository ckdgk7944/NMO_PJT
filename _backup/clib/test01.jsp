<!DOCTYPE html>
<html>
<head>
<meta name="description" content="">
<meta charset="utf-8">
<script src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="pasteimage.js"></script>
<script>
	//Cross-browser function to select content
	function SelectText(element) {
		var doc = document;
		if (doc.body.createTextRange) {
			var range = document.body.createTextRange();
			range.moveToElementText(element);
			range.select();
		} else if (window.getSelection) {
			var selection = window.getSelection();
			var range = document.createRange();
			range.selectNodeContents(element);
			selection.removeAllRanges();
			selection.addRange(range);
		}
	}
	$(".copyable").click(function (e) {
		//Make the container Div contenteditable
		$(this).attr("contenteditable", true);
		//Select the image
		SelectText($(this).get(0));
		//Execute copy Command
		//Note: This will ONLY work directly inside a click listenner
		document.execCommand('copy');
		//Unselect the content
		window.getSelection().removeAllRanges();
		//Make the container Div uneditable again
		$(this).removeAttr("contenteditable");
		//Success!!
		alert("image copied!");
	});
</script>


</head>
<body>
<div class="copyable"> <img src="images/sherlock.jpg" alt="Copy Image to Clipboard via Javascript."/> </div>


<div class="copyable"> <img src="/images/ui/menu_sc/100000_sub_new.png" alt="Copy Image to Clipboard via Javascript."/> </div>


</body>
</html>