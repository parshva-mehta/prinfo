<%@ page import="java.sql.*" %>
<%
    String departureAirport = request.getParameter("departureAirport");
    String arrivalAirport = request.getParameter("arrivalAirport");
    String tripType = request.getParameter("tripType");
    String departureDate = request.getParameter("departureDate");
    String flexibleDates = request.getParameter("flexibleDates");
    String arrivalDate = request.getParameter("arrivalDate");

    // Sorting/Filtering parameters
    String sortBy = request.getParameter("sortBy");
    String airlineFilter = request.getParameter("airlineFilter");
    String priceMin = request.getParameter("priceMin");
    String priceMax = request.getParameter("priceMax");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airlineproj", "root", "parshva123");

        String sql = "SELECT f.flightID, f.flightNum, f.departure, f.arrival, f.domestic, f.daysOfWeek, " +
                     "TIMESTAMPDIFF(MINUTE, f.departure, f.arrival) AS duration, " +
                     "a1.name AS depAirport, a2.name AS arrAirport, al.name AS airline, f.baseFare " +
                     "FROM Flight f " +
                     "JOIN AirportFlight_DepartsFrom afd ON f.flightID = afd.flightID " +
                     "JOIN Airport a1 ON afd.airportID = a1.airportID " +
                     "JOIN AirportFlight_ArrivesAt afa ON f.flightID = afa.flightID " +
                     "JOIN Airport a2 ON afa.airportID = a2.airportID " +
                     "JOIN Airline al ON f.airlineID = al.airlineID " +
                     "WHERE a1.name = ? AND a2.name = ? ";

        if ("on".equals(flexibleDates)) {
            sql += "AND f.departureDate BETWEEN DATE_SUB(?, INTERVAL 3 DAY) AND DATE_ADD(?, INTERVAL 3 DAY) ";
        } else {
            sql += "AND f.departureDate = ? ";
        }

        if (airlineFilter != null && !airlineFilter.isEmpty()) {
            sql += "AND al.name = ? ";
        }

        if (priceMin != null && !priceMin.isEmpty()) {
            sql += "AND f.baseFare >= ? ";
        }

        if (priceMax != null && !priceMax.isEmpty()) {
            sql += "AND f.baseFare <= ? ";
        }

        if (sortBy != null) {
            if (sortBy.equals("price")) sql += "ORDER BY f.baseFare ASC ";
            else if (sortBy.equals("departure")) sql += "ORDER BY f.departure ASC ";
            else if (sortBy.equals("arrival")) sql += "ORDER BY f.arrival ASC ";
            else if (sortBy.equals("duration")) sql += "ORDER BY duration ASC ";
        }

        pstmt = conn.prepareStatement(sql);
        int paramIndex = 1;
        pstmt.setString(paramIndex++, departureAirport);
        pstmt.setString(paramIndex++, arrivalAirport);
        pstmt.setString(paramIndex++, departureDate);
        if ("on".equals(flexibleDates)) {
            pstmt.setString(paramIndex++, departureDate);
        }
        if (airlineFilter != null && !airlineFilter.isEmpty()) {
            pstmt.setString(paramIndex++, airlineFilter);
        }
        if (priceMin != null && !priceMin.isEmpty()) {
            pstmt.setFloat(paramIndex++, Float.parseFloat(priceMin));
        }
        if (priceMax != null && !priceMax.isEmpty()) {
            pstmt.setFloat(paramIndex++, Float.parseFloat(priceMax));
        }

        rs = pstmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Flights</title>
</head>
<body>
    <h2>Flights from <%= departureAirport %> to <%= arrivalAirport %></h2>

    <!-- Filtering and Sorting Form -->
    <form action="flightResults.jsp" method="get">
        <input type="hidden" name="departureAirport" value="<%= departureAirport %>">
        <input type="hidden" name="arrivalAirport" value="<%= arrivalAirport %>">
        <input type="hidden" name="departureDate" value="<%= departureDate %>">
        <input type="hidden" name="flexibleDates" value="<%= flexibleDates %>">

        Airline: <input type="text" name="airlineFilter" value="<%= airlineFilter != null ? airlineFilter : "" %>">
        Price Min: <input type="text" name="priceMin" value="<%= priceMin != null ? priceMin : "" %>">
        Price Max: <input type="text" name="priceMax" value="<%= priceMax != null ? priceMax : "" %>">
        Sort By:
        <select name="sortBy">
            <option value="">-- Select --</option>
            <option value="price">Price</option>
            <option value="departure">Take-off Time</option>
            <option value="arrival">Landing Time</option>
            <option value="duration">Duration</option>
        </select>
        <input type="submit" value="Apply Filters">
    </form>

    <!-- Flight Results Table -->
    <table border="1">
        <tr>
            <th>Flight Number</th>
            <th>Departure Time</th>
            <th>Arrival Time</th>
            <th>Duration (min)</th>
            <th>Airline</th>
            <th>Price</th>
            <th>Reserve</th>
        </tr>
        <%
            while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("flightNum") %></td>
            <td><%= rs.getTime("departure") %></td>
            <td><%= rs.getTime("arrival") %></td>
            <td><%= rs.getInt("duration") %></td>
            <td><%= rs.getString("airline") %></td>
            <%
                float fare = rs.getFloat("baseFare");
            %>
            <td><%= fare > 0 ? "$" + String.format("%.2f", fare) : "N/A" %></td>
            <td><a href="reserveFlight.jsp?flightID=<%= rs.getInt("flightID") %>">Reserve</a></td>
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
        out.println("Error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
