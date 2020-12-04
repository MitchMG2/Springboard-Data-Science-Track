/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you:
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1.

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface.
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT *
FROM `Facilities`
WHERE `membercost` >0

/*
facid	name	membercost	guestcost	initialoutlay	monthlymaintenance
0	Tennis Court 1	5.0	25.0	10000	200
1	Tennis Court 2	5.0	25.0	8000	200
4	Massage Room 1	9.9	80.0	4000	3000
5	Massage Room 2	9.9	80.0	4000	3000
6	Squash Court	3.5	17.5	5000	80
*/

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT( `membercost` )
FROM `Facilities`
WHERE `membercost` >0

/*
COUNT(`membercost`)
5
*/


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT `facid` , `name` , `membercost` , `monthlymaintenance`
FROM `Facilities`
WHERE `membercost` < 0.2 * `monthlymaintenance`

/*
facid	name	membercost	monthlymaintenance
0	Tennis Court 1	5.0	200
1	Tennis Court 2	5.0	200
2	Badminton Court	0.0	50
3	Table Tennis	0.0	10
4	Massage Room 1	9.9	3000
5	Massage Room 2	9.9	3000
6	Squash Court	3.5	80
7	Snooker Table	0.0	15
8	Pool Table	0.0	15
*/

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM `Facilities`
WHERE `facid`
IN ( 1, 5 )
LIMIT 0 , 30

/*
facid	name	membercost	guestcost	initialoutlay	monthlymaintenance
1	Tennis Court 2	5.0	25.0	8000	200
5	Massage Room 2	9.9	80.0	4000	3000
*/

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT `name` , `monthlymaintenance` ,
CASE WHEN `monthlymaintenance` <100
THEN 'cheap'
WHEN `monthlymaintenance` >100
THEN 'expensive'
END AS 'cheapexpensive'
FROM `Facilities`
LIMIT 0 , 30

/*
name	monthlymaintenance	cheapexpensive
Tennis Court 1	200	expensive
Tennis Court 2	200	expensive
Badminton Court	50	cheap
Table Tennis	10	cheap
Massage Room 1	3000	expensive
Massage Room 2	3000	expensive
Squash Court	80	cheap
Snooker Table	15	cheap
Pool Table	15	cheap
*/

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT `firstname` , `surname`
FROM `Members`
WHERE `joindate` = (
SELECT MAX( `joindate` )
FROM `Members` )

/*
firstname	surname
Darren	Smith
*/

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT CONCAT( `firstname` , ' ', `surname` ) AS Full_name, Facilities.name AS Tennis_Court
FROM `Members`
INNER JOIN `Bookings` ON Bookings.memid = Members.memid
INNER JOIN Facilities ON Facilities.facid = Bookings.facid
WHERE (
Bookings.facid =0
OR Bookings.facid =1
)
ORDER BY Full_Name
LIMIT 0 , 60

/*
Full_name	Tennis_Court
Anne Baker	Tennis Court 2
Anne Baker	Tennis Court 1
Burton Tracy	Tennis Court 1
Burton Tracy	Tennis Court 2
Charles Owen	Tennis Court 2
Charles Owen	Tennis Court 1
Darren Smith	Tennis Court 2
David Farrell	Tennis Court 2
David Farrell	Tennis Court 1
David Jones	Tennis Court 2
David Jones	Tennis Court 1
David Pinker	Tennis Court 1
Douglas Jones	Tennis Court 1
Erica Crumpet	Tennis Court 1
Florence Bader	Tennis Court 2
Florence Bader	Tennis Court 1
Gerald Butters	Tennis Court 2
Gerald Butters	Tennis Court 1
GUEST GUEST	Tennis Court 1
GUEST GUEST	Tennis Court 2
Henrietta Rumney	Tennis Court 2
Jack Smith	Tennis Court 2
Jack Smith	Tennis Court 1
Janice Joplette	Tennis Court 1
Janice Joplette	Tennis Court 2
Jemima Farrell	Tennis Court 1
Jemima Farrell	Tennis Court 2
Joan Coplin	Tennis Court 1
John Hunt	Tennis Court 2
John Hunt	Tennis Court 1
Matthew Genting	Tennis Court 1
Millicent Purview	Tennis Court 2
Nancy Dare	Tennis Court 1
Nancy Dare	Tennis Court 2
Ponder Stibbons	Tennis Court 1
Ponder Stibbons	Tennis Court 2
Ramnaresh Sarwin	Tennis Court 1
Ramnaresh Sarwin	Tennis Court 2
Tim Boothe	Tennis Court 2
Tim Boothe	Tennis Court 1
Tim Rownam	Tennis Court 1
Tim Rownam	Tennis Court 2
Timothy Baker	Tennis Court 2
Timothy Baker	Tennis Court 1
Tracy Smith	Tennis Court 1
Tracy Smith	Tennis Court 2
*/

