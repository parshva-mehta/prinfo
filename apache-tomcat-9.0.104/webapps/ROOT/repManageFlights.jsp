<%@ page import="java.sql.*" %>
<%
    String repName = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (repName == null || !"representative".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    String dbUrl = "jdbc:mysql://localhost:3306/airlineproj";
    String dbUser = "root";
    String dbPass = "parshva123";

    Connection conn = null;
    PreparedStatement flightStmt = null;
    ResultSet flightRs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        String flightSql = "SELECT flightID, flightNum, daysOfWeek, departure, arrival, baseFare FROM Flight";
        flightStmt = conn.prepareStatement(flightSql);
        flightRs = flightStmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Flights</title>
</head>
<body>
    <h2>Manage Flights</h2>
    <p><a href="repWelcome.jsp">Back to Dashboard</a></p>

    <h3>Existing Flights</h3>
    <table border="1" cellpadding="5">
        <tr>
            <th>Flight ID</th>
            <th>Flight Number</th>
            <th>Days of Week</th>
            <th>Departure</th>
            <th>Arrival</th>
            <th>Base Fare ($)</th>
            <th>Actions</th>
        </tr>
        <% while(flightRs.next()) { 
            int flightID = flightRs.getInt("flightID");
        %>
            <tr>
                <td><%= flightID %></td>
                <td><%= flightRs.getString("flightNum") %></td>
                <td><%= flightRs.getString("daysOfWeek") %></td>
                <td><%= flightRs.getTime("departure") %></td>
                <td><%= flightRs.getTime("arrival") %></td>
                <td><%= flightRs.getDouble("baseFare") %></td>
                <td>
                    <form method="get" action="repEditFlight.jsp">
                        <input type="hidden" name="flightID" value="<%= flightID %>">
                        <input type="submit" value="Edit">
                    </form>
                </td>
            </tr>
        <% } %>
    </table>

    <h3>Add New Flight</h3>
    <form method="post" action="repManageFlightsSubmit.jsp">
        Flight Number: <input type="text" name="flightNum" required><br><br>
        Days of Week: <input type="text" name="daysOfWeek" placeholder="Mon,Wed,Fri" required><br><br>
        Departure Time: <input type="time" name="departure" required><br><br>
        Arrival Time: <input type="time" name="arrival" required><br><br>
        Base Fare: <input type="number" step="0.01" name="baseFare" required><br><br>

        <input type="submit" value="Add Flight">
    </form>

</body>
</html>

<%
    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if(flightRs != null) try { flightRs.close(); } catch(Exception e) {}
        if(flightStmt != null) try { flightStmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
