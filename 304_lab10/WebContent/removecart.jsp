<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String id = request.getParameter("id");
String name = request.getParameter("name");
String price = request.getParameter("price");
int quantity = 1;

ArrayList<Object> product = new ArrayList<Object>();
product.add(id);
product.add(name);
product.add(price);
product.add(quantity);
product = (ArrayList<Object>) productList.get(id);
quantity = ((Integer) product.get(3)).intValue();


productList.remove(id);

session.setAttribute("productList", productList);
%>
<jsp:forward page="showcart.jsp" />