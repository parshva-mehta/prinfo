<%@ page import="java.sql.*" %>
<%
    String repName = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (repName == null || !"representative".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    int flightID = Integer.parseInt(request.getParameter("flightID"));
    String flightNum = request.getParameter("flightNum");
    String daysOfWeek = request.getParameter("daysOfWeek");
    String departure = request.getParameter("departure");
    String arrival = request.getParameter("arrival");
    double baseFare = Double.parseDouble(request.getParameter("baseFare"));

    String dbUrl = "jdbc:mysql://localhost:3306/airlineproj";
    String dbUser = "root";
    String dbPass = "parshva123";

    Connection conn = null;
    PreparedStatement updateStmt = null;
    String message = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        String updateSql = "UPDATE Flight SET flightNum = ?, daysOfWeek = ?, departure = ?, arrival = ?, baseFare = ? WHERE flightID = ?";
        updateStmt = conn.prepareStatement(updateSql);

        updateStmt.setString(1, flightNum);
        updateStmt.setString(2, daysOfWeek);
        if (departure.length() == 5) { 
            departure = departure + ":00";
        }
        updateStmt.setTime(3, Time.valueOf(departure));
        if (arrival.length() == 5) {
            arrival = arrival + ":00";
        }
        updateStmt.setTime(4, Time.valueOf(arrival));
        updateStmt.setDouble(5, baseFare);
        updateStmt.setInt(6, flightID);

        int rows = updateStmt.executeUpdate();

        if (rows > 0) {
            message = "Flight successfully updated!";
        } else {
            message = "Failed to update flight.";
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
    <title>Edit Flight Result</title>
</head>
<body>
    <h2>Edit Flight Status</h2>
    <p><%= message %></p>
    <p><a href="repManageFlights.jsp">Back to Manage Flights</a></p>
    <p><a href="repWelcome.jsp">Back to Dashboard</a></p>
</body>
</html>
