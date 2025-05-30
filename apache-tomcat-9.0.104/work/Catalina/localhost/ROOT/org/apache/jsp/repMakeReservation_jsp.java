/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/9.0.104
 * Generated at: 2025-04-28 21:12:03 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;

public final class repMakeReservation_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.LinkedHashSet<>(6);
    _jspx_imports_packages.add("java.sql");
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = null;
  }

  private volatile javax.el.ExpressionFactory _el_expressionfactory;
  private volatile org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public java.util.Set<java.lang.String> getPackageImports() {
    return _jspx_imports_packages;
  }

  public java.util.Set<java.lang.String> getClassImports() {
    return _jspx_imports_classes;
  }

  public javax.el.ExpressionFactory _jsp_getExpressionFactory() {
    if (_el_expressionfactory == null) {
      synchronized (this) {
        if (_el_expressionfactory == null) {
          _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
        }
      }
    }
    return _el_expressionfactory;
  }

  public org.apache.tomcat.InstanceManager _jsp_getInstanceManager() {
    if (_jsp_instancemanager == null) {
      synchronized (this) {
        if (_jsp_instancemanager == null) {
          _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
        }
      }
    }
    return _jsp_instancemanager;
  }

  public void _jspInit() {
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
      throws java.io.IOException, javax.servlet.ServletException {

    if (!javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
      final java.lang.String _jspx_method = request.getMethod();
      if ("OPTIONS".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        return;
      }
      if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSPs only permit GET, POST or HEAD. Jasper also permits OPTIONS");
        return;
      }
    }

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write('\n');

    String repName = (String) session.getAttribute("firstName");
    String role = (String) session.getAttribute("role");

    if (repName == null || !"representative".equalsIgnoreCase(role)) {
        response.sendRedirect("index.jsp");
    }

    String dbUrl = "jdbc:mysql://localhost:3306/airlineproj";
    String dbUser = "root";
    String dbPass = "parshva123";

    Connection conn = null;
    PreparedStatement flightStmt = null;
    PreparedStatement customerStmt = null;
    ResultSet flightRs = null;
    ResultSet customerRs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // Fetch flights WITH baseFare
        String flightSql = "SELECT flightID, flightNum, baseFare FROM Flight";
        flightStmt = conn.prepareStatement(flightSql);
        flightRs = flightStmt.executeQuery();

        // Fetch customers
        String customerSql = "SELECT ca.accountID, u.firstName, u.lastName FROM CustomerAccount ca JOIN User u ON ca.userID = u.userID";
        customerStmt = conn.prepareStatement(customerSql);
        customerRs = customerStmt.executeQuery();

      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("    <title>Make Reservation for Customer</title>\n");
      out.write("    <script>\n");
      out.write("        const flightFares = {};\n");
      out.write("\n");
      out.write("        function updateFare() {\n");
      out.write("            const flightSelect = document.getElementById(\"flightSelect\");\n");
      out.write("            const selectedFlight = flightSelect.value;\n");
      out.write("            const fareField = document.getElementById(\"fareField\");\n");
      out.write("            const totalFareField = document.getElementById(\"totalFare\");\n");
      out.write("            const seatClassSelect = document.getElementById(\"seatClass\");\n");
      out.write("\n");
      out.write("            if (selectedFlight && flightFares[selectedFlight]) {\n");
      out.write("                let baseFare = flightFares[selectedFlight];\n");
      out.write("                fareField.value = baseFare;\n");
      out.write("                // Trigger recalculation of total fare\n");
      out.write("                calculateTotalFare();\n");
      out.write("            } else {\n");
      out.write("                fareField.value = '';\n");
      out.write("                totalFareField.value = '';\n");
      out.write("            }\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        function calculateTotalFare() {\n");
      out.write("            const baseFare = parseFloat(document.getElementById(\"fareField\").value);\n");
      out.write("            const seatClass = document.getElementById(\"seatClass\").value;\n");
      out.write("            const totalFareField = document.getElementById(\"totalFare\");\n");
      out.write("\n");
      out.write("            let multiplier = 1.0;\n");
      out.write("            if (seatClass === \"Business\") {\n");
      out.write("                multiplier = 1.2;\n");
      out.write("            } else if (seatClass === \"First\") {\n");
      out.write("                multiplier = 1.5;\n");
      out.write("            }\n");
      out.write("\n");
      out.write("            if (!isNaN(baseFare)) {\n");
      out.write("                let totalFare = baseFare * multiplier;\n");
      out.write("                totalFareField.value = totalFare.toFixed(2);\n");
      out.write("            } else {\n");
      out.write("                totalFareField.value = '';\n");
      out.write("            }\n");
      out.write("        }\n");
      out.write("    </script>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("    <h2>Book a Flight for Customer</h2>\n");
      out.write("    <p><a href=\"repWelcome.jsp\">Back to Dashboard</a></p>\n");
      out.write("\n");
      out.write("    <form method=\"post\" action=\"repMakeReservationSubmit.jsp\">\n");
      out.write("        <label>Select Customer:</label>\n");
      out.write("        <select name=\"accountID\" required>\n");
      out.write("            <option value=\"\">--Select--</option>\n");
      out.write("            ");

                while(customerRs.next()) {
            
      out.write("\n");
      out.write("            <option value=\"");
      out.print( customerRs.getInt("accountID") );
      out.write("\">\n");
      out.write("                ");
      out.print( customerRs.getString("firstName") );
      out.write(' ');
      out.print( customerRs.getString("lastName") );
      out.write("\n");
      out.write("            </option>\n");
      out.write("            ");

                }
            
      out.write("\n");
      out.write("        </select><br><br>\n");
      out.write("\n");
      out.write("        <label>Select Flight:</label>\n");
      out.write("        <select name=\"flightID\" id=\"flightSelect\" onchange=\"updateFare()\" required>\n");
      out.write("            <option value=\"\">--Select--</option>\n");
      out.write("            ");

                while(flightRs.next()) {
                    int flightId = flightRs.getInt("flightID");
                    String flightNum = flightRs.getString("flightNum");
                    double baseFare = flightRs.getDouble("baseFare");
            
      out.write("\n");
      out.write("            <option value=\"");
      out.print( flightId );
      out.write("\">\n");
      out.write("                Flight ");
      out.print( flightNum );
      out.write(" - $");
      out.print( baseFare );
      out.write("\n");
      out.write("            </option>\n");
      out.write("            <script>\n");
      out.write("                flightFares[\"");
      out.print( flightId );
      out.write("\"] = ");
      out.print( baseFare );
      out.write(";\n");
      out.write("            </script>\n");
      out.write("            ");

                }
            
      out.write("\n");
      out.write("        </select><br><br>\n");
      out.write("\n");
      out.write("        Base Fare: <input type=\"text\" id=\"fareField\" readonly><br><br>\n");
      out.write("\n");
      out.write("        Seat: <input type=\"text\" name=\"seat\" required><br><br>\n");
      out.write("\n");
      out.write("        Class: \n");
      out.write("        <select name=\"class\" id=\"seatClass\" onchange=\"calculateTotalFare()\" required>\n");
      out.write("            <option value=\"Economy\">Economy</option>\n");
      out.write("            <option value=\"Business\">Business (+20%)</option>\n");
      out.write("            <option value=\"First\">First (+50%)</option>\n");
      out.write("        </select><br><br>\n");
      out.write("\n");
      out.write("        Total Fare: <input type=\"number\" id=\"totalFare\" name=\"totalFare\" step=\"0.01\" readonly required><br><br>\n");
      out.write("\n");
      out.write("        <input type=\"submit\" value=\"Book Flight\">\n");
      out.write("    </form>\n");
      out.write("\n");
      out.write("</body>\n");
      out.write("</html>\n");
      out.write("\n");

    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if(flightRs != null) try { flightRs.close(); } catch(Exception e) {}
        if(customerRs != null) try { customerRs.close(); } catch(Exception e) {}
        if(flightStmt != null) try { flightStmt.close(); } catch(Exception e) {}
        if(customerStmt != null) try { customerStmt.close(); } catch(Exception e) {}
        if(conn != null) try { conn.close(); } catch(Exception e) {}
    }

      out.write('\n');
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
