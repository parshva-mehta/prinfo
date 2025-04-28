<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
    String message = "";

    // Handle form submission
    if(request.getParameter("email") != null) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airlineproj", "root", "parshva123");

            String sql = "INSERT INTO User (email, password, firstName, lastName) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            pstmt.setString(3, firstName);
            pstmt.setString(4, lastName);

            int rows = pstmt.executeUpdate();
            if(rows > 0) {
                message = "Registration successful! <a href='index.jsp'>Login here</a>.";
            } else {
                message = "Registration failed. Please try again.";
            }
        } catch(Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        } finally {
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
</head>
<body>
    <h2>User Registration</h2>
    <% if(!message.equals("")) { %>
        <p><%= message %></p>
    <% } %>
    <form method="post" action="register.jsp">
        Email: <input type="email" name="email" required><br>
        Password: <input type="password" name="password" required><br>
        First Name: <input type="text" name="firstName" required><br>
        Last Name: <input type="text" name="lastName" required><br>
        <input type="submit" value="Register">
    </form>
    <p>Already have an account? <a href="index.jsp">Login here</a>.</p>
</body>
</html>