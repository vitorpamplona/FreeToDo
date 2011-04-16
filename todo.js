CodeMirror.defineMode("todo", function() {
  return {
    token: function(stream) {
      var ch = stream.next();
      
      if (ch == "+") { 
	//stream.skipToEnd(); 
	while ((next = stream.peek()) != "@" && !stream.eol()) stream.next(); 
 	return "todo-plus"; 
      }
      if (ch == "!") { 
	//stream.skipToEnd(); 
	while ((next = stream.peek()) != "@" && !stream.eol()) stream.next(); 
	
	return "todo-minus"; 
      }
      
      if (ch == "@") { 
	while ((next = stream.next()) != " " && !stream.eol()); 
	return "todo-people"; 
      }
    }
  };
});

CodeMirror.defineMIME("text/x-todo", "todo");
