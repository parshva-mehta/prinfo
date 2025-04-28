<%@ page import="java.sql.*" %>
<%
    String name = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (name == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    String selectedMonth = request.getParameter("month"); // format: YYYY-MM
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    double totalRevenue = 0;
    int totalTickets = 0;
%>

<!DOCTYPE html>
<html>
<head><title>Sales Report</title></head>
<body>
    <h2>Sales Report by Month</h2>
    <p><a href="adminWelcome.jsp">Back to Admin Dashboard</a></p>

    <form method="get" action="salesReport.jsp">
        Select Month: <input type="month" name="month" value="<%= selectedMonth != null ? selectedMonth : "" %>" required>
        <input type="submit" value="Generate Report">
    </form>

<%
    if (selectedMonth != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airlineproj", "root", "parshva123");

            // Query for total revenue and tickets sold
            String sql = "SELECT COUNT(*) AS ticketCount, SUM(totalFare) AS totalRevenue " +
                         "FROM FlightTicket " +
                         "WHERE MONTH(purchaseDateTime) = MONTH(?) AND YEAR(purchaseDateTime) = YEAR(?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, selectedMonth + "-01"); // Append day for DATE format
            pstmt.setString(2, selectedMonth + "-01");
            rs = pstmt.executeQuery();

            if (rs.next()) {
                totalTickets = rs.getInt("ticketCount");
                totalRevenue = rs.getDouble("totalRevenue");
            }
%>

    <h3>Report for <%= selectedMonth %>:</h3>
    <p>Total Tickets Sold: <%= totalTickets %></p>
    <p>Total Revenue: $<%= totalRevenue %></p>

<%
        } catch(Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception e) {}
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    }
%>

</body>
</html>
