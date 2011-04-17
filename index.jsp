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

    <script src="https://www.google.com/jsapi?key=ABQIAAAAGFyZXBGYY8T2sP2n2EMRERQYhbeF10lDRB36msDv6drkT2aUeRQ5mzc-lyHhtb51G37OcN8IBA3HCw" type="text/javascript"></script>

    <script type="text/javascript">

	function getCookie(c_name)
	{
	var i,x,y,ARRcookies=document.cookie.split(";");
	for (i=0;i<ARRcookies.length;i++)
	{
	  x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
	  y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
	  x=x.replace(/^\s+|\s+$/g,"");
	  if (x==c_name)
	    {
	    return unescape(y);
	    }
	  }
	}

	var scope = "http://www.google.com/calendar/feeds";
 	var token;

	// Load the latest version of the Google Data JavaScript Client
	google.load('gdata', '2.x');

	function logMeIn() {
	   var status = google.accounts.user.getStatus();
           if (status == google.accounts.AuthSubStatus.LOGGED_OUT) {
	      token = google.accounts.user.login(scope);
           } 
	   fuckingGoogleToken = getCookie("g314-scope-0");
	   token = fuckingGoogleToken.substr(fuckingGoogleToken.search("token=")+6, 45);
	   document.cookie = "token="+escape(token);
	}

	function onGoogleDataLoad() {
	   logMeIn();
	}

	// Call function once the client has loaded
	google.setOnLoadCallback(onGoogleDataLoad);

    </script>
  </head>

  <body>
     <form name="ajax" method="POST" action="">
	<div style="float:right;">
	<INPUT name="btSave" type="BUTTON" value="Save!"  ONCLICK="saveList()" >
	</div>

        <h2>To-do List</h2>


	<textarea id="code" name="code"><%
	    String token = "";

	    Cookie[] cookies = request.getCookies();
	    for(int i = 0; i < cookies.length; i++) { 
	        Cookie c = cookies[i];
	        if (c.getName().equals("token")) {
		    token = c.getValue();
	        }
	    } 

	    token = token.replace("/","t");

            String file = "/var/bases/Todo/" + token + "_todo_list.txt";
            File fileObject = new File(file);

	    if (!fileObject.exists()) {
		 fileObject.createNewFile();

String data = 
"Hey! Welcome! \n\n" +
"This is your new to-do list. Just type items like the example below. \n" +
"They will be automatically, real-time highlighted and saved in our servers. \n" +
"Each gmail account can have only one to-do list. \n" +
"\n"+ 
"Best! \n"+ 
"\n"+ 
"* Project1\n"+ 
"\n"+ 
"! Print flyers ASAP \n"+ 
"- Start shipping devices for partners \n"+ 
"- Jul 1: Presentation \n"+ 
"- May 4: Final Report \n"+ 
"\n" +
"* Project2\n" +
"- Apr 26: Decide Title \n" +
"- Apr 25: Check for PDFs Images \n" +
"- Apr 25: Meet @Manuel's for Design \n" +
"- Apr 25: Meet @Erick's business plan \n";

		FileWriter filewriter = new FileWriter(file, false);
		filewriter.write(data);
		filewriter.close();
	    }

            char data[] = new char[(int) fileObject.length()];
            FileReader filereader = new FileReader(file);

            int charsread = filereader.read(data);
            out.println(new String(data, 0 , charsread));
            filereader.close();
        %></textarea>
	
    </form>


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
		req.setRequestHeader("token",escape(token));
		req.send("todo_list="+encodeURIComponent(editor.getValue())); 
	} 

	shortcut.add("Ctrl+S",function() {
		window.clearTimeout(saveTimeout);
		saveList();
	});
    </script>

    <center>Powered by <a href="https://github.com/vitorpamplona/FreeToDo">FreeToDo</a></center>

  </body>
</html>

