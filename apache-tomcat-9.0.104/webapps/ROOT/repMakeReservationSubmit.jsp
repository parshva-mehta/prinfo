<%@ page import="java.sql.*, java.util.*" %>
<%
    String repName = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (repName == null || !"representative".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    String accountID = request.getParameter("accountID");
    String flightID = request.getParameter("flightID");
    String seat = request.getParameter("seat");
    String seatClass = request.getParameter("class");
    String totalFareStr = request.getParameter("totalFare");

    String dbUrl = "jdbc:mysql://localhost:3306/airlineproj";
    String dbUser = "root";
    String dbPass = "parshva123";

    Connection conn = null;
    PreparedStatement insertStmt = null;

    boolean success = false;
    String message = "";

    try {
        double totalFare = Double.parseDouble(totalFareStr);
        double bookingFee = 15.0; // Example fixed fee

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        String insertSQL = "INSERT INTO FlightTicket (seat, class, passengerName, passengerID, purchaseDateTime, requestDateTime, bookingFee, totalFare, flightID, accountID) " +
                           "VALUES (?, ?, ?, ?, NOW(), NOW(), ?, ?, ?, ?)";

        insertStmt = conn.prepareStatement(insertSQL);

        // For simplicity, assuming representative does not enter passengerName/passengerID manually
        String passengerName = "Customer " + accountID; // Placeholder or fetch real name if needed
        int passengerID = Integer.parseInt(accountID);  // Assuming accountID matches customerID

        insertStmt.setString(1, seat);
        insertStmt.setString(2, seatClass);
        insertStmt.setString(3, passengerName);
        insertStmt.setInt(4, passengerID);
        insertStmt.setDouble(5, bookingFee);
        insertStmt.setDouble(6, totalFare);
        insertStmt.setInt(7, Integer.parseInt(flightID));
        insertStmt.setInt(8, Integer.parseInt(accountID));

        int rowsInserted = insertStmt.executeUpdate();

        if (rowsInserted > 0) {
            success = true;
            message = "Reservation successfully made for customer ID: " + accountID;
        } else {
            message = "Failed to make reservation.";
        }

    } catch (Exception e) {
        message = "Error: " + e.getMessage();
        e.printStackTrace();
    } finally {
        if (insertStmt != null) try { insertStmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reservation Result</title>
</head>
<body>
    <h2>Reservation Status</h2>
    <p><%= message %></p>
    <% if (success) { %>
        <p><a href="repMakeReservation.jsp">Make Another Reservation</a></p>
    <% } %>
    <p><a href="repWelcome.jsp">Back to Dashboard</a></p>
</body>
</html>