/* However, if name cannot be repeated regardless of court used, then

SELECT DISTINCT CONCAT( `firstname` , ' ', `surname` ) AS Full_name, Facilities.name AS Tennis_Court
FROM `Members`
INNER JOIN `Bookings` ON Bookings.memid = Members.memid
INNER JOIN Facilities ON Facilities.facid = Bookings.facid
WHERE (
Bookings.facid =0
OR Bookings.facid =1
)
GROUP BY Full_Name
ORDER BY Full_Name
LIMIT 0 , 60

*/

/*

Full_name	Tennis_Court
Anne Baker	Tennis Court 1
Burton Tracy	Tennis Court 2
Charles Owen	Tennis Court 1
Darren Smith	Tennis Court 2
David Farrell	Tennis Court 1
David Jones	Tennis Court 2
David Pinker	Tennis Court 1
Douglas Jones	Tennis Court 1
Erica Crumpet	Tennis Court 1
Florence Bader	Tennis Court 2
Gerald Butters	Tennis Court 1
GUEST GUEST	Tennis Court 2
Henrietta Rumney	Tennis Court 2
Jack Smith	Tennis Court 1
Janice Joplette	Tennis Court 1
Jemima Farrell	Tennis Court 2
Joan Coplin	Tennis Court 1
John Hunt	Tennis Court 1
Matthew Genting	Tennis Court 1
Millicent Purview	Tennis Court 2
Nancy Dare	Tennis Court 2
Ponder Stibbons	Tennis Court 2
Ramnaresh Sarwin	Tennis Court 2
Tim Boothe	Tennis Court 2
Tim Rownam	Tennis Court 2
Timothy Baker	Tennis Court 2
Tracy Smith

*/

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT CONCAT( `firstname` , ' ', `surname` ) AS Full_name, Facilities.name AS Facility_name,
CASE WHEN Bookings.memid <> 0
THEN Facilities.membercost * Bookings.slots
ELSE Facilities.guestcost * Bookings.slots
END AS cost
FROM `Members`
INNER JOIN `Bookings` ON Bookings.memid = Members.memid
INNER JOIN `Facilities` ON Facilities.facid = Bookings.facid
WHERE DATE( Bookings.starttime ) = '2012-09-14'
HAVING cost >30
ORDER BY cost DESC
LIMIT 0 , 30

/*
Full_name	Facility_name	cost
GUEST GUEST	Massage Room 2	320.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Tennis Court 2	150.0
GUEST GUEST	Tennis Court 1	75.0
GUEST GUEST	Tennis Court 1	75.0
GUEST GUEST	Tennis Court 2	75.0
GUEST GUEST	Squash Court	70.0
Jemima Farrell	Massage Room 1	39.6
GUEST GUEST	Squash Court	35.0
GUEST GUEST	Squash Court	35.0
*/

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT CONCAT( subq.firstname, ' ', subq.surname ) AS Full_name, subq.Facility_name, subq.cost
FROM (

SELECT Facilities.name AS Facility_name, Members.firstname, Members.surname,
CASE WHEN Bookings.memid <>0
THEN Facilities.membercost * Bookings.slots
ELSE Facilities.guestcost * Bookings.slots
END AS cost
FROM `Members`
INNER JOIN `Bookings` ON Bookings.memid = Members.memid
INNER JOIN `Facilities` ON Facilities.facid = Bookings.facid
WHERE DATE( Bookings.starttime ) = '2012-09-14'
HAVING cost > 30
) AS subq
ORDER BY cost DESC
LIMIT 0 , 30

/*
Full_name	Facility_name	cost
GUEST GUEST	Massage Room 2	320.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Massage Room 1	160.0
GUEST GUEST	Tennis Court 2	150.0
GUEST GUEST	Tennis Court 1	75.0
GUEST GUEST	Tennis Court 2	75.0
GUEST GUEST	Tennis Court 1	75.0
GUEST GUEST	Squash Court	70.0
Jemima Farrell	Massage Room 1	39.6
GUEST GUEST	Squash Court	35.0
GUEST GUEST	Squash Court	35.0
*/

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook
for the following questions.

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT subq.Facility_name, SUM( subq.revenues ) AS total_revenue
FROM (

SELECT Facilities.name AS Facility_name,
CASE WHEN Bookings.memid <>0
THEN Facilities.membercost * Bookings.slots
WHEN Bookings.memid =0
THEN Facilities.guestcost * Bookings.slots
END AS revenues
FROM `Members`
INNER JOIN `Bookings` ON Bookings.memid = Members.memid
INNER JOIN `Facilities` ON Facilities.facid = Bookings.facid
) AS subq
GROUP BY subq.Facility_name
HAVING total_revenue <1000
LIMIT 0 , 30

