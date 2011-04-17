<%@ page import="java.io.*" %>

<!doctype html>
<html>
  <head>
    <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
  <meta name="description" content="Your to-do list, made easy." /> 
  <meta name="keywords" content="To-do list, task manager, todo, freetodo" /> 
  <meta name="author" content="Vitor Fernando Pamplona" /> 

<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("UA-1248613-2");
pageTracker._initData();
pageTracker._trackPageview();

function f_unload() {pageTracker._trackPageview("/endpage");}
window.onunload = f_unload;
</script>


    <title>To-do List</title>
    <link rel="stylesheet" href="lib/codemirror.css">
    <script src="lib/codemirror.js"></script>
    <script src="lib/shortcut.js"></script>
    <script src="todo.js"></script>
        
    <link rel="stylesheet" href="todo.css">

    <style>.CodeMirror {border-top: 1px solid #ddd; border-bottom: 1px solid #ddd; height: 100%; line-height:130%;}</style>
    <link rel="stylesheet" href="css/docs.css">

    <!-- Load the Google AJAX API Loader -->
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>

    <!-- Load the Google Friend Connect javascript library. -->
    <script type="text/javascript">
        google.load('friendconnect', '0.8');
    </script>

<!-- Initialize the Google Friend Connect OpenSocial API. -->
    <script type="text/javascript">
	var googleUserId = "";

        google.friendconnect.container.setParentUrl('/' /* location of rpc_relay.html and canvas.html */);
        google.friendconnect.container.initOpenSocialApi({
           site: '10159722463725264178',
           onload: function(securetoken) { init(); }
        });

	function init() {
	  // Create a request to grab the current viewer.
	  var req = opensocial.newDataRequest();
	  req.add(req.newFetchPersonRequest('VIEWER'), 'viewer');
	  // Sent the request
	  req.send(onData);
	}

	function getCookie(c_name) {
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

	function onData(data) {
	  // If the view_data had an error, then user is not signed in
	  if (data.get('viewer').hadError()) {
	    // Create the sign in link
	    var options = {
	      id: "loggeduser"
	    };
	    google.friendconnect.renderSignInButton(options);
	  } else {
	    // If the view_data is not empty, we can display the current user
	    // Create html to display the user's name, and a sign-out link.
	    viewer = data.get('viewer').getData();
	    var html = 
	        //'<img align="left" src="' + viewer.getField("thumbnailUrl")  + '">' +
	        '<div style="font-size:20%;">&nbsp</div>' +  viewer.getField("displayName") + ',  ' +
	        '<a href="#" onclick="google.friendconnect.requestSettings(); return false;">Settings</a>,  ' +
	        '<a href="#" onclick="google.friendconnect.requestInvite(\'Come and pick a color!\'); return false;">Invite</a>,  ' +
	        '<a href="#" onclick="googleUserId = \'\'; document.cookie = \'googleUserId=0\'; window.location.reload();  google.friendconnect.requestSignOut(); return false;">Sign out</a>';

	    document.getElementById("loggeduser").innerHTML = html;

	    googleUserId = viewer.getId();
	    if (googleUserId != getCookie("googleUserId")) {
		    document.cookie = "googleUserId="+googleUserId;
		    window.location.reload();
	    }
	  }
	}
    </script>

  </head>

  <body>
     <form name="ajax" method="POST" action="">
        <div style="float:left;" ><h2>To-do List</h2></div>
        <div style="float:left; width:80%; margin: auto; text-align:center; align:center;"><center name="loggeduser" id="loggeduser"></center></div>
	<div style="float:right;"><div style="font-size:10%;">&nbsp</div>
	<INPUT name="btSave" type="BUTTON" value="Save!"  ONCLICK="saveList()" >
	</div>
	<div style="clear:both;"></div>

	<textarea id="code" name="code"><%
	    String googleUserId = "";

	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
		    for(int i = 0; i < cookies.length; i++) { 
			Cookie c = cookies[i];
			if (c.getName().equals("googleUserId")) {
			    googleUserId = c.getValue();
			}
		    } 
	    }

            String file = "/var/bases/Todo/" + googleUserId + "_todo_list.txt";
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
		req.send("googleUserId=" + googleUserId + "&todo_list="+encodeURIComponent(editor.getValue())); 
	} 

	shortcut.add("Ctrl+S",function() {
		window.clearTimeout(saveTimeout);
		saveList();
	});
    </script>

    <center>Powered by <a href="https://github.com/vitorpamplona/FreeToDo">FreeToDo</a></center>

  </body>
</html>

