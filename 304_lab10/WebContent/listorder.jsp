<%@ page import="java.sql.*"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<span style="font-family: comic sans ms">
	<head>
<title>YOUR NAME Grocery Order List</title>
	</head>
	<body bgcolor=F88D35>

		<h1>iStickers Order List</h1>
		<h2><a href="index.jsp">Home</a></h2>
		
		<%
			NumberFormat currFormat = NumberFormat.getCurrencyInstance();
			//Note: Forces loading of SQL Server driver
			try { // Load driver class
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			} catch (java.lang.ClassNotFoundException e) {
				out.println("ClassNotFoundException: " + e);
			}
			String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_ejohnsto;";
			String iud = "ejohnsto";
			String pw = "76035344";
			try (Connection con = DriverManager.getConnection(url, iud, pw); Statement stmt = con.createStatement();) {
				StringBuilder str = new StringBuilder();
				ResultSet rset = stmt.executeQuery(
						"SELECT orderId, orderDate, totalAmount, customer.customerid, firstName, lastName "
								+ "FROM ordersummary, customer WHERE ordersummary.customerid = customer.customerid");
				PreparedStatement pstmt = con
						.prepareStatement("SELECT productId, quantity, price FROM orderproduct WHERE orderid = ?");

				// Useful code for formatting currency values:
				// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
				// out.println(currFormat.format(5.0);  // Prints $5.00

				// Make connection

				// Write query to retrieve all order summary records

				// For each order in the ResultSet

				// Print out the order summary information
				// Write a query to retrieve the products in the order
				//   - Use a PreparedStatement as will repeat this query many times
				// For each product in the order
				// Write out product information 

				// Close connection
		%>
		<table border=1 align=left style="text-align: center" cellpadding="5">
			<thead>
				<tr>
					<th>orderId</th>
					<th>orderDate</th>
					<th>totalAmount</th>
					<th>customerId</th>
					<th>firstName</th>
					<th>lastName</th>
				</tr>
			</thead>
			<tbody>

				<%
					while (rset.next()) {
							String oid = rset.getString("orderId");
				%>
				<tr>
					<td style="padding: 20px;"><%=oid%></td>
					<td><%=rset.getString("orderDate")%></td>
					<td><%=currFormat.format(rset.getDouble("totalAmount"))%></td>
					<td><%=rset.getString("customerId")%></td>
					<td><%=rset.getString("firstName")%></td>
					<td><%=rset.getString("lastName")%></td>
				</tr>
				<tr>
			<thead>
				<tr>
				<td>
				<td>
				<td>
					<th>Product ID</th>
					<th>Quantity</th>
					<th>Price</th>
				</td>
				</td>
				</td>
				</tr>
			</thead>
			<tbody>
				<%
					pstmt.setString(1, oid);
							ResultSet rset2 = pstmt.executeQuery();
							while (rset2.next()) {
				%>
				<td>
				<td>
				<td>
					<td><%=rset2.getString("productId")%></td>
					<td><%=rset2.getString("quantity")%></td>
					<td><%=currFormat.format(rset2.getDouble("price"))%></td>
				</td>
				</td>
				</td>
			</tbody>
			<%
				}
			%>
			</tr>
			<%
				}
			%>
			</tbody>
		</table>
		<br>
		<%
			} catch (SQLException ex) {
				out.println(ex);
			}
		%>
	</body>
</span>
</html>

