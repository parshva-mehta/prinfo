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
%>

<!DOCTYPE html>
<html>
<head>
    <title>Make Reservation for Customer</title>
    <script>
        const flightFares = {};

        function updateFare() {
            const flightSelect = document.getElementById("flightSelect");
            const selectedFlight = flightSelect.value;
            const fareField = document.getElementById("fareField");
            const totalFareField = document.getElementById("totalFare");
            const seatClassSelect = document.getElementById("seatClass");

            if (selectedFlight && flightFares[selectedFlight]) {
                let baseFare = flightFares[selectedFlight];
                fareField.value = baseFare;
                // Trigger recalculation of total fare
                calculateTotalFare();
            } else {
                fareField.value = '';
                totalFareField.value = '';
            }
        }

        function calculateTotalFare() {
            const baseFare = parseFloat(document.getElementById("fareField").value);
            const seatClass = document.getElementById("seatClass").value;
            const totalFareField = document.getElementById("totalFare");

            let multiplier = 1.0;
            if (seatClass === "Business") {
                multiplier = 1.2;
            } else if (seatClass === "First") {
                multiplier = 1.5;
            }

            if (!isNaN(baseFare)) {
                let totalFare = baseFare * multiplier;
                totalFareField.value = totalFare.toFixed(2);
            } else {
                totalFareField.value = '';
            }
        }
    </script>
</head>
<body>
    <h2>Book a Flight for Customer</h2>
    <p><a href="repWelcome.jsp">Back to Dashboard</a></p>

    <form method="post" action="repMakeReservationSubmit.jsp">
        <label>Select Customer:</label>
        <select name="accountID" required>
            <option value="">--Select--</option>
            <%
                while(customerRs.next()) {
            %>
            <option value="<%= customerRs.getInt("accountID") %>">
                <%= customerRs.getString("firstName") %> <%= customerRs.getString("lastName") %>
            </option>
            <%
                }
            %>
        </select><br><br>

        <label>Select Flight:</label>
        <select name="flightID" id="flightSelect" onchange="updateFare()" required>
            <option value="">--Select--</option>
            <%
                while(flightRs.next()) {
                    int flightId = flightRs.getInt("flightID");
                    String flightNum = flightRs.getString("flightNum");
                    double baseFare = flightRs.getDouble("baseFare");
            %>
            <option value="<%= flightId %>">
                Flight <%= flightNum %> - $<%= baseFare %>
            </option>
            <script>
                flightFares["<%= flightId %>"] = <%= baseFare %>;
            </script>
            <%
                }
            %>
        </select><br><br>

        Base Fare: <input type="text" id="fareField" readonly><br><br>

        Seat: <input type="text" name="seat" required><br><br>

        Class: 
        <select name="class" id="seatClass" onchange="calculateTotalFare()" required>
            <option value="Economy">Economy</option>
            <option value="Business">Business (+20%)</option>
            <option value="First">First (+50%)</option>
        </select><br><br>

        Total Fare: <input type="number" id="totalFare" name="totalFare" step="0.01" readonly required><br><br>

        <input type="submit" value="Book Flight">
    </form>

</body>
</html>

<%
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
%>
