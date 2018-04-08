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
	String username = request.getParameter("uname");
	String password = request.getParameter("psw");
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection connection = DriverManager.getConnection("jdbc:mysql://cs336.cv4x80hazco8.us-east-2.rds.amazonaws.com:3306/lintakuties?" + "user=lintakuties&password=cs336");
	PreparedStatement ps = connection.prepareStatement("SELECT username, password, handle FROM User WHERE username = ? AND password = ?");
	ps.setString(1, username);
	ps.setString(2, password);
	ResultSet rs = ps.executeQuery();
	if (rs.next()) {
		String handle = rs.getString("handle");
		PreparedStatement ps2 = connection.prepareStatement("SELECT username FROM Account WHERE username = ?");
		ps2.setString(1, handle);
		ResultSet rs2 = ps2.executeQuery();
		if (rs2.next()) {
			session.setAttribute("influencer?", "no");
			session.setAttribute("handle", handle);
			response.sendRedirect("profile.jsp");
		} else {
			TwitterScraper scraper = new TwitterScraper(handle);
			if (scraper.scrape() == 1) {
				request.setAttribute("error","Cannot access " + handle + "'s timeline");
				RequestDispatcher rd=request.getRequestDispatcher("/signup.jsp");            
				rd.include(request, response);
			} else {
				session.setAttribute("influencer?", "no");
				session.setAttribute("handle", handle);
				response.sendRedirect("profile.jsp");
			}
		}
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