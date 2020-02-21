
<%@ page import="java.sql.*"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.time.LocalDateTime"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<span style="font-family: comic sans ms">
	<head>
<title>iSticker Order</title>
	</head>
	<body bgcolor=F88D35>

		<%
			String custId = request.getParameter("customerId");
			String pass = request.getParameter("password");
			@SuppressWarnings({ "unchecked" })
			HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session
					.getAttribute("productList");

			NumberFormat currFormat = NumberFormat.getCurrencyInstance();

			boolean isCust = true;
			boolean wrongPass = false;
			//Make connection
			String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_ejohnsto;";
			String iud = "ejohnsto";
			String pw = "76035344";
			try (Connection con = DriverManager.getConnection(url, iud, pw);) {
				Statement stmt = con.createStatement();
				Integer.parseInt(custId);
				ResultSet check = stmt.executeQuery("SELECT*FROM customer WHERE customerId =" + custId);
				isCust = check.next();
				if (!pass.equals(check.getString("password"))) {
					wrongPass = true;
					throw new Exception();
				}

				// Save order information to database
				// Use retrieval of auto-generated keys.
				String insert_SQL = "INSERT INTO ordersummary (customerId, orderDate) VALUES (?,?)";
				PreparedStatement insert_pstmt = con.prepareStatement(insert_SQL, Statement.RETURN_GENERATED_KEYS);
				insert_pstmt.setString(1, custId);

				//https://www.w3schools.com/java/java_date.asp
				LocalDateTime now = LocalDateTime.now();
				DateTimeFormatter formatted_now = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
				String str_now = now.format(formatted_now);
				insert_pstmt.setString(2, str_now);
				// we need to calculate total amount

				insert_pstmt.execute();
				ResultSet keys = insert_pstmt.getGeneratedKeys();
				// get most recent order id number
				keys.next();
				int orderId = keys.getInt(1);

				// Insert each item into OrderProduct table using OrderId from previous INSERT

				// Update total amount for order record

				// Here is the code to traverse through a HashMap
				// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price
				double totalAmount = 0;
				if (productList.isEmpty()) {
					throw new Exception();
				}
				Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
				while (iterator.hasNext()) {
					Map.Entry<String, ArrayList<Object>> entry = iterator.next();
					ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
					String productId = (String) product.get(0);
					String price = (String) product.get(2);
					double pr = Double.parseDouble(price);
					int qty = ((Integer) product.get(3)).intValue();

					PreparedStatement p2stmt = con.prepareStatement("INSERT INTO orderproduct VALUES (?,?,?,?)");
					p2stmt.setInt(1, orderId);
					p2stmt.setString(2, productId);
					p2stmt.setInt(3, qty);
					p2stmt.setDouble(4, pr);
					p2stmt.execute();

					totalAmount += pr * qty;
				}

				PreparedStatement uptot = con
						.prepareStatement("UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?");
				uptot.setDouble(1, totalAmount);
				uptot.setInt(2, orderId);
				uptot.execute();

				// Print out order summary

				// Clear cart if order placed successfully
				productList.clear();
				Statement orderHere = con.createStatement();
				ResultSet orderSum = orderHere.executeQuery(
						"SELECT * FROM orderProduct,product WHERE orderProduct.productId = product.productId AND orderId ="
								+ orderId);
		%>
		<table>
			<thead>
				<tr>
					<th>Product Id</th>
					<th>Product Name</th>
					<th>Quantity</th>
					<th>Price</th>
					<th>Subtotal</th>
				</tr>
			</thead>
			<tbody>
				<%
					while (orderSum.next()) {
							out.println("<tr>");
							out.println("<td>" + orderSum.getString("productId") + "</td>");
							out.println("<td>" + orderSum.getString("productName") + "</td>");
							out.println("<td>" + orderSum.getString("quantity") + "</td>");
							out.println("<td>" + currFormat.format(orderSum.getDouble("price")) + "</td>");
							out.println("<td>" + currFormat.format(orderSum.getInt("quantity") * orderSum.getDouble("price"))
									+ "</td>");
							out.println("</tr>");
						}
				%>
			</tbody>
		</table>
		<b>Order Total: <%
			out.print("</b>" + currFormat.format(totalAmount));
		%><br> <br> <b>Order Successful! Your products will
				arrive soon!</b><br> <br> <%
 	out.println("<b>Make sure to keep your order reference number: " + orderId + "</b>");
	out.println("<h2><a href=\"index.jsp\">Home</a></h2>");
 	} 
	catch (NumberFormatException f) {
 		out.println("<h1>This ain't a valid customer ID silly!</h1>");
 		out.println("<h2><a href=\"checkout.jsp\">Try Again</a></h2>");
 		out.println("<h2><a href=\"index.jsp\">Home</a></h2>");
 	} catch (Exception e) {
 		if (!isCust) {
 			out.println("<h1>This ain't a valid customer ID silly!</h1>");
 	 		out.println("<h2><a href=\"checkout.jsp\">Try Again</a></h2>");
 	 		out.println("<h2><a href=\"index.jsp\">Home</a></h2>");
 		} else if (wrongPass) {
 			out.println("<h1>Wrong password for Customer ID!</h1>");
 	 		out.println("<h2><a href=\"checkout.jsp\">Try Again</a></h2>");
 	 		out.println("<h2><a href=\"index.jsp\">Home</a></h2>");
 		} else {
 			out.println("<h1>Your Shopping Cart is Empty! Get Purchasing!!</h1>");
 	 		out.println("<h2><a href=\"checkout.jsp\">Try Again</a></h2>");
 	 		out.println("<h2><a href=\"index.jsp\">Home</a></h2>");
 		}
 	}
 %>
	</BODY>
</span>
</HTML>

