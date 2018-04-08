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
			
				<form action="profile.jsp">
					<button style="width:auto; float:right; margin-right:10px">Back</button>
				</form>
			
				<h1 class="title"><a href="index.jsp">Linta(kuties)</a></h1>
				<div class="inner-content-container">
				
					<h1>Comparisons</h1>
					
					<% 
					String handle = (String)session.getAttribute("handle"); 
					String influencer;
					if (request.getParameter("influencer-compare") == null) {
						influencer = (String)session.getAttribute("influencer-compare");
					} else {
						session.setAttribute("influencer-compare", request.getParameter("influencer-compare"));
						influencer = (String)session.getAttribute("influencer-compare");
					}
					
					
					String commonCompare;
					if (session.getAttribute("common_compare") == null) {
						commonCompare = "Keywords";
					} else {
						commonCompare = (String)session.getAttribute("common_compare");
					}
					
					Class.forName("com.mysql.jdbc.Driver");
					Connection connection = DriverManager.getConnection("jdbc:mysql://cs336.cv4x80hazco8.us-east-2.rds.amazonaws.com:3306/lintakuties?" + "user=lintakuties&password=cs336");
					
					PreparedStatement ps = connection.prepareStatement("SELECT name, num_followers, num_posts FROM Account WHERE username = ?");
					ps.setString(1, handle);
					ResultSet rs = ps.executeQuery();
					String fullname = "";
					int num_followers = 0;
					int num_posts = 0;
					if (rs.next()) {
						fullname = rs.getString("name");
						num_followers = rs.getInt("num_followers");
						num_posts = rs.getInt("num_posts");
					}
					
					PreparedStatement ps2 = connection.prepareStatement("SELECT name, num_followers, num_posts FROM Account WHERE username = ?");
					ps2.setString(1, influencer);
					ResultSet rs2 = ps2.executeQuery();
					String fullname2 = "";
					int num_followers2 = 0;
					int num_posts2 = 0;
					if (rs2.next()) {
						fullname2 = rs2.getString("name");
						num_followers2 = rs2.getInt("num_followers");
						num_posts2 = rs2.getInt("num_posts");
					}
					%>
					
					<table style="font-size:15px; padding:5px; width:100%">
						<tr>
							<th>Name</th>
							<th>Username</th>
							<th>Followers</th>
							<th>Posts</th>
						</tr>
						<tr>
							<td><% out.print(fullname); %></td>
							<td><% out.println(handle); %></td>
							<td><% out.println(num_followers); %></td>
							<td><% out.println(num_posts); %></td>	
						</tr>
						<tr>
							<td><% out.print(fullname2); %></td>
							<td><% out.println(influencer); %></td>
							<td><% out.println(num_followers2); %></td>
							<td><% out.println(num_posts2); %></td>	
						</tr>
					</table>
					
					<%
					PreparedStatement avgFave = connection.prepareStatement("SELECT username, ratio FROM (SELECT AVG(favorites) / num_followers AS ratio, Account.username FROM Post, Account, Account_Posts_Post WHERE Account.username = Account_Posts_Post.username AND Account_Posts_Post.postID = Post.postID AND favorites <> 0 GROUP BY Account.username HAVING Account.username = ? OR Account.username = ?) AS maxlikes WHERE ratio = (SELECT MAX(ratio) FROM (SELECT AVG(favorites) / num_followers AS ratio, Account.username FROM Post, Account, Account_Posts_Post WHERE Account.username = Account_Posts_Post.username AND Account_Posts_Post.postID = Post.postID AND favorites <> 0 GROUP BY Account.username HAVING Account.username = ? OR Account.username = ?) AS maxlikes)");
					avgFave.setString(1, handle);
					avgFave.setString(2, influencer);
					avgFave.setString(3, handle);
					avgFave.setString(4, influencer);
					
					ResultSet avgFaveRS = avgFave.executeQuery();
					String avgFaveUser = "";
					double avgFaveRatio = 0;
					if (avgFaveRS.next()) {
						avgFaveUser = avgFaveRS.getString("username");
						avgFaveRatio = avgFaveRS.getDouble("ratio");
					}
					
					PreparedStatement avgRe = connection.prepareStatement("SELECT username, ratio FROM (SELECT AVG(retweets) / num_followers AS ratio, Account.username FROM Post, Account, Account_Posts_Post WHERE Account.username = Account_Posts_Post.username AND Account_Posts_Post.postID = Post.postID GROUP BY Account.username HAVING Account.username = ? OR Account.username = ?) AS maxfaves WHERE ratio = (SELECT MAX(ratio) FROM (SELECT AVG(retweets) / num_followers AS ratio, Account.username FROM Post, Account, Account_Posts_Post WHERE Account.username = Account_Posts_Post.username AND Account_Posts_Post.postID = Post.postID GROUP BY Account.username HAVING Account.username = ? OR Account.username = ?) AS maxfaves)");
					avgRe.setString(1, handle);
					avgRe.setString(2, influencer);
					avgRe.setString(3, handle);
					avgRe.setString(4, influencer);
					
					ResultSet avgReRS = avgRe.executeQuery();
					String avgReUser = "";
					double avgReRatio = 0;
					if (avgReRS.next()) {
						avgReUser = avgReRS.getString("username");
						avgReRatio = avgReRS.getDouble("ratio");
					}
					%>
					
					<table style="font-size:15px; padding:5px; width:100%">
						<tr>
							<th>Most Average Favorites Per Followers: </th>
							<td><% out.println(avgFaveUser); %>,</td>
							<td><% out.println(avgFaveRatio); %></td>
						</tr>
						<tr>
							<th>Most Average Retweets Per Followers:</th>
							<td><% out.println(avgReUser); %>,</td>
							<td><% out.println(avgReRatio); %></td>
						</tr>
					</table>
					
					<h4>Common <% out.print(commonCompare); %></h4>
					<form action="commonCompare.jsp">
						<label for="commonCompare"><b>Type</b></label>
						<select name="commonCompare">
							<option value="Keywords">Keywords</option>
							<option value="Hashtags">Hashtags</option>
							<option value="Mentions">Mentions</option>
						</select>
						<button type="submit">Submit</button>
					</form>
					
					<table style="margin-left:auto; margin-right:auto;">
					<%
					PreparedStatement common;
					if (commonCompare.equals("Keywords")) {
						common = connection.prepareStatement("SELECT DISTINCT keyword FROM Keyword, Account_Posts_Post WHERE Keyword.postID = Account_Posts_Post.postID AND Account_Posts_Post.username = ? AND keyword IN (SELECT keyword FROM Keyword, Account_Posts_Post WHERE Keyword.postID = Account_Posts_Post.postID AND Account_Posts_Post.username = ?)");
					} else if (commonCompare.equals("Hashtags")) {
						common = connection.prepareStatement("SELECT DISTINCT hashtag FROM Hashtag, Account_Posts_Post WHERE Hashtag.postID = Account_Posts_Post.postID AND Account_Posts_Post.username = ? AND hashtag IN (SELECT hashtag FROM Hashtag, Account_Posts_Post WHERE Hashtag.postID = Account_Posts_Post.postID AND Account_Posts_Post.username = ?)");
					} else {
						common = connection.prepareStatement("SELECT DISTINCT mention FROM Mention, Account_Posts_Post WHERE Mention.postID = Account_Posts_Post.postID AND Account_Posts_Post.username = ? AND mention IN (SELECT mention FROM Mention, Account_Posts_Post WHERE Mention.postID = Account_Posts_Post.postID AND Account_Posts_Post.username = ?)");
					}
					common.setString(1, handle);
					common.setString(2, influencer);
					ResultSet commonRS = common.executeQuery();
					int count = 0;
					if (!commonRS.next()) {
						out.println("<p>No common " + commonCompare.toLowerCase() + "</p>");
					} else {
						commonRS.beforeFirst();
					}
					while (commonRS.next()) { %>
						
						<tr>
							<% for (int i = 0; i < 5; i++) {
								if (commonRS.next()) {	%>
									<td style="font-size:15px; padding:5px">
		                    		 <%= commonRS.getString(1) %>
		                    	</td>
								<% }
							}
							 %>
						</tr>
					<% 
					}
					%>
					</table>
					
				</div>
			</div>			
		</div>			
	</div>
</body>
</html>