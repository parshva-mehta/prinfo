<%@ page import="java.sql.*" %>
<%
    String repName = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (repName == null || !"representative".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    String dbUrl = "jdbc:mysql://localhost:3306/airlineproj";
    String dbUser = "root";
    String dbPass = "parshva123";

    Connection conn = null;
    PreparedStatement questionStmt = null;
    ResultSet questionRs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // Fetch ALL questions
        String questionSql = "SELECT questionID, questionText, answerText FROM Question";
        questionStmt = conn.prepareStatement(questionSql);
        questionRs = questionStmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Questions</title>
</head>
<body>
    <h2>Edit All Questions</h2>
    <p><a href="repWelcome.jsp">Back to Dashboard</a></p>

    <form method="post" action="repReplyQuestionsSubmit.jsp">
        <% while(questionRs.next()) {
            int questionID = questionRs.getInt("questionID");
            String questionText = questionRs.getString("questionText");
            String answerText = questionRs.getString("answerText");
        %>
            <div style="border:1px solid #ccc; padding:10px; margin:10px 0;">
                <strong>Question #<%= questionID %>:</strong><br>
                <p><%= questionText %></p>

                <label for="answer_<%= questionID %>">Answer:</label><br>
                <textarea name="answer_<%= questionID %>" rows="3" cols="50"><%= answerText != null ? answerText : "" %></textarea><br><br>
            </div>
        <% } %>

        <input type="submit" value="Submit All Answers">
    </form>

</body>
</html>

<%
    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if(questionRs != null) try { questionRs.close(); } catch(Exception e) {}
        if(questionStmt != null) try { questionStmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>
