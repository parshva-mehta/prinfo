<%@ page import="java.sql.*" %>
<%
    String name = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (name == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    String dbUrl = "jdbc:mysql://localhost:3306/airlineproj";
    String dbUser = "root";
    String dbPass = "parshva123";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head><title>Manage Users</title></head>
<body>
    <h2>Manage Customers & Representatives</h2>
    <p><a href="adminWelcome.jsp">Back to Admin Dashboard</a></p>

    <h3>All Users</h3>
    <table border="1">
        <tr>
            <th>UserID</th>
            <th>Email</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Role</th>
            <th>Actions</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

                String sql = "SELECT * FROM User WHERE role IN ('customer', 'representative')";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("userID") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("firstName") %></td>
            <td><%= rs.getString("lastName") %></td>
            <td><%= rs.getString("role") %></td>
            <td>
                <a href="editUser.jsp?userID=<%= rs.getInt("userID") %>">Edit</a> |
                <a href="deleteUser.jsp?userID=<%= rs.getInt("userID") %>" onclick="return confirm('Are you sure?');">Delete</a>
            </td>
        </tr>
        <%
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
    </table>

    <h3>Add New User</h3>
    <form action="addUser.jsp" method="post">
        Email: <input type="email" name="email" required><br>
        Password: <input type="password" name="password" required><br>
        First Name: <input type="text" name="firstName" required><br>
        Last Name: <input type="text" name="lastName" required><br>
        Role: 
        <select name="role">
            <option value="customer">Customer</option>
            <option value="representative">Representative</option>
        </select><br>
        <input type="submit" value="Add User">
    </form>

</body>
</html>
