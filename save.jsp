<%@ page import="java.io.*"%>
<%@ page import="java.net.URLDecoder"%> 
<%
String list = request.getParameter("todo_list");
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

FileWriter filewriter = new FileWriter(file, false);
filewriter.write(list);
//filewriter.write(filewriter.getEncoding());
filewriter.close();
%>
