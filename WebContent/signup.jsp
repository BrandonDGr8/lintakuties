<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>Linta(kuties)</title>
		<link rel="shortcut icon" type="image/x-icon" href="favicon.ico">
		<link rel="stylesheet" href="css/styles.css">
		<link href="https://fonts.googleapis.com/css?family=Lato|Coiny" rel="stylesheet"> 
		<link rel="stylesheet" href="font-awesome-4.7.0/css/font-awesome.min.css">
</head>
<body>
	<div class="page-container">
			<div id="page-bg"></div>
			<div class="content-container-no-vert">
				<div class="inner-container-no-vert">
					<h1 class="title">Linta(kuties)</h1>
					<br>
					<%
					String error = (String)request.getAttribute("error");  
					if (error != null)
						out.println("<p style=\"color:white; text-align:center; font-family:'Lato', sans-serif; size:4px\">"+error+"</p>");
					%>
					 <form class="signup-form" action="SignupCheck.jsp">
						<div class="container">
							<label for="fullname"><b>Full Name</b></label>
							<br>
							<input type="text" placeholder="Enter full name" name="fullname" required>
							<br>
							<label for="uname"><b>Username</b></label>
							<br>
							<input type="text" placeholder="Enter Username" name="uname" required>
							<br>
							<label for="psw"><b>Password</b></label>
							<br>
							<input type="password" placeholder="Enter Password" name="psw" required>
							<br>
							<label for="twit-hand"><b>Twitter Handle</b></label>
							<br>
							<input type="text" placeholder="Enter Twitter Handle" name="twit-hand">
							<br>
							<button type="submit">Submit</button>
							<br>
							<p style="font-size:12px">Please wait after hitting submit.<br>
							Loading Twitter data takes a few seconds.</p>
						</div>

						<div class="container">
							<a href="index.jsp"><button type="button" class="loginbtn">Already a user? Login</button></a>
							<br>
						</div>
					</form> 
				</div>
					
			</div>
				
		</div>
	</body>
</html>