/*

Facility_name	total_revenue
Pool Table	270.0
Snooker Table	240.0
Table Tennis	180.0

*/

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT Members.surname AS member_surname, Members.firstname AS member_firstname, R.surname AS recommender_surname, R.firstname AS recommender_firstname
FROM Members
INNER JOIN `Members` AS R ON Members.recommendedby = R.memid
WHERE Members.memid <>0
ORDER BY member_surname
LIMIT 0 , 30

/*

member_surname	member_firstname	recommender_surname	recommender_firstname
Bader	Florence	Stibbons	Ponder
Baker	Timothy	Farrell	Jemima
Baker	Anne	Stibbons	Ponder
Boothe	Tim	Rownam	Tim
Butters	Gerald	Smith	Darren
Coplin	Joan	Baker	Timothy
Crumpet	Erica	Smith	Tracy
Dare	Nancy	Joplette	Janice
Farrell	Jemima	GUEST	GUEST
Farrell	David	GUEST	GUEST
Genting	Matthew	Butters	Gerald
Hunt	John	Purview	Millicent
Jones	Douglas	Jones	David
Jones	David	Joplette	Janice
Joplette	Janice	Smith	Darren
Mackenzie	Anna	Smith	Darren
Owen	Charles	Smith	Darren
Pinker	David	Farrell	Jemima
Purview	Millicent	Smith	Tracy
Rownam	Tim	GUEST	GUEST
Rumney	Henrietta	Genting	Matthew
Sarwin	Ramnaresh	Bader	Florence
Smith	Darren	GUEST	GUEST
Smith	Jack	Smith	Darren
Smith	Tracy	GUEST	GUEST
Smith	Darren	GUEST	GUEST
Stibbons	Ponder	Tracy	Burton
Tracy	Burton	GUEST	GUEST
Tupperware	Hyacinth	GUEST	GUEST
Worthington-Smyth	Henry	Smith	Tracy

*/
/* Q12: Find the facilities with their usage by member, but not guests */
SELECT CONCAT( subq.firstname, ' ', subq.surname ) AS Full_name, subq.Facility_name, subq.total_usage
FROM (

SELECT Facilities.name AS Facility_name, Members.firstname, Members.surname,
CASE WHEN Members.memid <>0
THEN (
Members.memid * Bookings.slots
)
END AS total_usage
FROM `Members`
INNER JOIN `Bookings` ON Bookings.memid = Members.memid
INNER JOIN `Facilities` ON Facilities.facid = Bookings.facid
WHERE Members.memid <> 0
) AS subq
GROUP BY Full_name, subq.Facility_name
ORDER BY Full_name ASC

