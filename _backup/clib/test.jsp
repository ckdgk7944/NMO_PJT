<%@ page contentType="text/html; charset=utf-8" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
</head>
<body>

<script>


document.onpaste = function(event){

  var items = (event.clipboardData || event.originalEvent.clipboardData).items;
	alert(items);
  for (var i = 0 ; i < items.length ; i++) {

    var item = items[i];

    if (item.type.indexOf("image") != -1) {

      var file = item.getAsFile();
      console.log("file : "+file);
      upload_file_with_ajax(file);
    }
  }
}

function upload_file_with_ajax(file){

  var formData = new FormData();
  formData.append('file', file);

  $.ajax('./clipboard_js.php' , {

    type: 'POST',
    contentType: false,
    processData: false,
    data: formData,
    error: function() {
      console.log("error");
    },
    success: function(res) {
      console.log("ok");
    }
  });
  
}
function zzz(){
	  document.getElementById("demo").innerHTML = "Success!!!"
}



$(document).keydown(function(e) {
    if(e.key == "v" && e.ctrlKey) {
    	
        console.log('ctrl+v was pressed');
        
        //var items = (e.clipboardData || e.originalEvent.clipboardData).items;
        
        
        var fileList = window.clipboardData;
        
        alert("length : " + fileList.items);
        
        for (var i = 0; i < fileList.length; i++)
        {alert(123);
            var file = fileList[i];
            var url = URL.createObjectURL(file);
            //event.msConvertURL(file, "specified", url);
            //blobList.push(file);
        }        
        
        //console.log(window.clipboardData.getData("Text"));
    }
});








</script>
<canvas style="border:1px solid grey;" id="my_canvas" width="300" height="300"></canvas>


<input type="text" onpaste="javascript:zzz()" value="asdadsdsa asd asd asd" size="40">

<p id="demo"></p>


<input id="input_textbox" type="text" value="w3schools100">
<button id="copy_but">Copy to clipboard</button>
  
<script>
    var input = document.getElementById("input_textbox");
  
    $("#copy_but").click(function(event){
        event.preventDefault();
        input.select();
        document.execCommand("paste");
    });
</script>
</body>
</html>