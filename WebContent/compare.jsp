<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Linta(kuties)</title>
	<link rel="shortcut icon" type="image/x-icon" href="favicon.ico">
	<link rel="stylesheet" href="css/styles.css">
	<link href="https://fonts.googleapis.com/css?family=Lato|Coiny" rel="stylesheet"> 
	<link rel="stylesheet" href="font-awesome-4.7.0/css/font-awesome.min.css">
<title>Insert title here</title>
</head>
<body>
	<%@ page import = "java.sql.*" %>
	<div class="page-container">
		<div id="page-bg"></div>
		<div class="content-container-no-vert">
			<div class="inner-container-no-vert">
			
				<h1 class="title"><a href="index.jsp">Linta(kuties)</a></h1>
				<div class="inner-content-container">
				
					<h1>Comparisons</h1>
					
					<button href="profile.jsp" style=\"width:auto; float:right; margin-right:10px\">Back</button>
					
					<% 
					String handle = (String)session.getAttribute("handle"); 
					String influencer = request.getParameter("influencer-compare");
					
					Class.forName("com.mysql.jdbc.Driver");
					Connection connection = DriverManager.getConnection("jdbc:mysql://cs336.cv4x80hazco8.us-east-2.rds.amazonaws.com:3306/lintakuties?" + "user=lintakuties&password=cs336");
					
					PreparedStatement ps = connection.prepareStatement("SELECT name, num_followers, num_posts FROM Account WHERE username = ?");
					ps.setString(1, handle);
					ResultSet rs = ps.executeQuery();
					rs.next();
					String fullname = rs.getString("name");
					int num_followers = rs.getInt("num_followers");
					int num_posts = rs.getInt("num_posts");
					
					PreparedStatement ps2 = connection.prepareStatement("SELECT name, num_followers, num_posts FROM Account WHERE username = ?");
					ps2.setString(1, influencer);
					ResultSet rs2 = ps2.executeQuery();
					rs2.next();
					String fullname2 = rs2.getString("name");
					int num_followers2 = rs2.getInt("num_followers");
					int num_posts2 = rs2.getInt("num_posts");
					%>
					
					<h1><% out.print(fullname); %>'s Profile</h1>
					<h2>Username: <% out.println(handle); %></h2>
					<h2>Social Media Platform: Twitter</h2>
					<h2>Analytics:</h2>
					<h3>Number of Followers: <% out.println(num_followers); %></h3>
					<h3>Number of Posts: <% out.println(num_posts); %></h3>
					
					<h1><% out.print(fullname2); %>'s Profile</h1>
					<h2>Username: <% out.println(influencer); %></h2>
					<h2>Social Media Platform: Twitter</h2>
					<h2>Analytics:</h2>
					<h3>Number of Followers: <% out.println(num_followers2); %></h3>
					<h3>Number of Posts: <% out.println(num_posts2); %></h3>
					
				</div>
			</div>			
		</div>			
	</div>
</body>
</html>