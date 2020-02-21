<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<html style="font-family: comic sans ms">
<head>
<title>iStickers</title>
</head>
<body bgcolor=F88D35>
<%
String review = request.getParameter("review");
String rating = request.getParameter("rating");
String productId = (String) session.getAttribute("productId");
String customer = (String) session.getAttribute("authenticatedUser");

LocalDateTime now = LocalDateTime.now();
DateTimeFormatter formatted_now = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
String str_now = now.format(formatted_now);

try{
	getConnection();
	
	PreparedStatement gumball = con.prepareStatement("SELECT customerId FROM customer WHERE userid = ?");
	gumball.setString(1,customer);
	ResultSet custId = gumball.executeQuery();
	custId.next();
	String verifiedId = custId.getString(1);
	
	PreparedStatement check = con.prepareStatement("SELECT * FROM review WHERE customerId = ? AND productId = ?");
	check.setString(1,verifiedId);
	check.setString(2,productId);
	ResultSet checker = check.executeQuery();
	if(checker.next())
		out.println("<h2>You've already reviewed this product!</h2>");
	else{
		PreparedStatement doIt = con.prepareStatement("");
		if(review.equals("")){
			doIt = con.prepareStatement("INSERT INTO review (reviewRating, reviewDate, customerId, productId) VALUES (?,?,?,?)");
			doIt.setString(1,rating);
			doIt.setString(2,str_now);
			doIt.setString(3,verifiedId);
			doIt.setString(4,productId);
		}
		else{
			doIt = con.prepareStatement("INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) values (?,?,?,?,?)");
			doIt.setString(1,rating);
			doIt.setString(2,str_now);
			doIt.setString(3,verifiedId);
			doIt.setString(4,productId);
			doIt.setString(5,review);
		}
		doIt.execute();
		out.println("<h2>The Review Was Submitted!</h2><br>");
	}
} finally{
	closeConnection();
}

%>
<h3><a href="product.jsp?id=<%out.println(productId);%>">Back to Product</a></h3>
<h3><a href="listprod.jsp?productName=&category=%25">Back to Shop</a></h3>
</body>
</html>

