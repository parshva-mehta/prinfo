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
    ResultSet rs = null;

    String email = "", firstName = "", lastName = "", userRole = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Handle update form submission
        email = request.getParameter("email");
        firstName = request.getParameter("firstName");
        lastName = request.getParameter("lastName");
        userRole = request.getParameter("role");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            String updateSql = "UPDATE User SET email = ?, firstName = ?, lastName = ?, role = ? WHERE userID = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, email);
            pstmt.setString(2, firstName);
            pstmt.setString(3, lastName);
            pstmt.setString(4, userRole);
            pstmt.setInt(5, Integer.parseInt(userID));
            pstmt.executeUpdate();

            out.println("<p>User updated successfully!</p>");
            response.setHeader("Refresh", "2; URL=manageUsers.jsp");

        } catch(Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    } else {
        // Load user data for editing
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            String sql = "SELECT * FROM User WHERE userID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(userID));
            rs = pstmt.executeQuery();

            if(rs.next()) {
                email = rs.getString("email");
                firstName = rs.getString("firstName");
                lastName = rs.getString("lastName");
                userRole = rs.getString("role");
            } else {
                out.println("<p>User not found.</p>");
            }

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

<!DOCTYPE html>
<html>
<head><title>Edit User</title></head>
<body>
    <h2>Edit User</h2>

    <form method="post" action="editUser.jsp?userID=<%= userID %>">
        Email: <input type="email" name="email" value="<%= email %>" required><br>
        First Name: <input type="text" name="firstName" value="<%= firstName %>" required><br>
        Last Name: <input type="text" name="lastName" value="<%= lastName %>" required><br>
        Role: 
        <select name="role">
            <option value="customer" <%= "customer".equals(userRole) ? "selected" : "" %>>Customer</option>
            <option value="representative" <%= "representative".equals(userRole) ? "selected" : "" %>>Representative</option>
        </select><br>
        <input type="submit" value="Update User">
    </form>

    <p><a href="manageUsers.jsp">Back to User Management</a></p>
</body>
</html>
