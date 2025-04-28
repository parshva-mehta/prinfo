<%@ page import="java.sql.*" %>
<%
    String name = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (name == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    String searchFlight = request.getParameter("flightNum");
    String searchCustomer = request.getParameter("customerName");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head><title>Reservations Report</title></head>
<body>
    <h2>Reservations Report</h2>
    <p><a href="adminWelcome.jsp">Back to Admin Dashboard</a></p>

    <form method="get" action="reservationsReport.jsp">
        Search by Flight Number: <input type="text" name="flightNum" value="<%= searchFlight != null ? searchFlight : "" %>">
        <br>
        Search by Customer Name: <input type="text" name="customerName" value="<%= searchCustomer != null ? searchCustomer : "" %>">
        <br>
        <input type="submit" value="Search Reservations">
    </form>

<%
    if ((searchFlight != null && !searchFlight.trim().isEmpty()) || (searchCustomer != null && !searchCustomer.trim().isEmpty())) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airlineproj", "root", "parshva123");

            String sql = "SELECT f.flightNum, u.firstName, u.lastName, ft.seat, ft.class, ft.totalFare " +
                         "FROM FlightTicket ft " +
                         "JOIN Flight f ON ft.flightID = f.flightID " +
                         "JOIN CustomerAccount ca ON ft.accountID = ca.accountID " +
                         "JOIN User u ON ca.userID = u.userID " +
                         "WHERE 1=1 ";

            if (searchFlight != null && !searchFlight.trim().isEmpty()) {
                sql += "AND f.flightNum LIKE ? ";
            }
            if (searchCustomer != null && !searchCustomer.trim().isEmpty()) {
                sql += "AND CONCAT(u.firstName, ' ', u.lastName) LIKE ? ";
            }

            pstmt = conn.prepareStatement(sql);

            int paramIndex = 1;
            if (searchFlight != null && !searchFlight.trim().isEmpty()) {
                pstmt.setString(paramIndex++, "%" + searchFlight + "%");
            }
            if (searchCustomer != null && !searchCustomer.trim().isEmpty()) {
                pstmt.setString(paramIndex++, "%" + searchCustomer + "%");
            }

            rs = pstmt.executeQuery();
%>

    <h3>Search Results:</h3>
    <table border="1">
        <tr>
            <th>Flight Number</th>
            <th>Customer Name</th>
            <th>Seat</th>
            <th>Class</th>
            <th>Total Fare</th>
        </tr>
        <%
            boolean hasResults = false;
            while(rs.next()) {
                hasResults = true;
        %>
        <tr>
            <td><%= rs.getString("flightNum") %></td>
            <td><%= rs.getString("firstName") %> <%= rs.getString("lastName") %></td>
            <td><%= rs.getString("seat") %></td>
            <td><%= rs.getString("class") %></td>
            <td>$<%= rs.getDouble("totalFare") %></td>
        </tr>
        <%
            }
            if (!hasResults) {
        %>
        <tr><td colspan="5">No reservations found.</td></tr>
        <%
            }
        %>
    </table>

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
