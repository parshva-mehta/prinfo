
<%
    String name = (String) session.getAttribute("firstName");
    if (name == null) {
        response.sendRedirect("login.jsp");
    }
%>
<h2>Welcome, <%= name %>!</h2>
<a href="logout.jsp">Logout</a>
