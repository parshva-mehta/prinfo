<%@ page import="java.sql.*" %>
<%
    String firstName = (String) session.getAttribute("firstName");
    if (firstName == null) {
        response.sendRedirect("index.jsp");
    }

    String flightID = request.getParameter("flightID");
    String seat = request.getParameter("seat");
    String classType = request.getParameter("class");
    String passengerName = request.getParameter("passengerName");
    int numSeats = Integer.parseInt(request.getParameter("numSeats"));
    double totalFare = Double.parseDouble(request.getParameter("totalFare"));

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airlineproj", "root", "parshva123");

        int passengerID = 1; // demo hardcoded
        int accountID = 101; // demo hardcoded

        // 1. Check capacity
        PreparedStatement capStmt = conn.prepareStatement("SELECT capacity FROM Flight WHERE flightID = ?");
        capStmt.setInt(1, Integer.parseInt(flightID));
        rs = capStmt.executeQuery();
        int capacity = 0;
        if (rs.next()) {
            capacity = rs.getInt("capacity");
        }
        rs.close();
        capStmt.close();

        // 2. Count current bookings
        PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(*) AS bookedSeats FROM FlightTicket WHERE flightID = ?");
        countStmt.setInt(1, Integer.parseInt(flightID));
        rs = countStmt.executeQuery();
        int bookedSeats = 0;
        if (rs.next()) {
            bookedSeats = rs.getInt("bookedSeats");
        }
        rs.close();
        countStmt.close();

        boolean addedToWaitlist = false;

        if (bookedSeats + numSeats <= capacity) {
            // 3. Proceed with reservation
            String sql = "INSERT INTO FlightTicket (seat, class, passengerName, passengerID, purchaseDateTime, requestDateTime, totalFare, flightID, accountID) VALUES (?, ?, ?, ?, NOW(), NOW(), ?, ?, ?)";
            for (int i = 0; i < numSeats; i++) {
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, seat + (i+1)); // simple seat labeling like A1, A2, etc.
                pstmt.setString(2, classType);
                pstmt.setString(3, passengerName);
                pstmt.setInt(4, passengerID);
                pstmt.setDouble(5, totalFare / numSeats); // divide fare per seat
                pstmt.setInt(6, Integer.parseInt(flightID));
                pstmt.setInt(7, accountID);
                pstmt.executeUpdate();
                pstmt.close();
            }
        } else {
            // 4. Add to waitlist
            PreparedStatement waitlistStmt = conn.prepareStatement("INSERT INTO CustomerAccountFlight_WaitsFor (accountID, seat, requestDateTime, flightID) VALUES (?, ?, NOW(), ?)");
            waitlistStmt.setInt(1, accountID);
            waitlistStmt.setString(2, seat); // could label better for multiple seats
            waitlistStmt.setInt(3, Integer.parseInt(flightID));
            waitlistStmt.executeUpdate();
            waitlistStmt.close();
            addedToWaitlist = true;
        }
%>

<!DOCTYPE html>
<html>
<head><title>Reservation Status</title></head>
<body>
    <h2>
    <%
        if (!addedToWaitlist) {
    %>
        Reservation Confirmed!
    <%
        } else {
    %>
        Flight Full - Waitlisted
    <%
        }
    %>
    </h2>

    <p>Flight ID: <%= flightID %></p>
    <p>Passenger: <%= passengerName %></p>
    <p>Total Seats Requested: <%= numSeats %></p>
    <p>Total Fare: $<%= totalFare %></p>

    <%
        if (addedToWaitlist) {
    %>
        <p style="color:red;">The flight was full. You have been added to the waitlist.</p>
    <%
        } else {
    %>
        <p style="color:green;">Thank you for your reservation!</p>
    <%
        }
    %>

    <p><a href="welcome.jsp">Back to Home</a></p>
</body>
</html>

<%
    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>