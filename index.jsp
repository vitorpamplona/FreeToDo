<%@ page import="java.io.*" %>

<!doctype html>
<html>
  <head>
    <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">

    <title>To-do List</title>
    <link rel="stylesheet" href="lib/codemirror.css">
    <script src="lib/codemirror.js"></script>
    <script src="lib/shortcut.js"></script>
    <script src="todo.js"></script>
    <link rel="stylesheet" href="todo.css">

    <style>.CodeMirror {border-top: 1px solid #ddd; border-bottom: 1px solid #ddd; height: 100%; line-height:130%;}</style>
    <link rel="stylesheet" href="css/docs.css">
  </head>

  <body>
     <form name="ajax" method="POST" action="">
	<div style="float:right;">
	<INPUT name="btSave" type="BUTTON" value="Save!"  ONCLICK="saveList()" >
	</div>

        <h2>To-do List</h2>


	<textarea id="code" name="code"><%
            String file = application.getRealPath("/") + "todo_list.txt";
            File fileObject = new File(file);

            char data[] = new char[(int) fileObject.length()];
            FileReader filereader = new FileReader(file);

            int charsread = filereader.read(data);
            out.println(new String(data, 0 , charsread));
            //out.println(filereader.getEncoding());

            filereader.close();
        %></textarea>
	
    </form>

    <center>Powered by <a href="https://github.com/vitorpamplona/FreeToDo">FreeToDo</a></center>

    <script>
	var saveTimeout = null;
        var editor = CodeMirror.fromTextArea(document.getElementById("code"), {
		onChange: function() {
			document.ajax.btSave.value="Save!";
			window.clearTimeout(saveTimeout);
			saveTimeout = window.setTimeout('saveList()',3000);
		}
	});

	function saveList() { 
		var req = null; 

		if(window.XMLHttpRequest)
			req = new XMLHttpRequest(); 
		else if (window.ActiveXObject)
			req  = new ActiveXObject(Microsoft.XMLHTTP); 

		req.onreadystatechange = function() { 
			document.ajax.btSave.value="Wait server...";
			if(req.readyState == 4) {
				if(req.status == 200) {
					document.ajax.btSave.value="Saved";	
				} else {
					document.ajax.btSave.value="Error: " + req.status + " " + req.statusText;
				}	
			} 
		}; 

		req.open("POST", "save.jsp", true); 
		req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;"); 
		req.setRequestHeader("encoding", "UTF-8");
		req.send("todo_list="+encodeURIComponent(editor.getValue())); 
	} 

	shortcut.add("Ctrl+S",function() {
		window.clearTimeout(saveTimeout);
		saveList();
	});
    </script>

  </body>
</html>

