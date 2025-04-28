<%
    String name = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (name == null || !"representative".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Representative Dashboard</title>
</head>
<body>
    <h2>Welcome Representative, <%= name %>!</h2>
    <a href="logout.jsp">Logout</a>
    <br><br>

    <h3>Representative Functions</h3>
    <ul>
        <li><a href="repMakeReservation.jsp">Make Reservation for Customer</a></li>
        <li><a href="repEditReservation.jsp">Edit Customer Reservation</a></li>
        <li><a href="repReplyQuestions.jsp">Reply to User Questions</a></li>
        <li><a href="repManageFlights.jsp">Manage Flights, Aircrafts, Airports</a></li>
        <li><a href="repAirportFlights.jsp">List Flights for an Airport</a></li>
    </ul>
</body>
</html>


