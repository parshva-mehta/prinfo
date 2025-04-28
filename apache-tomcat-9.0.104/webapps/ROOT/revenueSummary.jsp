<%@ page import="java.sql.*" %>
<%
    String name = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (name == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    String reportType = request.getParameter("type"); // flight, airline, customer
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    PreparedStatement topStmt = null;
    ResultSet topRs = null;

    String topLabel = "";
    double topRevenue = 0.0;
%>

<!DOCTYPE html>
<html>
<head><title>Revenue Summary</title></head>
<body>
    <h2>Revenue Summary</h2>
    <p><a href="adminWelcome.jsp">Back to Admin Dashboard</a></p>

    <form method="get" action="revenueSummary.jsp">
        View Revenue By: 
        <select name="type" required>
            <option value="">--Select--</option>
            <option value="flight" <%= "flight".equals(reportType) ? "selected" : "" %>>Flight</option>
            <option value="airline" <%= "airline".equals(reportType) ? "selected" : "" %>>Airline</option>
            <option value="customer" <%= "customer".equals(reportType) ? "selected" : "" %>>Customer</option>
        </select>
        <input type="submit" value="Generate">
    </form>

<%
    if (reportType != null && !reportType.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airlineproj", "root", "parshva123");

            String sql = "";
            String topSql = "";

            if ("flight".equals(reportType)) {
                sql = "SELECT f.flightNum AS label, SUM(ft.totalFare) AS revenue " +
                      "FROM FlightTicket ft JOIN Flight f ON ft.flightID = f.flightID " +
                      "GROUP BY f.flightNum";

                topSql = "SELECT f.flightNum AS topLabel, SUM(ft.totalFare) AS topRevenue " +
                         "FROM FlightTicket ft JOIN Flight f ON ft.flightID = f.flightID " +
                         "GROUP BY f.flightNum ORDER BY topRevenue DESC LIMIT 1";
            } else if ("airline".equals(reportType)) {
                sql = "SELECT al.name AS label, SUM(ft.totalFare) AS revenue " +
                      "FROM FlightTicket ft " +
                      "JOIN Flight f ON ft.flightID = f.flightID " +
                      "JOIN Airline al ON f.airlineID = al.airlineID " +
                      "GROUP BY al.name";
            } else if ("customer".equals(reportType)) {
                sql = "SELECT CONCAT(u.firstName, ' ', u.lastName) AS label, SUM(ft.totalFare) AS revenue " +
                      "FROM FlightTicket ft " +
                      "JOIN CustomerAccount ca ON ft.accountID = ca.accountID " +
                      "JOIN User u ON ca.userID = u.userID " +
                      "GROUP BY u.userID";

                topSql = "SELECT CONCAT(u.firstName, ' ', u.lastName) AS topLabel, SUM(ft.totalFare) AS topRevenue " +
                         "FROM FlightTicket ft " +
                         "JOIN CustomerAccount ca ON ft.accountID = ca.accountID " +
                         "JOIN User u ON ca.userID = u.userID " +
                         "GROUP BY u.userID ORDER BY topRevenue DESC LIMIT 1";
            }

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (!topSql.isEmpty()) {
                topStmt = conn.prepareStatement(topSql);
                topRs = topStmt.executeQuery();
                if (topRs.next()) {
                    topLabel = topRs.getString("topLabel");
                    topRevenue = topRs.getDouble("topRevenue");
                }
            }
%>

    <h3>Revenue Summary by <%= reportType.substring(0, 1).toUpperCase() + reportType.substring(1) %>:</h3>
    <table border="1">
        <tr>
            <th><%= reportType.substring(0, 1).toUpperCase() + reportType.substring(1) %></th>
            <th>Total Revenue</th>
        </tr>
        <%
            boolean hasResults = false;
            while(rs.next()) {
                hasResults = true;
        %>
        <tr>
            <td><%= rs.getString("label") %></td>
            <td>$<%= rs.getDouble("revenue") %></td>
        </tr>
        <%
            }
            if (!hasResults) {
        %>
        <tr><td colspan="2">No data available.</td></tr>
        <%
            }
        %>
    </table>

    <%
        if ("customer".equals(reportType) && topLabel != null && !topLabel.isEmpty()) {
    %>
        <h4>Top Customer:</h4>
        <p><strong><%= topLabel %></strong> with Total Revenue: $<%= topRevenue %></p>
    <%
        } else if ("flight".equals(reportType) && topLabel != null && !topLabel.isEmpty()) {
    %>
        <h4>Most Active Flight:</h4>
        <p><strong>Flight <%= topLabel %></strong> with Total Revenue: $<%= topRevenue %></p>
    <%
        }
    %>

<%
        } catch(Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if(topRs != null) try { topRs.close(); } catch(Exception e) {}
            if(topStmt != null) try { topStmt.close(); } catch(Exception e) {}
            if(rs != null) try { rs.close(); } catch(Exception e) {}
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    }
%>

</body>
</html>
