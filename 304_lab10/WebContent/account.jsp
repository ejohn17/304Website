<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Account</title>
</head>
<span style="font-family: comic sans ms">
<body bgcolor=F88D35>

<%
String fname = request.getParameter("fname");
String lname = request.getParameter("lname");
String email = request.getParameter("email");
String phonenum = request.getParameter("phonenum");
String address = request.getParameter("address");
String city = request.getParameter("city");
String state = request.getParameter("state");
String postalcode = request.getParameter("postalcode");
String country = request.getParameter("country");
String username = request.getParameter("username");
String password = request.getParameter("password");

String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_ejohnsto;";
String iud = "ejohnsto";
String pw = "76035344";
try(Connection con = DriverManager.getConnection(url, iud, pw);){
	PreparedStatement stmt = con.prepareStatement("INSERT INTO Customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES(?,?,?,?,?,?,?,?,?,?,?)");
	stmt.setString(1, fname);
	stmt.setString(2, lname);
	stmt.setString(3, email);
	stmt.setString(4, phonenum);
	stmt.setString(5, address);
	stmt.setString(6, city);
	stmt.setString(7, state);
	stmt.setString(8, postalcode);
	stmt.setString(9, country);
	stmt.setString(10, username);
	stmt.setString(11, password);
	stmt.execute();
	out.println("<h2>Account Created Successfully</h2>");
	out.println("<h2><a href=\"index.jsp\">Home</a></h2>");
}
catch(Exception e){
	out.println("<h2>Account Creation Failed<h2>");
	out.println("<h2><a href=\"createaccount.jsp\">Try Again</a></h2>");
	out.println("<h2><a href=\"index.jsp\">Home</a></h2>");
}

%>
</span>
</body>
</html>