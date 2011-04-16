CodeMirror.defineMode("todo", function() {
  return {
    token: function(stream) {
      if (stream.match(/^(jan|fev|mar|apr|may|jun|jul|ago|oct|nov|dec)+\s(\d)+/i)) {
	  return "todo-date"; 
      }	

      var ch = stream.next();

      // CATEGORY
      if (ch == "*") { 
	//stream.skipToEnd(); 
	while ((next = stream.peek()) != "@" && !stream.eol()) stream.next(); 
 	return "todo-category"; 
      }
      
      if (ch == "+") { 
	//stream.skipToEnd(); 
	while ((next = stream.peek()) != "@" && !stream.eol()) stream.next(); 
 	return "todo-plus"; 
      }


      if (ch == "!") { 
	//stream.skipToEnd(); 
	while ((next = stream.peek()) != "@" && !stream.eol()) stream.next(); 
	
	return "todo-urgent"; 
      }
      
      if (ch == "@") { 
	while ((next = stream.next()) != " " && !stream.eol()); 
	return "todo-people"; 
      }
    }
  };
});

CodeMirror.defineMIME("text/x-todo", "todo");
