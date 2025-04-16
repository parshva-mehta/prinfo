<!DOCTYPE html>
<html>
<head><title>Login Page</title></head>
<body>
  <h2>Login</h2>
  <form action="verify.jsp" method="post">
    Username: <input type="text" name="username" required><br><br>
    Password: <input type="password" name="password" required><br><br>
    <input type="submit" value="Login">
  </form>
  <%
    if (request.getParameter("error") != null) {
      out.println("<p style='color:red;'>Invalid login. Please try again.</p>");
    }
  %>
</body>
</html>