<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
String number = request.getParameter("number_parts");
String type = request.getParameter("top_parts");

session.setAttribute("parts_number", number);
session.setAttribute("top_parts", type);
response.sendRedirect("profile.jsp");
%>

</body>
</html>