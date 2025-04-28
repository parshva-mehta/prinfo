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
    PreparedStatement ticketStmt = null;
    ResultSet ticketRs = null;

    String ticketNumParam = request.getParameter("ticketNum");
    boolean ticketFound = false;

    try {
        if (ticketNumParam != null && !ticketNumParam.isEmpty()) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            String ticketSql = "SELECT * FROM FlightTicket WHERE ticketNum = ?";
            ticketStmt = conn.prepareStatement(ticketSql);
            ticketStmt.setInt(1, Integer.parseInt(ticketNumParam));
            ticketRs = ticketStmt.executeQuery();

            if (ticketRs.next()) {
                ticketFound = true;
            }
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (!ticketFound && ticketStmt != null) try { ticketStmt.close(); } catch (Exception e) {}
        if (!ticketFound && conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Reservation</title>
</head>
<body>
    <h2>Edit a Reservation</h2>
    <p><a href="repWelcome.jsp">Back to Dashboard</a></p>

    <form method="get" action="repEditReservation.jsp">
        <label>Enter Ticket Number:</label>
        <input type="text" name="ticketNum" required>
        <input type="submit" value="Search">
    </form>

    <%
        if (ticketFound) {
            int ticketNum = ticketRs.getInt("ticketNum");
            String seat = ticketRs.getString("seat");
            String seatClass = ticketRs.getString("class");
            double totalFare = ticketRs.getDouble("totalFare");
    %>

    <h3>Reservation Details (Ticket #: <%= ticketNum %>)</h3>
    <form method="post" action="repEditReservationSubmit.jsp">
        <input type="hidden" name="ticketNum" value="<%= ticketNum %>">

        Seat: <input type="text" name="seat" value="<%= seat %>" required><br><br>

        Class:
        <select name="class" required>
            <option value="Economy" <%= "Economy".equalsIgnoreCase(seatClass) ? "selected" : "" %>>Economy</option>
            <option value="Business" <%= "Business".equalsIgnoreCase(seatClass) ? "selected" : "" %>>Business</option>
            <option value="First" <%= "First".equalsIgnoreCase(seatClass) ? "selected" : "" %>>First</option>
        </select><br><br>

        Total Fare: <input type="number" name="totalFare" step="0.01" value="<%= totalFare %>" required><br><br>

        <input type="submit" value="Update Reservation">
    </form>

    <%
        }
        if (ticketRs != null) try { ticketRs.close(); } catch (Exception e) {}
        if (ticketStmt != null) try { ticketStmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    %>

</body>
</html>
