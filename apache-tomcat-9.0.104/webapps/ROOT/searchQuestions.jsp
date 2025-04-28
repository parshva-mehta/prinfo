<%@ page import="java.sql.*" %>
<%
    String keyword = request.getParameter("keyword");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head><title>Search Questions</title></head>
<body>
    <h2>Search Questions</h2>
    <form method="get" action="searchQuestions.jsp">
        Keyword: <input type="text" name="keyword" value="<%= keyword != null ? keyword : "" %>">
        <input type="submit" value="Search">
    </form>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/airlineproj", "root", "parshva123");

        String sql;
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql = "SELECT q.questionID, q.questionText, q.answerText FROM Question q WHERE q.questionText LIKE ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
        } else {
            sql = "SELECT q.questionID, q.questionText, q.answerText FROM Question q";
            pstmt = conn.prepareStatement(sql);
        }

        rs = pstmt.executeQuery();
%>

    <h3>Questions:</h3>
    <ul>
        <%
            boolean hasResults = false;
            while(rs.next()) {
                hasResults = true;
                String question = rs.getString("questionText");
                String answer = rs.getString("answerText");
        %>
            <li>
                <strong>Question:</strong> <%= question %><br>
                <strong>Answer:</strong>
                <% if (answer != null && !answer.trim().isEmpty()) { %>
                    <%= answer %>
                <% } else { %>
                    <i>Not answered yet</i>
                <% } %>
            </li><br>
        <%
            }
            if (!hasResults) {
        %>
            <li>No questions found.</li>
        <%
            }
        %>
    </ul>

<%
    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }
%>

    <p><a href="customerSupport.jsp">Back to Customer Support</a></p>
    <p><a href="welcome.jsp">Back to Home</a></p>
</body>
</html>