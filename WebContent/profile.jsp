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
				<h1 class="title"><a href="home.html">Linta(kuties)</a></h1>
				<div class="inner-content-container">
				
				<%
				String handle = (String)session.getAttribute("handle");
				int topNumber;
				if (session.getAttribute("top_number") == null) {
					topNumber = 10;
				} else {
					topNumber = Integer.parseInt((String)session.getAttribute("top_number"));
				}
				String type;
				if (session.getAttribute("top_type") == null) {
					type = "Favorites";
				} else {
					type = (String)session.getAttribute("top_type");
				}
				
				Class.forName("com.mysql.jdbc.Driver");
				Connection connection = DriverManager.getConnection("jdbc:mysql://cs336.cv4x80hazco8.us-east-2.rds.amazonaws.com:3306/lintakuties?" + "user=lintakuties&password=cs336");
				
				PreparedStatement ps = connection.prepareStatement("SELECT name, num_followers, num_posts FROM Account WHERE username = ?");
				ps.setString(1, handle);
				ResultSet rs = ps.executeQuery();
				rs.next();
				String fullname = rs.getString("name");
				int num_followers = rs.getInt("num_followers");
				int num_posts = rs.getInt("num_posts");
				
				PreparedStatement ps2 = connection.prepareStatement("SELECT AVG(Post.retweets) AS retweets FROM Post, Account_Posts_Post WHERE Account_Posts_Post.postID = Post.postID AND Account_Posts_Post.username = ?");
				ps2.setString(1, handle);
				ResultSet rs2 = ps2.executeQuery();
				rs2.next();
				int retweets = rs2.getInt("retweets");
				
				PreparedStatement ps3 = connection.prepareStatement("SELECT AVG(Post.favorites) AS favorites FROM Post, Account_Posts_Post WHERE Account_Posts_Post.postID = Post.postID AND Account_Posts_Post.username = ? AND Post.favorites <> 0");
				ps3.setString(1, handle);
				ResultSet rs3 = ps3.executeQuery();
				rs3.next();
				int favorites = rs3.getInt("favorites");
				%>
				
					<h1><% out.print(fullname); %>'s Profile</h1>
					<h2>Username: <% out.println(handle); %></h2>
					<h2>Social Media Platform: Twitter</h2>
					<h2>Analytics:</h2>
					<h3>Number of Followers: <% out.println(num_followers); %></h3>
					<h3>Number of Posts: <% out.println(num_posts); %></h3>
					<h3>Average Likes Per Post: <% out.println(favorites); %></h3>
					<h3>Average Shares Per Post: <% out.println(retweets); %></h3>
					<h3>Top <% out.print(topNumber); %> Posts By <% out.print(type); %>:</h3>
					<form action="topByInteractions.jsp">
						<label for="number"><b>Number</b></label>
						<input type="text" placeholder="10" name="number" required>
						<label for="type"><b>Type</b></label>
						<select name=type>
							<option value="Favorites">Favorites</option>
							<option value="Retweets">Retweets</option>
							<option value="Total Interactions">Total Interactions</option>
						</select>
						<button type="submit">Submit</button>
					</form>
					<table style="border:1px white solid">
					<%
					PreparedStatement top;
					if (type.equals("Favorites")) {
						top = connection.prepareStatement("SELECT text, favorites FROM Post, Account_Posts_Post WHERE Account_Posts_Post.postID = Post.postID AND Account_Posts_Post.username = ? ORDER BY favorites DESC LIMIT ?");
					} else if (type.equals("Retweets")) {
						top = connection.prepareStatement("SELECT text, retweets FROM Post, Account_Posts_Post WHERE Account_Posts_Post.postID = Post.postID AND Account_Posts_Post.username = ? ORDER BY retweets DESC LIMIT ?");
					} else {
						top = connection.prepareStatement("SELECT text, favorites + retweets FROM Post, Account_Posts_Post WHERE Account_Posts_Post.postID = Post.postID AND Account_Posts_Post.username = ? ORDER BY favorites + retweets DESC LIMIT ?");
					}
					top.setString(1, handle);
					top.setInt(2, topNumber);
					ResultSet topRS = top.executeQuery();
					int colCount = topRS.getMetaData().getColumnCount();
					while (topRS.next()) {
					%>
		                <tr>
		                 <%
		                 for(int i = 1; i <= colCount; i++)
		                    { %>
		                     <td style="font-size:15px; padding:5px; border:1px white solid">
		                     <%= topRS.getString(i)%>
		                     </td>
		                <% 
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