<html>
<head>
<title>iSticker Checkout</title>
</head>
<span style="font-family: comic sans ms">
<body bgcolor=F88D35>

<h1>Enter your customer id and password to complete the transaction:</h1>

<form method="get" action="order.jsp">
<table>
<tr><td>Customer ID:</td><td><input type="text" name="customerId" size="20"></td></tr>
<tr><td>Password:</td><td><input type="password" name="password" size="20"></td></tr>
<tr><td><input type="submit" value="Submit"></td><td><input type="reset" value="Reset"></td></tr>
</table>
<%
	out.println("<h2><a href=\"index.jsp\">Home</a></h2>");

%>
</form>

</body>
</span>
</html>

