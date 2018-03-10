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
			<div class="content-container">
				<div class="inner-container">
					<h1 class="title">Linta(kuties)</h1>
					<br>	
					<%
					String error = (String)request.getAttribute("error");  
					if (error != null)
						out.println("<p style=\"color:white; text-align:center; font-family:'Lato', sans-serif; size:4px\">"+error+"</p>");
					%>
					 <form class="login-form" action="LoginCheck.jsp">
						<div class="container">
							<label for="uname"><b>Username</b></label>
							<br>
							<input type="text" placeholder="Enter Username" name="uname" required>
							<br>
							<label for="psw"><b>Password</b></label>
							<br>
							<input type="password" placeholder="Enter Password" name="psw" required>
							<br>
							<button type="submit">Login</button>
							<br>
							<label class= "remember">
								<input type="checkbox" checked="checked" name="remember"> Remember me
							</label>
						</div>

						<div class="container">
							<a href="signup.jsp"><button type="button" class="signupbtn">Sign Up</button></a>
							<br>
							<span class="psw">Forgot <a href="#">password?</a></span>
						</div>
					</form> 
				</div>
					
			</div>
				
		</div>
	</body>
</html>