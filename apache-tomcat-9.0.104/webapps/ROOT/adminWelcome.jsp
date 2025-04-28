<%
    String name = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (name == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
</head>
<body>
    <h2>Welcome Admin, <%= name %>!</h2>
    <a href="logout.jsp">Logout</a>
    <br><br>

    <h3>Admin Functions</h3>
    <ul>
        <li><a href="manageUsers.jsp">Manage Users</a></li>
        <li><a href="salesReport.jsp">View Sales Report</a></li>
        <li><a href="reservationsReport.jsp">View Reservations by Flight or Customer</a></li>
        <li><a href="revenueSummary.jsp">Revenue Summary by Flight/Airline/Customer</a></li>
    </ul>
</body>
</html>
