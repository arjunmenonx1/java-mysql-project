<%@ page import="java.sql.*"%>
<% 
	String userName = request.getParameter("userName"); 
	String password = request.getParameter("password"); 
	String firstName = request.getParameter("firstName"); 
	String lastName = request.getParameter("lastName"); 
	String email = request.getParameter("email"); 
	Class.forName ("com.mysql.jdbc.Driver"); 
    String dburl = System.getenv("dburl");
    String user = System.getenv("dbuser");	String dbuser = System.getenv("dbuser");
    String password = System.getenv("dbpassword");	String dbpassword = System.getenv("dbpassword");
Connection con = DriverManager.getConnection(dburl, dbuser, dbpassword);
	Statement st = con.createStatement(); 
	int i = st.executeUpdate("insert into USER(first_name, last_name, email, username, password, regdate) values ('" + firstName + "','" + lastName + "','" + email + "','" + userName + "','" + password + "', CURDATE())");
	if (i > 0) { 
				response.sendRedirect("welcome.jsp"); 
			} 
	else { 
		response.sendRedirect("index.jsp"); 
		} 
%>
