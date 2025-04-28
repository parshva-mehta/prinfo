<%@ page import="java.sql.*" %>
<%
    String ticketNum = request.getParameter("ticketNum");
    String firstName = (String) session.getAttribute("firstName");
    if (firstName == null) {
        response.sendRedirect("index.jsp");
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airlineproj", "root", "parshva123");

        // Verify class before deletion
        String verifySql = "SELECT class FROM FlightTicket WHERE ticketNum = ?";
        pstmt = conn.prepareStatement(verifySql);
        pstmt.setInt(1, Integer.parseInt(ticketNum));
        rs = pstmt.executeQuery();

        if(rs.next()) {
            String classType = rs.getString("class");
            if(classType.equals("Business") || classType.equals("First")) {
                rs.close();
                pstmt.close();

                // Proceed to delete
                String deleteSql = "DELETE FROM FlightTicket WHERE ticketNum = ?";
                pstmt = conn.prepareStatement(deleteSql);
                pstmt.setInt(1, Integer.parseInt(ticketNum));
                pstmt.executeUpdate();
%>

<!DOCTYPE html>
<html>
<head><title>Reservation Canceled</title></head>
<body>
    <h2>Reservation Successfully Canceled</h2>
    <p>Ticket #: <%= ticketNum %></p>
    <p><a href="myReservations.jsp">Back to My Reservations</a></p>
</body>
</html>

<%
            } else {
%>
<!DOCTYPE html>
<html>
<head><title>Cancellation Not Allowed</title></head>
<body>
    <h2>Cancellation Not Allowed</h2>
    <p>You can only cancel Business or First class tickets.</p>
    <p><a href="myReservations.jsp">Back to My Reservations</a></p>
</body>
</html>
<%
            }
        } else {
            out.println("<p>Reservation not found.</p>");
        }
    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
