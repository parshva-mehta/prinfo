<%@ page import="java.sql.*, java.util.*" %>
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
    PreparedStatement updateStmt = null;

    int updatedCount = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // Get all parameters and update answers
        Enumeration<String> paramNames = request.getParameterNames();
        String updateSql = "UPDATE Question SET answerText = ? WHERE questionID = ?";

        updateStmt = conn.prepareStatement(updateSql);

        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();

            if (paramName.startsWith("answer_")) {
                String questionIDStr = paramName.substring(7); // "answer_" length is 7
                String answerText = request.getParameter(paramName);

                if (questionIDStr != null && answerText != null) {
                    int questionID = Integer.parseInt(questionIDStr);

                    updateStmt.setString(1, answerText.trim());
                    updateStmt.setInt(2, questionID);
                    int rows = updateStmt.executeUpdate();

                    if (rows > 0) {
                        updatedCount++;
                    }
                }
            }
        }

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (updateStmt != null) try { updateStmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reply Submission Result</title>
</head>
<body>
    <h2>Reply Submission Status</h2>
    <p>Replies submitted successfully for <%= updatedCount %> question(s).</p>
    <p><a href="repReplyQuestions.jsp">Edit More Questions</a></p>
    <p><a href="repWelcome.jsp">Back to Dashboard</a></p>
</body>
</html>
