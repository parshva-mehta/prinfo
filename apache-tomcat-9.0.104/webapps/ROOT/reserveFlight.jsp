<%@ page import="java.sql.*" %>
<%
    String firstName = (String) session.getAttribute("firstName");
    if (firstName == null) {
        response.sendRedirect("index.jsp");
    }

    String flightID = request.getParameter("flightID");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    double flightPrice = 0.0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airlineproj", "root", "parshva123");

        // Get flight and base fare details
        String sql = "SELECT f.flightNum, f.departure, f.arrival, al.name AS airline, f.baseFare " +
                     "FROM Flight f JOIN Airline al ON f.airlineID = al.airlineID " +
                     "WHERE f.flightID = ? LIMIT 1";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(flightID));
        rs = pstmt.executeQuery();

        if (rs.next()) {
            flightPrice = rs.getDouble("baseFare");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reserve Flight</title>
    <script>
        function calculateFare() {
            var pricePerSeat = <%= flightPrice %>;
            var numSeats = document.getElementById("numSeats").value;
            var totalFare = pricePerSeat * numSeats;
            document.getElementById("totalFare").value = totalFare.toFixed(2);
        }
    </script>
</head>
<body>
    <h2>Hello, <%= firstName %>! Reserve Flight <%= rs.getString("flightNum") %></h2>
    <p>Airline: <%= rs.getString("airline") %></p>
    <p>Departure: <%= rs.getTime("departure") %></p>
    <p>Arrival: <%= rs.getTime("arrival") %></p>
    <p>Price Per Seat: $<%= String.format("%.2f", flightPrice) %></p>

    <form action="processReservation.jsp" method="post">
        <input type="hidden" name="accountID" value="101"> <!-- Hardcoded for demo -->
        <input type="hidden" name="flightID" value="<%= flightID %>">
        <input type="hidden" name="pricePerSeat" value="<%= flightPrice %>">
        Seat: <input type="text" name="seat" required><br>
        Class: 
        <select name="class">
            <option value="Economy">Economy</option>
            <option value="Business">Business</option>
            <option value="First">First</option>
        </select><br>
        Passenger Name: <input type="text" name="passengerName" required><br>
        Number of Seats: <input type="number" id="numSeats" name="numSeats" value="1" min="1" onchange="calculateFare()" required><br>
        Total Fare: <input type="text" id="totalFare" name="totalFare" readonly><br>
        <input type="submit" value="Confirm Reservation">
    </form>

    <script>calculateFare();</script>

    <p><a href="welcome.jsp">Back to Home</a></p>
</body>
</html>

<%
        } else {
            out.println("Error: Flight not found.");
        }
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>