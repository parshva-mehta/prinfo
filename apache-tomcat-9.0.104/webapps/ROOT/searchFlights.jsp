<form action="flightResults.jsp" method="get">
    Departure Airport: <input type="text" name="departureAirport" required><br><br>
    Arrival Airport: <input type="text" name="arrivalAirport" required><br><br>

    Departure Date: <input type="date" name="departureDate" required><br><br>
    Arrival Date (if Round-Trip): <input type="date" name="arrivalDate"><br><br>

    Flexible Dates (+/- 3 days)? 
    <input type="checkbox" name="flexibleDates" value="yes"><br><br>

    Trip Type: 
    <input type="radio" name="tripType" value="oneway" checked> One-Way
    <input type="radio" name="tripType" value="roundtrip"> Round-Trip<br><br>

    <input type="submit" value="Search Flights">
</form>