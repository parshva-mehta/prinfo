<%@ page import="java.sql.*" %>
<%
    String firstName = (String) session.getAttribute("firstName");
    if (firstName == null) {
        response.sendRedirect("index.jsp");
    }

    int accountID = 101; // Replace with real session/account lookup if needed

    Connection conn = null;
    PreparedStatement pstmtUpcoming = null;
    PreparedStatement pstmtPast = null;
    ResultSet rsUpcoming = null;
    ResultSet rsPast = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airlineproj", "root", "parshva123");

        // Upcoming Reservations
        String sqlUpcoming = "SELECT ft.ticketNum, ft.seat, ft.class, ft.totalFare, f.flightNum, f.departure, f.arrival, f.departureDate, al.name AS airline " +
                             "FROM FlightTicket ft " +
                             "JOIN Flight f ON ft.flightID = f.flightID " +
                             "JOIN Airline al ON f.airlineID = al.airlineID " +
                             "WHERE ft.accountID = ? AND f.departureDate >= CURDATE()";
        pstmtUpcoming = conn.prepareStatement(sqlUpcoming);
        pstmtUpcoming.setInt(1, accountID);
        rsUpcoming = pstmtUpcoming.executeQuery();

        // Past Reservations
        String sqlPast = "SELECT ft.ticketNum, ft.seat, ft.class, ft.totalFare, f.flightNum, f.departure, f.arrival, f.departureDate, al.name AS airline " +
                         "FROM FlightTicket ft " +
                         "JOIN Flight f ON ft.flightID = f.flightID " +
                         "JOIN Airline al ON f.airlineID = al.airlineID " +
                         "WHERE ft.accountID = ? AND f.departureDate < CURDATE()";
        pstmtPast = conn.prepareStatement(sqlPast);
        pstmtPast.setInt(1, accountID);
        rsPast = pstmtPast.executeQuery();
%>

<!DOCTYPE html>
<html>
<head><title>My Reservations</title></head>
<body>
    <h2>Reservations for <%= firstName %></h2>

    <!-- Upcoming Reservations -->
    <h3>Upcoming Reservations</h3>
    <table border="1">
        <tr>
            <th>Flight Number</th>
            <th>Airline</th>
            <th>Departure</th>
            <th>Arrival</th>
            <th>Departure Date</th>
            <th>Seat</th>
            <th>Class</th>
            <th>Total Fare</th>
            <th>Cancel</th>
        </tr>
        <%
            while(rsUpcoming.next()) {
        %>
        <tr>
            <td><%= rsUpcoming.getString("flightNum") %></td>
            <td><%= rsUpcoming.getString("airline") %></td>
            <td><%= rsUpcoming.getTime("departure") %></td>
            <td><%= rsUpcoming.getTime("arrival") %></td>
            <td><%= rsUpcoming.getDate("departureDate") %></td>
            <td><%= rsUpcoming.getString("seat") %></td>
            <td><%= rsUpcoming.getString("class") %></td>
            <td>$<%= rsUpcoming.getFloat("totalFare") %></td>
            <td>
                <% if(rsUpcoming.getString("class").equals("Business") || rsUpcoming.getString("class").equals("First")) { %>
                    <a href="cancelReservation.jsp?ticketNum=<%= rsUpcoming.getInt("ticketNum") %>">Cancel</a>
                <% } else { %>
                    Not Allowed
                <% } %>
            </td>
        </tr>
        <%
            }
        %>
    </table>

    <!-- Past Reservations -->
    <h3>Past Reservations</h3>
    <table border="1">
        <tr>
            <th>Flight Number</th>
            <th>Airline</th>
            <th>Departure</th>
            <th>Arrival</th>
            <th>Departure Date</th>
            <th>Seat</th>
            <th>Class</th>
            <th>Total Fare</th>
        </tr>
        <%
            while(rsPast.next()) {
        %>
        <tr>
            <td><%= rsPast.getString("flightNum") %></td>
            <td><%= rsPast.getString("airline") %></td>
            <td><%= rsPast.getTime("departure") %></td>
            <td><%= rsPast.getTime("arrival") %></td>
            <td><%= rsPast.getDate("departureDate") %></td>
            <td><%= rsPast.getString("seat") %></td>
            <td><%= rsPast.getString("class") %></td>
            <td>$<%= rsPast.getFloat("totalFare") %></td>
        </tr>
        <%
            }
        %>
    </table>

    <p><a href="welcome.jsp">Back to Home</a></p>
</body>
</html>

<%
    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if(rsUpcoming != null) try { rsUpcoming.close(); } catch(Exception e) {}
        if(rsPast != null) try { rsPast.close(); } catch(Exception e) {}
        if(pstmtUpcoming != null) try { pstmtUpcoming.close(); } catch(Exception e) {}
        if(pstmtPast != null) try { pstmtPast.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
