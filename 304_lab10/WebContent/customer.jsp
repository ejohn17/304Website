<!DOCTYPE html>
<html>
<span style="font-family: comic sans ms">
<head>
<title>Customer Page</title>
</head>
<body bgcolor=F88D35>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// TODO: Print Customer information
String sql = "SELECT * FROM customer WHERE userid = ?";

try{
	getConnection();
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1,userName);
	
	ResultSet rst = pstmt.executeQuery();
	while(rst.next()){
		%>
		<h3>Customer Profile</h3>
		<table border = 1>
			<tbody>
				<tr> <th>Id</th> <td><%out.println(rst.getString(1));%></td> </tr>
				<tr> <th>First Name</th> <td><%out.println(rst.getString(2));%></td> </tr>
				<tr> <th>Last Name</th> <td><%out.println(rst.getString(3));%></td> </tr>
				<tr> <th>Email</th> <td><%out.println(rst.getString(4));%></td> </tr>
				<tr> <th>Phone</th> <td><%out.println(rst.getString(5));%></td> </tr>
				<tr> <th>Address</th> <td><%out.println(rst.getString(6));%></td> </tr>
				<tr> <th>City</th> <td><%out.println(rst.getString(7));%></td> </tr>
				<tr> <th>State</th> <td><%out.println(rst.getString(8));%></td> </tr>
				<tr> <th>Postal Code</th> <td><%out.println(rst.getString(9));%></td> </tr>
				<tr> <th>Country</th> <td><%out.println(rst.getString(10));%></td> </tr>
				<tr> <th>User id</th> <td><%out.println(rst.getString(11));%></td> </tr>
				<tr> <th>Password</th> <td><%out.println("Nice try, hackerman >:)");%></td> </tr>
			</tbody>
		</table>
		<%
	}
	
}finally{
	closeConnection();
}

// Make sure to close connection
%>
<h2><a href="index.jsp">Home</a></h2>

</body>
</span>
</html>

