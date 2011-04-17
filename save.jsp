<%@ page import="java.io.*"%>
<%@ page import="java.net.URLDecoder"%> 
<%
String list = request.getParameter("todo_list");
String token = request.getParameter("googleUserId");
String file = "/var/bases/Todo/" + token + "_todo_list.txt";

FileWriter filewriter = new FileWriter(file, false);
filewriter.write(list);
//filewriter.write(filewriter.getEncoding());
filewriter.close();
%>
