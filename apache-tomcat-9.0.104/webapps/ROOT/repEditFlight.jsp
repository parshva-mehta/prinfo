<%@ page import="java.sql.*" %>
<%
    String repName = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (repName == null || !"representative".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    String flightIDParam = request.getParameter("flightID");

    String dbUrl = "jdbc:mysql://localhost:3306/airlineproj";
    String dbUser = "root";
    String dbPass = "parshva123";

    Connection conn = null;
    PreparedStatement flightStmt = null;
    ResultSet flightRs = null;

    int flightID = Integer.parseInt(flightIDParam);
    String flightNum = "", daysOfWeek = "";
    String departure = "", arrival = "";
    double baseFare = 0.0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        String sql = "SELECT * FROM Flight WHERE flightID = ?";
        flightStmt = conn.prepareStatement(sql);
        flightStmt.setInt(1, flightID);
        flightRs = flightStmt.executeQuery();

        if (flightRs.next()) {
            flightNum = flightRs.getString("flightNum");
            daysOfWeek = flightRs.getString("daysOfWeek");
            departure = flightRs.getString("departure");
            arrival = flightRs.getString("arrival");
            baseFare = flightRs.getDouble("baseFare");
        }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Flight</title>
</head>
<body>
    <h2>Edit Flight ID: <%= flightID %></h2>
    <form method="post" action="repEditFlightSubmit.jsp">
        <input type="hidden" name="flightID" value="<%= flightID %>">
        Flight Number: <input type="text" name="flightNum" value="<%= flightNum %>" required><br><br>
        Days of Week: <input type="text" name="daysOfWeek" value="<%= daysOfWeek %>" required><br><br>
        Departure Time: <input type="time" name="departure" value="<%= departure %>" required><br><br>
        Arrival Time: <input type="time" name="arrival" value="<%= arrival %>" required><br><br>
        Base Fare: <input type="number" step="0.01" name="baseFare" value="<%= baseFare %>" required><br><br>

        <input type="submit" value="Update Flight">
    </form>
    <p><a href="repManageFlights.jsp">Back to Flight List</a></p>
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
