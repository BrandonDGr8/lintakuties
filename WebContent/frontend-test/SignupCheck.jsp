<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<%@ page import ="java.sql.*, scraper.TwitterScraper" %>

<%
try {
	String fullname = request.getParameter("fullname");
	String username = request.getParameter("uname");
	String password = request.getParameter("psw");
	String handle = request.getParameter("twit-hand");
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection connection = DriverManager.getConnection("jdbc:mysql://cs336.cv4x80hazco8.us-east-2.rds.amazonaws.com:3306/lintakuties?" + "user=lintakuties&password=cs336");
	PreparedStatement ps = connection.prepareStatement("INSERT INTO User VALUES (?, ?, ?, ?)");
	ps.setString(1, username);
	ps.setString(2, password);
	ps.setString(3, handle);
	ps.setString(4, fullname);
	try {
		ps.executeUpdate();
		session.setAttribute("username", username);
		new TwitterScraper(handle);
		response.sendRedirect("success.html");
	} catch (Exception e) {
		e.printStackTrace();
		request.setAttribute("error","Username already taken");
		RequestDispatcher rd=request.getRequestDispatcher("/signup.jsp");            
		rd.include(request, response);
	}
		
} catch (Exception e) {
	e.printStackTrace();
}
%>

</body>
</html>