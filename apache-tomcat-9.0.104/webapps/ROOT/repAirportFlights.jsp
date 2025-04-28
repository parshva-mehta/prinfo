<%@ page import="java.sql.*" %>
<%
    String repName = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (repName == null || !"representative".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    String selectedAirportID = request.getParameter("airportID");

    String dbUrl = "jdbc:mysql://localhost:3306/airlineproj";
    String dbUser = "root";
    String dbPass = "parshva123";

    Connection conn = null;
    PreparedStatement airportStmt = null;
    PreparedStatement flightStmt = null;
    ResultSet airportRs = null;
    ResultSet flightRs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // Fetch list of airports
        String airportSql = "SELECT airportID, name FROM Airport";
        airportStmt = conn.prepareStatement(airportSql);
        airportRs = airportStmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Flights for an Airport</title>
</head>
<body>
    <h2>List Flights for an Airport</h2>
    <p><a href="repWelcome.jsp">Back to Dashboard</a></p>

    <form method="get" action="repAirportFlights.jsp">
        <label>Select Airport:</label>
        <select name="airportID" required>
            <option value="">--Select--</option>
            <% while(airportRs.next()) { 
                String airportID = String.valueOf(airportRs.getInt("airportID"));
                String airportName = airportRs.getString("name");
            %>
                <option value="<%= airportID %>" <%= airportID.equals(selectedAirportID) ? "selected" : "" %>>
                    <%= airportName %>
                </option>
            <% } %>
        </select>
        <input type="submit" value="Show Flights">
    </form>

    <% 
    if (selectedAirportID != null && !selectedAirportID.isEmpty()) {
        String flightSql = "SELECT f.flightID, f.flightNum, f.departure, f.arrival, f.baseFare, 'Departs' AS type " +
                           "FROM Flight f JOIN AirportFlight_DepartsFrom afd ON f.flightID = afd.flightID " +
                           "WHERE afd.airportID = ? " +
                           "UNION " +
                           "SELECT f.flightID, f.flightNum, f.departure, f.arrival, f.baseFare, 'Arrives' AS type " +
                           "FROM Flight f JOIN AirportFlight_ArrivesAt afa ON f.flightID = afa.flightID " +
                           "WHERE afa.airportID = ?";
        flightStmt = conn.prepareStatement(flightSql);
        flightStmt.setInt(1, Integer.parseInt(selectedAirportID));
        flightStmt.setInt(2, Integer.parseInt(selectedAirportID));
        flightRs = flightStmt.executeQuery();
    %>

    <h3>Flights for Selected Airport</h3>
    <table border="1" cellpadding="5">
        <tr>
            <th>Flight ID</th>
            <th>Flight Number</th>
            <th>Departure Time</th>
            <th>Arrival Time</th>
            <th>Base Fare ($)</th>
            <th>Type</th>
        </tr>
        <% while(flightRs.next()) { %>
            <tr>
                <td><%= flightRs.getInt("flightID") %></td>
                <td><%= flightRs.getString("flightNum") %></td>
                <td><%= flightRs.getTime("departure") %></td>
                <td><%= flightRs.getTime("arrival") %></td>
                <td><%= flightRs.getDouble("baseFare") %></td>
                <td><%= flightRs.getString("type") %></td>
            </tr>
        <% } %>
    </table>
    <% } %>

</body>
</html>

<%
    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if(flightRs != null) try { flightRs.close(); } catch(Exception e) {}
        if(airportRs != null) try { airportRs.close(); } catch(Exception e) {}
        if(flightStmt != null) try { flightStmt.close(); } catch(Exception e) {}
        if(airportStmt != null) try { airportStmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
