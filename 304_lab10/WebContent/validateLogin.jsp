<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);
	
	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null){
		session.setAttribute("authenticatedUser",authenticatedUser);
		response.sendRedirect("index.jsp");		// Successful login
	}
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String custId = "";
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			getConnection();
			
			// TODO: Check if userid and password match some customer account. If so, set retStr to be the username.
			String SQL = "SELECT userid, customerId FROM customer WHERE userid = ?";
			PreparedStatement pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, username);
			ResultSet rst = pstmt.executeQuery();
			while(rst.next()){
				custId = rst.getString(2);
				if(rst.getString(1) != null) {
					String pass_SQL = "SELECT password FROM customer WHERE userid = ?";
					PreparedStatement pass_pstmt = con.prepareStatement(pass_SQL);
					pass_pstmt.setString(1, username);
					ResultSet pass_rst = pass_pstmt.executeQuery();
					String valid_pass = "";
					while(pass_rst.next()) {
						valid_pass = pass_rst.getString(1);
					}
					if(valid_pass.equals(password)){
						retStr = username;
						System.out.println(retStr+ ", " +valid_pass);
					}else{
						retStr = "";
					} 
					
				}else{
					retStr = "";
				}
			}			
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
			session.setAttribute("custId",custId);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
	
%>

