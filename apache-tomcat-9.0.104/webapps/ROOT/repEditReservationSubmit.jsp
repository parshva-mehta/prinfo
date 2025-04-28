<%@ page import="java.sql.*" %>
<%
    String repName = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (repName == null || !"representative".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    String ticketNum = request.getParameter("ticketNum");
    String seat = request.getParameter("seat");
    String seatClass = request.getParameter("class");
    String totalFareStr = request.getParameter("totalFare");

    String dbUrl = "jdbc:mysql://localhost:3306/airlineproj";
    String dbUser = "root";
    String dbPass = "parshva123";

    Connection conn = null;
    PreparedStatement updateStmt = null;

    boolean success = false;
    String message = "";

    try {
        double totalFare = Double.parseDouble(totalFareStr);

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        String updateSQL = "UPDATE FlightTicket SET seat = ?, class = ?, totalFare = ? WHERE ticketNum = ?";

        updateStmt = conn.prepareStatement(updateSQL);
        updateStmt.setString(1, seat);
        updateStmt.setString(2, seatClass);
        updateStmt.setDouble(3, totalFare);
        updateStmt.setInt(4, Integer.parseInt(ticketNum));

        int rowsUpdated = updateStmt.executeUpdate();

        if (rowsUpdated > 0) {
            success = true;
            message = "Reservation (Ticket #" + ticketNum + ") was successfully updated.";
        } else {
            message = "No reservation found with Ticket #" + ticketNum + ".";
        }

    } catch (Exception e) {
        message = "Error: " + e.getMessage();
        e.printStackTrace();
    } finally {
        if (updateStmt != null) try { updateStmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Reservation Result</title>
</head>
<body>
    <h2>Update Reservation Status</h2>
    <p><%= message %></p>
    <% if (success) { %>
        <p><a href="repEditReservation.jsp">Edit Another Reservation</a></p>
    <% } %>
    <p><a href="repWelcome.jsp">Back to Dashboard</a></p>
</body>
</html>