/*

Full_name	Facility_name	total_usage
Anna Mackenzie	Badminton Court	63
Anna Mackenzie	Massage Room 1	42
Anna Mackenzie	Pool Table	21
Anna Mackenzie	Snooker Table	42
Anna Mackenzie	Squash Court	42
Anna Mackenzie	Table Tennis	42
Anne Baker	Badminton Court	36
Anne Baker	Massage Room 1	24
Anne Baker	Massage Room 2	24
Anne Baker	Pool Table	12
Anne Baker	Squash Court	24
Anne Baker	Table Tennis	24
Anne Baker	Tennis Court 1	36
Anne Baker	Tennis Court 2	36
Burton Tracy	Badminton Court	18
Burton Tracy	Massage Room 1	12
Burton Tracy	Pool Table	6
Burton Tracy	Snooker Table	12
Burton Tracy	Squash Court	24
Burton Tracy	Table Tennis	12
Burton Tracy	Tennis Court 1	18
Burton Tracy	Tennis Court 2	18
Charles Owen	Badminton Court	30
Charles Owen	Massage Room 1	20
Charles Owen	Massage Room 2	20
Charles Owen	Pool Table	10
Charles Owen	Snooker Table	20
Charles Owen	Squash Court	20
Charles Owen	Table Tennis	20
Charles Owen	Tennis Court 1	30
Charles Owen	Tennis Court 2	30
Darren Smith	Badminton Court	3
Darren Smith	Massage Room 1	2
Darren Smith	Pool Table	1
Darren Smith	Snooker Table	2
Darren Smith	Squash Court	2
Darren Smith	Table Tennis	2
Darren Smith	Tennis Court 2	3
David Farrell	Pool Table	28
David Farrell	Snooker Table	56
David Farrell	Squash Court	56
David Farrell	Tennis Court 1	84
David Farrell	Tennis Court 2	84
David Jones	Badminton Court	33
David Jones	Massage Room 1	22
David Jones	Massage Room 2	22
David Jones	Pool Table	11
David Jones	Snooker Table	22
David Jones	Squash Court	22
David Jones	Table Tennis	22
David Jones	Tennis Court 1	33
David Jones	Tennis Court 2	33
David Pinker	Badminton Court	51
David Pinker	Massage Room 1	34
David Pinker	Pool Table	17
David Pinker	Snooker Table	34
David Pinker	Squash Court	34
David Pinker	Table Tennis	34
David Pinker	Tennis Court 1	51
Douglas Jones	Badminton Court	78
Douglas Jones	Pool Table	26
Douglas Jones	Squash Court	52
Douglas Jones	Tennis Court 1	78
Erica Crumpet	Badminton Court	108
Erica Crumpet	Massage Room 1	72
Erica Crumpet	Table Tennis	72
Erica Crumpet	Tennis Court 1	108
Florence Bader	Badminton Court	45
Florence Bader	Massage Room 2	30
Florence Bader	Pool Table	15
Florence Bader	Snooker Table	30
Florence Bader	Squash Court	30
Florence Bader	Table Tennis	30
Florence Bader	Tennis Court 1	45
Florence Bader	Tennis Court 2	45
Gerald Butters	Badminton Court	15
Gerald Butters	Massage Room 1	10
Gerald Butters	Massage Room 2	10
Gerald Butters	Pool Table	5
Gerald Butters	Snooker Table	10
Gerald Butters	Squash Court	10
Gerald Butters	Table Tennis	10
Gerald Butters	Tennis Court 1	15
Gerald Butters	Tennis Court 2	15
Henrietta Rumney	Pool Table	27
Henrietta Rumney	Snooker Table	54
Henrietta Rumney	Squash Court	54
Henrietta Rumney	Tennis Court 2	81
Henry Worthington-Smyth	Badminton Court	87
Henry Worthington-Smyth	Massage Room 1	58
Henry Worthington-Smyth	Pool Table	29
Henry Worthington-Smyth	Table Tennis	58
Hyacinth Tupperware	Badminton Court	99
Hyacinth Tupperware	Massage Room 1	66
Hyacinth Tupperware	Pool Table	33
Hyacinth Tupperware	Snooker Table	66
Hyacinth Tupperware	Squash Court	66
Jack Smith	Badminton Court	42
Jack Smith	Massage Room 1	28
Jack Smith	Massage Room 2	28
Jack Smith	Pool Table	14
Jack Smith	Snooker Table	28
Jack Smith	Squash Court	28
Jack Smith	Table Tennis	28
Jack Smith	Tennis Court 1	42
Jack Smith	Tennis Court 2	42
Janice Joplette	Massage Room 1	8
Janice Joplette	Massage Room 2	8
Janice Joplette	Pool Table	4
Janice Joplette	Snooker Table	8
Janice Joplette	Squash Court	8
Janice Joplette	Table Tennis	8
Janice Joplette	Tennis Court 1	12
Janice Joplette	Tennis Court 2	12
Jemima Farrell	Badminton Court	39
Jemima Farrell	Massage Room 1	26
Jemima Farrell	Pool Table	13
Jemima Farrell	Snooker Table	26
Jemima Farrell	Squash Court	26
Jemima Farrell	Table Tennis	26
Jemima Farrell	Tennis Court 1	39
Jemima Farrell	Tennis Court 2	39
Joan Coplin	Massage Room 1	44
Joan Coplin	Massage Room 2	44
Joan Coplin	Pool Table	22
Joan Coplin	Snooker Table	44
Joan Coplin	Squash Court	44
Joan Coplin	Table Tennis	44
Joan Coplin	Tennis Court 1	66
John Hunt	Badminton Court	105
John Hunt	Massage Room 1	70
John Hunt	Squash Court	70
John Hunt	Table Tennis	70
John Hunt	Tennis Court 1	105
John Hunt	Tennis Court 2	105
Matthew Genting	Massage Room 1	40
Matthew Genting	Massage Room 2	40
Matthew Genting	Pool Table	20
Matthew Genting	Snooker Table	40
Matthew Genting	Table Tennis	40
Matthew Genting	Tennis Court 1	60
Millicent Purview	Badminton Court	90
Millicent Purview	Pool Table	30
Millicent Purview	Snooker Table	60
Millicent Purview	Squash Court	60
Millicent Purview	Table Tennis	120
Millicent Purview	Tennis Court 2	90
Nancy Dare	Badminton Court	21
Nancy Dare	Massage Room 1	14
Nancy Dare	Massage Room 2	14
Nancy Dare	Pool Table	7
Nancy Dare	Snooker Table	14
Nancy Dare	Table Tennis	14
Nancy Dare	Tennis Court 1	63
Nancy Dare	Tennis Court 2	21
Ponder Stibbons	Badminton Court	27
Ponder Stibbons	Massage Room 1	36
Ponder Stibbons	Pool Table	9
Ponder Stibbons	Snooker Table	18
Ponder Stibbons	Squash Court	18
Ponder Stibbons	Table Tennis	18
Ponder Stibbons	Tennis Court 1	27
Ponder Stibbons	Tennis Court 2	27
Ramnaresh Sarwin	Badminton Court	72
Ramnaresh Sarwin	Massage Room 1	48
Ramnaresh Sarwin	Massage Room 2	48
Ramnaresh Sarwin	Pool Table	24
Ramnaresh Sarwin	Snooker Table	48
Ramnaresh Sarwin	Squash Court	48
Ramnaresh Sarwin	Table Tennis	48
Ramnaresh Sarwin	Tennis Court 1	72
Ramnaresh Sarwin	Tennis Court 2	72
Tim Boothe	Badminton Court	24
Tim Boothe	Massage Room 1	16
Tim Boothe	Pool Table	8
Tim Boothe	Snooker Table	32
Tim Boothe	Squash Court	16
Tim Boothe	Table Tennis	16
Tim Boothe	Tennis Court 1	24
Tim Boothe	Tennis Court 2	24
Tim Rownam	Badminton Court	9
Tim Rownam	Massage Room 1	6
Tim Rownam	Massage Room 2	6
Tim Rownam	Pool Table	3
Tim Rownam	Table Tennis	6
Tim Rownam	Tennis Court 1	9
Tim Rownam	Tennis Court 2	9
Timothy Baker	Badminton Court	48
Timothy Baker	Massage Room 1	32
Timothy Baker	Pool Table	16
Timothy Baker	Squash Court	32
Timothy Baker	Table Tennis	32
Timothy Baker	Tennis Court 1	48
Timothy Baker	Tennis Court 2	48
Tracy Smith	Badminton Court	6
Tracy Smith	Massage Room 1	4
Tracy Smith	Pool Table	2
Tracy Smith	Snooker Table	4
Tracy Smith	Squash Court	4
Tracy Smith	Table Tennis	4
Tracy Smith	Tennis Court 1	6
Tracy Smith	Tennis Court 2	6

*/

