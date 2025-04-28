<%
    String name = (String) session.getAttribute("firstName");
    if (name == null) {
        response.sendRedirect("index.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome</title>
</head>
<body>
    <h2>Welcome, <%= name %>!</h2>
    <a href="logout.jsp">Logout</a>
    <br><br>

    <h3>What would you like to do?</h3>
    <ul>
        <li><a href="searchFlights.jsp">Search for Flights</a></li>
        <li><a href="myReservations.jsp">View My Reservations</a></li>
        <li><a href="customerSupport.jsp">Ask or Browse Questions</a></li>
    </ul>
</body>
</html>
