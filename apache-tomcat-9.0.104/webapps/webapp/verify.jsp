
<%@ page import="java.sql.*" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    String dbUrl = "jdbc:mysql://localhost:3306/airlineproj";
    String dbUser = "root";
    String dbPass = "parshva123"; // change this

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        String sql = "SELECT * FROM User WHERE email = ? AND password = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, email);
        stmt.setString(2, password);
        rs = stmt.executeQuery();

        if (rs.next()) {
            String firstName = rs.getString("firstName");
            session.setAttribute("email", email);
            session.setAttribute("firstName", firstName);
            response.sendRedirect("welcome.jsp");
        } else {
            out.println("<p style='color:red;'>Login failed. Invalid credentials.</p>");
        }
    } catch (Exception e) {
        out.println("Database error: " + e.getMessage());
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
