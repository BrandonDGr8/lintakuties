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
</head>
<body>
	<%@ page import = "java.sql.*" %>
	<div class="page-container">
		<div id="page-bg"></div>
		<div class="content-container-no-vert">
			<div class="inner-container-no-vert">
			
			<form action="BackHome.jsp">
				<button type="submit" style="width:auto; float:right; margin-right:10px">Back to Home</button>
			</form>
			
				<h1 class="title"><a href="index.jsp">Linta(kuties)</a></h1>
				<div class="inner-content-container">
				
					<h1>Influencer Twitter Patterns</h1>

					<%
					Class.forName("com.mysql.jdbc.Driver");
					Connection connection = DriverManager.getConnection("jdbc:mysql://cs336.cv4x80hazco8.us-east-2.rds.amazonaws.com:3306/lintakuties?" + "user=lintakuties&password=cs336");
					
					PreparedStatement timeOfDay = connection.prepareStatement("SELECT DISTINCT AVG(favorites + retweets), timeOfDay FROM Account_Posts_Post, Account, Post WHERE Account_Posts_Post.username = Account.username AND Post.postID = Account_Posts_Post.postID AND favorites <> 0 AND influencer = 'yes' GROUP BY timeOfDay ORDER BY AVG(favorites + retweets) DESC");
					ResultSet timeOfDayRS = timeOfDay.executeQuery();
					int timeColCount = timeOfDayRS.getMetaData().getColumnCount();
					String time = "";
					if (timeOfDayRS.next()) {
						time = timeOfDayRS.getString(2).toLowerCase();
					}
					timeOfDayRS.beforeFirst();
					%>
					<h6>Tweets posted in the <%= time %> get the most average likes.</h6>
					
					<table style="margin-left:auto; margin-right:auto;">
					<tr>
						<th style="font-size:15px; padding:5px">Time of Day</th>
						<th style="font-size:15px; padding:5px">Average Interactions</th>
					</tr>
					<% while (timeOfDayRS.next()) {
						%>
			                <tr>
			                     <td style="font-size:15px; padding:5px">
			                     <%= timeOfDayRS.getString(2)%>
			                     </td>  
			                     <td style="font-size:15px; padding:5px">
			                     <%= timeOfDayRS.getInt(1)%>
			                     </td>                
			                </tr>
			            	<% 
			        	 }
			   			 %>
					</table>
					
					<h6>The average interactions per post increase as a post gets older.</h6>
					
					<p style="font-size:12px">Influencer posts were entered into the database on 2018-04-08.</p>
					<table style="margin-left:auto; margin-right:auto;">
					<tr>
						<th style="font-size:15px; padding:5px">Posted Before</th>
						<th style="font-size:15px; padding:5px">Average Interactions</th>
					</tr>
					
					<%
					PreparedStatement olderPost = connection.prepareStatement("SELECT AVG(retweets + favorites) FROM Post, Account_Posts_Post, Account WHERE Account.username = Account_Posts_Post.username AND Account_Posts_Post.postID = Post.postID AND date < ? AND favorites <> 0 AND influencer = \'yes\'");
					String[] dates = {"2018-04-07", "2018-04-06", "2018-04-05", "2018-04-04", "2018-04-03", "2018-04-02", "2018-04-01"};
					for (String date : dates) {
						olderPost.setString(1, date);
						ResultSet olderRS = olderPost.executeQuery();
						if (olderRS.next()) {
						%>
			                <tr>
			                     <td style="font-size:15px; padding:5px">
			                     <%= date %>
			                     </td>  
			                     <td style="font-size:15px; padding:5px">
			                     <%= olderRS.getInt(1)%>
			                     </td>                
			                </tr>
			            	<% 
			        	 }
			   			 %>
						
					<%}
					%>
					</table>
				</div>
			</div>			
		</div>			
	</div>
</body>
</html>