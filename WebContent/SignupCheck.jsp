<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<%@ page import ="java.sql.*" %>

<%
try {
	String fullname = request.getParameter("fullname");
	String username = request.getParameter("uname");
	String password = request.getParameter("psw");
	String twitHandle = request.getParameter("twit-hand");
	String instaHandle = request.getParameter("insta-hand");
	String fbId = request.getParameter("Facebook ID");
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection connection = DriverManager.getConnection("jdbc:mysql://cs336.cv4x80hazco8.us-east-2.rds.amazonaws.com:3306/login?" + "user=lintakuties&password=cs336");
	PreparedStatement ps = connection.prepareStatement("INSERT INTO Accounts VALUES (?, ?, ?, ?, ?, ?)");
	ps.setString(1, fullname);
	ps.setString(2, username);
	ps.setString(3, password);
	ps.setString(4, twitHandle);
	ps.setString(5, instaHandle);
	ps.setString(6, fbId);
	int i = ps.executeUpdate();
	if (i > 0) {
		session.setAttribute("username", username);
		response.sendRedirect("success.jsp");
	} else {
		response.sendRedirect("error.html");
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>

</body>
</html>