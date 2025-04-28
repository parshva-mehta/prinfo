<%@ page import="java.sql.*" %>
<%
    String firstName = (String) session.getAttribute("firstName");
    if (firstName == null) {
        response.sendRedirect("index.jsp");
    }

    int accountID = 1; // Replace with session accountID if available

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String questionText = request.getParameter("questionText");
        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement createQ = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airlineproj", "root", "parshva123");

            // Insert questionText into Question table
            String createQuestionSql = "INSERT INTO Question (questionText) VALUES (?)";
            createQ = conn.prepareStatement(createQuestionSql, Statement.RETURN_GENERATED_KEYS);
            createQ.setString(1, questionText);
            createQ.executeUpdate();
            ResultSet rs = createQ.getGeneratedKeys();
            int questionID = 0;
            if (rs.next()) {
                questionID = rs.getInt(1);
            }

            // Link to CustomerAccountQuestion
            String sql = "INSERT INTO CustomerAccountQuestion (accountID, questionID) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, accountID);
            pstmt.setInt(2, questionID);
            pstmt.executeUpdate();

            out.println("<p>Question submitted successfully!</p>");
        } catch(Exception e) {
            //out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if(createQ != null) try { createQ.close(); } catch(Exception e) {}
            if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if(conn != null) try { conn.close(); } catch(Exception e) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head><title>Customer Support</title></head>
<body>
    <h2>Ask a Question</h2>
    <form method="post" action="customerSupport.jsp">
        Question: <textarea name="questionText" rows="4" cols="50" required></textarea><br>
        <input type="submit" value="Send Question">
    </form>

    <p><a href="searchQuestions.jsp">Search Questions</a></p>
    <p><a href="welcome.jsp">Back to Home</a></p>
</body>
</html>
