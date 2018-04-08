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
			
				<%
				String in = (String)session.getAttribute("influencer?");
				if (in != null) {
					out.println("<form action=\"Deletion.jsp\">");
					out.println("<button type=\"submit\" style=\"width:auto; float:right; margin-right:10px\">Logout</button>");
					out.println("</form>");
				} else {
					out.println("<form action=\"BackHome.jsp\">");
					out.println("<button type=\"submit\" style=\"width:auto; float:right; margin-right:10px\">Back to Home</button>");
					out.println("</form>");
				}
				%>
			
				<h1 class="title"><a href="index.jsp">Linta(kuties)</a></h1>
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
				
				int partsNumber;
				if (session.getAttribute("parts_number") == null) {
					partsNumber = 10;
				} else {
					partsNumber = Integer.parseInt((String)session.getAttribute("parts_number"));
				}
				String topParts;
				if (session.getAttribute("top_parts") == null) {
					topParts = "Keywords";
				} else {
					topParts = (String)session.getAttribute("top_parts");
				}
				
				int makesPopularNumber;
				if (session.getAttribute("makes_popular_number") == null) {
					makesPopularNumber = 10;
				} else {
					makesPopularNumber = Integer.parseInt((String)session.getAttribute("makes_popular_number"));
				}
				String makesPopular;
				if (session.getAttribute("makes_popular") == null) {
					makesPopular = "Keywords";
				} else {
					makesPopular = (String)session.getAttribute("makes_popular");
				}
				
				String affects;
				if (session.getAttribute("affects") == null) {
					affects = "Hashtags";
				} else {
					affects = (String)session.getAttribute("affects");
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
						<select name="type">
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
		   			 
		   			<h3><% out.println(partsNumber); %> Most Common <% out.println(topParts); %></h3>
		   			<form action="topParts.jsp">
						<label for="number_parts"><b>Number</b></label>
						<input type="text" placeholder="10" name="number_parts" required>
						<label for="top_parts"><b>Type</b></label>
						<select name="top_parts">
							<option value="Keywords">Keywords</option>
							<option value="Hashtags">Hashtags</option>
							<option value="Mentions">Mentions</option>
						</select>
						<button type="submit">Submit</button>
					</form>
					
					<table style="margin-left:auto; margin-right:auto;">
					<%
					PreparedStatement parts;
					if (topParts.equals("Keywords")) {
						parts = connection.prepareStatement("SELECT keyword, COUNT(*) FROM Keyword, Account_Posts_Post WHERE Account_Posts_Post.postID = Keyword.postID AND username = ? GROUP BY keyword ORDER BY COUNT(*) DESC LIMIT ?");
					} else if (topParts.equals("Hashtags")) {
						parts = connection.prepareStatement("SELECT hashtag, COUNT(*) FROM Hashtag, Account_Posts_Post WHERE Account_Posts_Post.postID = Hashtag.postID AND username = ? GROUP BY hashtag ORDER BY COUNT(*) DESC LIMIT ?");
					} else {
						parts = connection.prepareStatement("SELECT mention, COUNT(*) FROM Mention, Account_Posts_Post WHERE Account_Posts_Post.postID = Mention.postID AND username = ? GROUP BY mention ORDER BY COUNT(*) DESC LIMIT ?");
					}
					parts.setString(1, handle);
					parts.setInt(2, partsNumber);
					ResultSet partsRS = parts.executeQuery();
					int partsColCount = partsRS.getMetaData().getColumnCount();
					while (partsRS.next()) {
					%>
		                <tr>
		                 <%
		                 for(int i = 1; i <= partsColCount; i++)
		                    { %>
		                     <td style="font-size:15px; padding:5px">
		                     <%= partsRS.getString(i)%>
		                     </td>
		                <% 
		                    }
		                %>                   
		                </tr>
		            	<% 
		        	 }
		   			 %>
					</table>
					
					<h3>Likes over Time:</h3>
					<h3>Shares over Time:</h3>
					<h3>Time of posts vs Interactions:</h3>
					<h3>Day of posts vs Interactions:</h3>	
					
					<h2>What Makes A Post Popular?</h2>
					<h3><% out.print(makesPopular); %> Common to <% out.print(makesPopularNumber); %> Most Popular Posts</h3>
					<form action="makesPopular.jsp">
						<label for="makesPopularNumber"><b>Number</b></label>
						<input type="text" placeholder="10" name="makesPopularNumber" required>
						<label for="makesPopular"><b>Type</b></label>
						<select name="makesPopular">
							<option value="Keywords">Keywords</option>
							<option value="Hashtags">Hashtags</option>
							<option value="Mentions">Mentions</option>
						</select>
						<button type="submit">Submit</button>
					</form>
					
					<table style="margin-left:auto; margin-right:auto;">
					<%
					PreparedStatement makes;
					if (makesPopular.equals("Keywords")) {
						makes = connection.prepareStatement("SELECT keyword, COUNT(*) FROM Keyword INNER JOIN (SELECT Post.postID FROM Post, Account_Posts_Post WHERE Account_Posts_Post.postID = Post.postID AND Account_Posts_Post.username = ? ORDER BY favorites + retweets DESC LIMIT ?) AS keyw ON Keyword.postID = keyw.postID GROUP BY keyword HAVING COUNT(*) > 1 ORDER BY COUNT(*) DESC");
					} else if (makesPopular.equals("Hashtags")) {
						makes = connection.prepareStatement("SELECT hashtag, COUNT(*) FROM Hashtag INNER JOIN (SELECT Post.postID FROM Post, Account_Posts_Post WHERE Account_Posts_Post.postID = Post.postID AND Account_Posts_Post.username = ? ORDER BY favorites + retweets DESC LIMIT ?) AS hash ON Hashtag.postID = hash.postID GROUP BY hashtag HAVING COUNT(*) > 1 ORDER BY COUNT(*) DESC");
					} else {
						makes = connection.prepareStatement("SELECT mention, COUNT(*) FROM Mention INNER JOIN (SELECT Post.postID FROM Post, Account_Posts_Post WHERE Account_Posts_Post.postID = Post.postID AND Account_Posts_Post.username = ? ORDER BY favorites + retweets DESC LIMIT ?) AS men ON Mention.postID = men.postID GROUP BY mention HAVING COUNT(*) > 1 ORDER BY COUNT(*) DESC");
					}
					makes.setString(1, handle);
					makes.setInt(2, partsNumber);
					ResultSet makesRS = makes.executeQuery();
					int makesColCount = makesRS.getMetaData().getColumnCount();
					while (makesRS.next()) {
					%>
		                <tr>
		                 <%
		                 for(int i = 1; i <= makesColCount; i++)
		                    { %>
		                     <td style="font-size:15px; padding:5px">
		                     <%= makesRS.getString(i)%>
		                     </td>
		                <% 
		                    }
		                %>                   
		                </tr>
		            	<% 
		        	 }
		   			 %>
					</table>
					
					<h3>How <% out.print(affects); %> Affect Interactions</h3>
					<form action="affects.jsp">
						<label for="affects"><b>Type</b></label>
						<select name="affects">
							<option value="Hashtags">Hashtags</option>
							<option value="Mentions">Mentions</option>
							<option value="Media">Media</option>
							<option value="Links">Links</option>
						</select>
						<button type="submit">Submit</button>
					</form>
					
					<table style="margin-left:auto; margin-right:auto;">
					<%
					PreparedStatement affectWith;
					PreparedStatement affectWithout;
					if (affects.equals("Hashtags")) {
						affectWith = connection.prepareStatement("SELECT AVG(favorites + retweets) FROM Post WHERE favorites <> 0 AND postID IN (SELECT Hashtag.postID FROM Account_Posts_Post, Hashtag WHERE Account_Posts_Post.postID = Hashtag.postID AND username = ?)");
						affectWithout = connection.prepareStatement("SELECT AVG(favorites + retweets) FROM Post WHERE favorites <> 0 AND postID NOT IN (SELECT Hashtag.postID FROM Account_Posts_Post, Hashtag WHERE Account_Posts_Post.postID = Hashtag.postID AND username = ?)");
					} else if (affects.equals("Mentions")) {
						affectWith = connection.prepareStatement("SELECT AVG(favorites + retweets) FROM Post WHERE favorites <> 0 AND postID IN (SELECT Mention.postID FROM Account_Posts_Post, Mention WHERE Account_Posts_Post.postID = Mention.postID AND username = ?)");
						affectWithout = connection.prepareStatement("SELECT AVG(favorites + retweets) FROM Post WHERE favorites <> 0 AND postID NOT IN (SELECT Mention.postID FROM Account_Posts_Post, Mention WHERE Account_Posts_Post.postID = Mention.postID AND username = ?)");
					} else if (affects.equals("Media")) { 
						affectWith = connection.prepareStatement("SELECT AVG(favorites + retweets) FROM Post WHERE favorites <> 0 AND postID IN (SELECT Media.postID FROM Account_Posts_Post, Media WHERE Account_Posts_Post.postID = Media.postID AND username = ?)");
						affectWithout = connection.prepareStatement("SELECT AVG(favorites + retweets) FROM Post WHERE favorites <> 0 AND postID NOT IN (SELECT Media.postID FROM Account_Posts_Post, Media WHERE Account_Posts_Post.postID = Media.postID AND username = ?)");
					} else {
						affectWith = connection.prepareStatement("SELECT AVG(favorites + retweets) FROM Post WHERE favorites <> 0 AND postID IN (SELECT Link.postID FROM Account_Posts_Post, Link WHERE Account_Posts_Post.postID = Link.postID AND username = ?)");
						affectWithout = connection.prepareStatement("SELECT AVG(favorites + retweets) FROM Post WHERE favorites <> 0 AND postID NOT IN (SELECT Link.postID FROM Account_Posts_Post, Link WHERE Account_Posts_Post.postID = Link.postID AND username = ?)");
					}
					affectWith.setString(1, handle);
					affectWithout.setString(1, handle);
					ResultSet affectWithRS = affectWith.executeQuery();
					ResultSet affectWithoutRS = affectWithout.executeQuery();
					while (affectWithRS.next() && affectWithoutRS.next()) {
					%>
						<tr>
							<td></td>
							<td style="font-size:15px; padding:5px">With</td><td style="font-size:15px; padding:5px">Without</td>
						</tr>
		                <tr>
		                	 <td style="font-size:15px; padding:5px">Total Interactions</td>
		                     <td style="font-size:15px; padding:5px">
		                     <%= affectWithRS.getInt(1)%>
		                     </td> 
		                     <td style="font-size:15px; padding:5px">
		                     <%= affectWithoutRS.getInt(1)%>
		                     </td>               
		                </tr>
		            	<% 
		        	 }
		   			 %>
					</table>
					
					<h3>Compare to Influencer</h3>
					<form class="influencer-form" action="compare.jsp">
						<select name="influencer-compare">
							<option value="katyperry">Katy Perry</option>
							<option value="justinbieber">Justin Bieber</option>
							<option value="BarackObama">Barack Obama</option>
							<option value="rihanna">Rihanna</option>
							<option value="taylorswift13">Taylor Swift</option>
							<option value="ladygaga">Lady Gaga</option>
							<option value="TheEllenShow">Ellen DeGeneres</option>
							<option value="YouTube">YouTube</option>
							<option value="Cristiano">Cristiano Ronaldo</option>
							<option value="jtimberlake">Justin Timberlake</option>
							<option value="Twitter">Twitter</option>
							<option value="KimKardashian">Kim Kardashian</option>
							<option value="britneyspears">Britney Spears</option>
							<option value="ArianaGrande">Ariana Grande</option>
							<option value="selenagomez">Selena Gomez</option>
							<option value="ddlovato">Demi Lovato</option>
							<option value="cnnbrk">CNN</option>
							<option value="shakira">Shakira</option>
							<option value="jimmyfallon">Jimmy Fallon</option>
							<option value="realDonaldTrump">Donald Trump</option>
						</select>
						<button type="submit">Compare</button>
					</form>
					
				</div>
			</div>			
		</div>			
	</div>
</body>
</html>