/* Q13: Find the facilities usage by month, but not guests */

SELECT subq.Facility_name, subq.Month, SUM( subq.total_member_use ) AS Total_Member_Usage
FROM (

SELECT Facilities.name AS Facility_name, MONTHNAME( Bookings.starttime ) AS
MONTH ,
CASE WHEN Members.memid <>0
THEN (
Members.memid * Bookings.slots
)
END AS total_member_use
FROM `Members`
INNER JOIN `Bookings` ON Bookings.memid = Members.memid
INNER JOIN `Facilities` ON Facilities.facid = Bookings.facid
WHERE Members.memid <>0
) AS subq
GROUP BY subq.Facility_name,
MONTH
ORDER BY subq.Facility_name DESC
/*
Facility_name	Month	Total_Member_Usage
Tennis Court 2	July	447
Tennis Court 2	August	3330
Tennis Court 2	September	5163
Tennis Court 1	July	810
Tennis Court 1	August	2844
Tennis Court 1	September	5904
Table Tennis	July	222
Table Tennis	August	2416
Table Tennis	September	6108
Squash Court	July	174
Squash Court	August	1622
Squash Court	September	2274
Snooker Table	July	520
Snooker Table	August	2432
Snooker Table	September	5458
Pool Table	July	330
Pool Table	August	2082
Pool Table	September	6738
Massage Room 2	July	38
Massage Room 2	August	190
Massage Room 2	September	416
Massage Room 1	July	580
Massage Room 1	August	2496
Massage Room 1	September	4828
Badminton Court	July	294
Badminton Court	August	2223
Badminton Court	September	5931
*/
