<!DOCTYPE html>
<html>
<span style="font-family: comic sans ms">
<head>
<title>Administrator Page</title>
<head>
<h2>Administrator Sales Report by Day</h2>
<body bgcolor=F88D35>
<table class="table" border="1">
<tbody>
<tr><th>Order Date</th><th>Total Order Amount</th></tr>
<%
// TODO: Include files auth.jsp and jdbc.jsp
%>
<%@include file="auth.jsp" %>
<%@include file="jdbc.jsp" %>
<%@ page import="java.text.NumberFormat" %>

<%
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
String user = (String)session.getAttribute("authenticatedUser");

// TODO: Write SQL query that prints out total order amount by day
try {
	getConnection();
	String sql = "SELECT DISTINCT orderDate FROM ordersummary";
	Statement stmt = con.createStatement();
	ResultSet rst = stmt.executeQuery(sql);
	String prev_date = "";
	while(rst.next()){
		String date = rst.getDate(1).toString();
		if(!prev_date.equals(date)) {
			String sql2 = " SELECT SUM(totalAmount) FROM ordersummary WHERE orderDate BETWEEN '"+ date +" 00:00:00.0' AND '"+ date +" 23:59:59.9'";
			Statement stmt2 = con.createStatement();
			ResultSet rst2 = stmt2.executeQuery(sql2);
			out.println("<tr><td>"+rst.getDate(1)+"</td>");
			while(rst2.next()) {
				out.println("<td>"+currFormat.format(rst2.getDouble(1))+"</td></tr>");
			}	
		}
		prev_date = date;
	}
}finally {
	closeConnection();
}
%>
</tbody>
</table>
<br>
<h2>Customer List</h2>
<table class="table" border="1">
<tbody>
<tr><th>Customer ID</th><th>First Name</th><th>Last Name</th></tr>
<%//list all cutsomers
try {
	getConnection();
	String cust_SQL = "SELECT customerId, firstName, lastName FROM customer";
	Statement stmt = con.createStatement();
	ResultSet rst3 = stmt.executeQuery(cust_SQL);
	while(rst3.next()) {
		out.println("<tr><td>"+rst3.getString(1)+"</td><td>"+rst3.getString(2)+"</td><td>"+rst3.getString(3)+"</td></tr>");
	}
	
	
}finally {
	closeConnection();
}
%>
</tbody>
</table>
<h2><a href="index.jsp">Home</a></h2>
</body>
</span>
</html>

