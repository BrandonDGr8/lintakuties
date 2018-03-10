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
	String username = request.getParameter("uname");
	String password = request.getParameter("psw");
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection connection = DriverManager.getConnection("jdbc:mysql://cs336.cv4x80hazco8.us-east-2.rds.amazonaws.com:3306/login?" + "user=lintakuties&password=cs336");
	PreparedStatement ps = connection.prepareStatement("SELECT username, pass FROM Accounts WHERE username = ? AND pass = ?");
	ps.setString(1, username);
	ps.setString(2, password);
	ResultSet rs = ps.executeQuery();
	if (rs.next()) {
		session.setAttribute("username", username);
		response.sendRedirect("success.jsp");
	} else {
		request.setAttribute("error","Invalid Username or Password");
		RequestDispatcher rd=request.getRequestDispatcher("/login.jsp");            
		rd.include(request, response);
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>

</body>
</html>