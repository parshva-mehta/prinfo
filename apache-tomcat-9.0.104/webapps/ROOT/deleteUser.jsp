<%@ page import="java.sql.*" %>
<%
    String name = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (name == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    String userID = request.getParameter("userID");

    String dbUrl = "jdbc:mysql://localhost:3306/airlineproj";
    String dbUser = "root";
    String dbPass = "parshva123";

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        String deleteSql = "DELETE FROM User WHERE userID = ?";
        pstmt = conn.prepareStatement(deleteSql);
        pstmt.setInt(1, Integer.parseInt(userID));
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            out.println("<p>User deleted successfully!</p>");
        } else {
            out.println("<p>User not found or already deleted.</p>");
        }

        response.setHeader("Refresh", "2; URL=manageUsers.jsp");

    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
