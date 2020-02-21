<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<span style="font-family: comic sans ms">
<head>
<title>iSticker Products</title>
</head>
<body bgcolor=F88D35>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products) <br>
Category:
<select name="category">
	<% 
	try{
		getConnection();
		Statement cats = con.createStatement();
		ResultSet categ = cats.executeQuery("SELECT DISTINCT category.categoryId, category.categoryName FROM product, category WHERE product.categoryId = category.categoryId");
		%>
		<option value="%">Any Category</option>
		<%
		while(categ.next()){
			out.println("<option value=\""+categ.getString("categoryId")+"\">"+categ.getString("categoryName")+"</option>");
		}
	} finally{
		closeConnection();
	}
	%>
</select>
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
String category = request.getParameter("category");	
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!
// Make the connection
String iud = "ejohnsto";
String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_"+iud+";";
String pw = "76035344";
String SQL = "SELECT * FROM product WHERE productName LIKE '%"+name+"%'AND categoryId LIKE '%"+category+"%'"; // not letting me use ?
		
try(Connection con = DriverManager.getConnection(url, iud, pw); PreparedStatement pstmt = con.prepareStatement(SQL);)
{
	//pstmt.setString(1, name);
	ResultSet rst = pstmt.executeQuery();
	%>
	<table>
		<thead>
			<tr>
				<th></th>
				<th>Product Name</th>
				<th>Price</th>
			</tr>
		<tbody>
	<% 
	while(rst.next()){
		String pid = rst.getString("productId");
		String pname = rst.getString("productName");
		double price = rst.getDouble("productPrice");
		
		out.println("<tr><td><a href=\"addcart.jsp?id="+pid+"&name="+pname+"&price="+price+"\">Add to Cart</a></td> <td> <a href=\"product.jsp?id="+pid+"\">"+pname+"</a></td> <td>"+currFormat.format(price)+"</td></tr>");
		
	}
	%>
	</tbody>
</table>
<% 
} 
// Print out the ResultSet
// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection
// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
out.println("<h2><a href=\"showcart.jsp\">Shopping Cart</a></h2>");
out.println("<h2><a href=\"index.jsp\">Home</a></h2>");
%>

</body>
</span>
</html>