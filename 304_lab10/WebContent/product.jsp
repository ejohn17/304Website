<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<p align = "right"><% 
// TODO: Display user name that is logged in (or nothing if not logged in)
String user = (String)session.getAttribute("authenticatedUser");
if(user != null)
	out.println("signed in as: "+user);
%></p>
<head>
<title>iStickers - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<span style="font-family: comic sans ms">
<body bgcolor=F88D35>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
// TODO: Retrieve and display info for the product
String productId = request.getParameter("id");
session.setAttribute("productId",productId);
		
String sql = "SELECT * FROM product WHERE productId = ?";

NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		
try
{
	getConnection();
	PreparedStatement prodInfo = con.prepareStatement(sql);
	prodInfo.setString(1,productId);
	ResultSet rst = prodInfo.executeQuery();
	while(rst.next()){
		%>
		<h3><%out.println(rst.getString("productName"));%></h3>
		<%
		//String image = rst.getString("productImageURL");
		//if(image != null)
		//	out.println("<img src=\""+rst.getString("productImageURL")+"\">");
		if(rst.getString("productImage") != null){
			out.println("<img src=\"displayImage.jsp?id="+productId+"\">");
		}
		%>
		<br>
		<b>Id:</b> <%out.println(productId);%>
		<br>
		<b>Price:</b> <%out.println(currFormat.format(rst.getDouble("productPrice")));%>
		<br>
		<h4><a href="addcart.jsp?id=<%out.println(productId);%>&name=<%out.println(rst.getString("productName"));%>&price=<%out.println(rst.getDouble("productPrice"));%>">Add To Cart</a></h4>
		<h4><a href="listprod.jsp?productName=&category=%25">Continue Shopping</a></h4>
		<form method="get" action="review.jsp">
		<p>
			<label>Leave a Review</label> 
			<select name = "rating">
				<option value = "1">1 Star</option>
				<option value = "2">2 Stars</option>
				<option value = "3">3 Stars</option>
				<option value = "4">4 Stars</option>
				<option value = "5">5 Stars</option> 
			</select> <br>     
			<textarea name = "review" rows = "4" cols = "80" placeholder="Tell us how you liked the product!"></textarea>
		</p>
		<input type="submit" value="Submit">
		</form>
		<%
	}
	PreparedStatement reviews = con.prepareStatement("SELECT reviewRating,reviewComment,reviewDate FROM review WHERE productId = ?");
	reviews.setString(1,productId);
	ResultSet reviewSet = reviews.executeQuery();
	while(reviewSet.next()){
		%>
		<p>
			<h4>Rated <%out.println(reviewSet.getString(1));%> Star(s) on <%out.println(reviewSet.getString(3));%></h4>
			<h5><%out.println(reviewSet.getString(2));%></h5><br>
		</p>
		<%
	}
}
finally{
	closeConnection();
}
// TODO: If there is a productImageURL, display using IMG tag
	// nice
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
	// nice
// TODO: Add links to Add to Cart and Continue Shopping
	// nice
%>

</body>
</span>
</html>

