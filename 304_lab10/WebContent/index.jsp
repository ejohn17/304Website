<%@ include file = "jdbc.jsp" %>
<!DOCTYPE html>
<html>
<span style="font-family: comic sans ms">
<head>
<p align = "right"><% 
// TODO: Display user name that is logged in (or nothing if not logged in)

String user = (String)session.getAttribute("authenticatedUser");
if(user != null)
	out.println("signed in as: "+user);


%></p>
        <title>iStickers</title>
        
</head>
<body bgcolor=F88D35>
<h1 align="center">iStickers</h1>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp?productName=&category=%25">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="createaccount.jsp">Create Account</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>

</body>
</head>


