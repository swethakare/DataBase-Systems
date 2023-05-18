--Query 1
--Select the promotion id, promotion action, and promotion period provided to a particular flight id. (2.5%)
select p.prom_id,p.prom_action,p.prom_period
FROM promotions p
JOIN Flights_Promotions FP
ON FP.prom_id = p.prom_id
where fp.flight_id = 'LH452';

--Query 2
--Display all the flight ids, flight points, and the flight arrival dates for a particular passenger name. (2.5%)
select f.flight_id,f.flight_miles,f.arrival_datetime,p.pname
from flights f
join passengers p
ON p.passid = f.passid
where p.pname = 'Saul Saran';

--Query 3
--Find the Flight ids and the number of promotions provided to each flight id. (2.5%)
select flight_id, count(prom_id) no_of_promotions
from flights_promotions
group by flight_id;

--Query 4
--Find the passengers ids and names who arrived to Berlin between March 1st and March 15th 2023.
select p.passid,p.pname,f.arrival_datetime
from passengers p
join flights f
on p.passid = f.passid
where arrival_datetime between  TO_DATE('01-03-2023', 'dd-MM-yyyy') and TO_DATE('15-03-2023', 'dd-MM-yyyy')
AND destination = 'Berlin';

--Query 5
--Display for a particular flight id, the flight id, source, destination, the number of points collected, and the trip ids and arrival dates included in the flight. (2.5%)
select f.flight_id,ft.trip_id,f.source,f.destination,f.arrival_datetime,f.flight_miles * (f.percent_increase1 + f.percent_increase2 + pc.promo_action) flight_points
from flights f
join(select CAST(pr.prom_action AS NUMBER) promo_action,pf.flight_id
from Flights_Promotions pf
join Promotions pr
on pr.prom_id=pf.prom_id)pc
on pc.flight_id = f.flight_id
join flights_trips ft
on f.flight_id = ft.flight_id
where f.flight_id = 'IW148';

--Query 6
--Find the number of expired cards available in the database
select count(card_id) No_Of_Expired_Cards
from cards
where is_valid = 'N';

--Query 7
--Find the passenger with the maximum number of expired cards. (2.5%)
SELECT EC.PASSID,EC.EXPIRED_CARDS
FROM(SELECT MAX(Expired_Cards) EXPIRED_CARDS 
FROM(SELECT PASSID, COUNT(CARD_ID) Expired_Cards
FROM CARDS
WHERE IS_VALID = 'N'
GROUP BY PASSID)EC)PC
JOIN(SELECT PASSID, COUNT(CARD_ID) Expired_Cards
FROM CARDS
WHERE IS_VALID = 'N'
GROUP BY PASSID)EC
ON EC.EXPIRED_CARDS=PC.EXPIRED_CARDS;

--Query 8
--Find the redemption history of a particular passenger name. You should display the award ID, award description, passenger name,center id, and number of points redeemed. (3%)
SELECT R.AWARD_ID, A.a_description, A.points_required POINTS_REDEEMED, P.PNAME, R.CENTER_ID
FROM REDEMPTION_HISTORY R 
JOIN AWARDS A 
ON R.AWARD_ID = A.AWARD_ID
JOIN PASSENGERS P
ON P.PASSID = R.PASSID
WHERE P.PNAME = 'Khan Soma';

--Query 9
--Display the name and occupation of the passengers living in Fairfax
SELECT DISTINCT(P.PNAME),P.OCCUPATION
FROM PASSENGERS P
JOIN Addresses A
ON P.PASSID = A.PASSID
WHERE A.CITY = 'Fairfax';

--Query 10
--Display the sum of points of the passengers living in Fairfax. 
SELECT SUM(TOTAL_POINTS) Total_Pts_Passengers_Living_In_Fairfax FROM
(SELECT DISTINCT(P.PASSID),P.PNAME,PA.TOTAL_POINTS,A.CITY
FROM PASSENGERS P
JOIN ADDRESSES A
ON P.PASSID = A.PASSID
JOIN POINT_ACCOUNTS PA
ON P.PASSID = PA.PASSID
WHERE A.CITY = 'Fairfax');

--Query 11
--Display the passenger name with the maximum number of collected points. 
SELECT DISTINCT(P.PNAME)
FROM PASSENGERS P
JOIN POINT_ACCOUNTS PA
ON P.PASSID = PA.PASSID
JOIN(SELECT MAX(TOTAL_POINTS) TOTAL_POINTS FROM (SELECT DISTINCT(P.PASSID),P.PNAME,PA.TOTAL_POINTS
FROM PASSENGERS P
JOIN POINT_ACCOUNTS PA
ON P.PASSID = PA.PASSID)PC)AC
ON AC.TOTAL_POINTS = PA.TOTAL_POINTS;

--Query 12
--Find the total number of points redeemed on a particular date. 
SELECT SUM(Points_Redeemed) Total_Points_Redeemed,RC.redemption_date
FROM(SELECT A.points_required * R.quantity Points_Redeemed , R.redemption_date
FROM AWARDS A 
JOIN REDEMPTION_HISTORY R
ON A.AWARD_ID = R.AWARD_ID
WHERE R.redemption_date = TO_DATE('31-03-2023', 'dd-MM-yyyy'))RC
GROUP BY RC.redemption_date ;

--Query 13
--Find the number of awards redeemed by a particular passenger id. 
SELECT AC.PASSID,SUM(Quantity) FROM(SELECT R.AWARD_ID,R.PASSID,R.QUANTITY Quantity
FROM REDEMPTION_HISTORY R
WHERE R.PASSID = 1210)AC
GROUP BY AC.PASSID;

--Query 14
--Find the number of passengers who redeemed awards from a particular center id. (
SELECT RC.CENTER_ID , COUNT(PASSENGERS) 
FROM (
SELECT E.CENTER_ID,E.PASSID PASSENGERS
FROM REDEMPTION_HISTORY E
WHERE E.CENTER_ID='1003'
)RC
GROUP BY RC.CENTER_ID;

--Query 15
--Find the total no of awards in the database
SELECT COUNT(AWARD_ID) No_Of_Awards
FROM AWARDS;

--Query 16
--Display a list of passenger names living in Fairfax and whose occupation is Engineer. 
SELECT DISTINCT(P.PNAME)
FROM PASSENGERS P 
JOIN ADDRESSES A
ON P.PASSID = A.PASSID
WHERE A.CITY = 'Fairfax' AND P.OCCUPATION = 'Engineer';

--Query 17
--Find the list of trips not included in any flight.
SELECT t.trip_id
FROM Trips t
LEFT JOIN Flights_Trips ft ON t.trip_id = ft.trip_id
WHERE ft.flight_id IS NULL;

--Query 18
--Find the trip booked the most by passengers (3%)
SELECT t.trip_id, COUNT(DISTINCT f.passid) AS num_passengers
FROM Trips t
JOIN Flights_Trips ft ON t.trip_id = ft.trip_id
JOIN Flights f ON ft.flight_id = f.flight_id
GROUP BY t.trip_id
ORDER BY num_passengers DESC
FETCH FIRST 1 ROWS ONLY;
