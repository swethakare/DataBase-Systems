CREATE TABLE Passengers
(
passid NUMBER(38,0),
pname VARCHAR2(40),
dob DATE,
gender VARCHAR2(15),
occupation VARCHAR2(30),
ssn VARCHAR2(11),
is_member VARCHAR2(1), --Y or N
email VARCHAR2(50),
PRIMARY KEY (passid)
);
CREATE TABLE Addresses
(
passid NUMBER(38,0),
street VARCHAR2(50),
home_num VARCHAR2(10),
city VARCHAR2(30),
state VARCHAR2(50),
zip VARCHAR2(20),
PRIMARY KEY(passid,street,home_num,city,state,zip),
FOREIGN KEY (passid) REFERENCES Passengers(passid)
ON DELETE CASCADE
);


CREATE TABLE Phones
(
passid NUMBER(38,0),
phone VARCHAR2(20),
phone_type VARCHAR2(20), --home, work, cell, etc.
PRIMARY KEY (passid,phone,phone_type),
FOREIGN KEY (passid) REFERENCES Passengers(passid)
ON DELETE CASCADE
);
CREATE TABLE Login
(
passid NUMBER(38,0) NOT NULL UNIQUE,
username VARCHAR2(50),
passwd VARCHAR2(50),
PRIMARY KEY (username),
FOREIGN KEY (passid) REFERENCES Passengers(passid)
ON DELETE CASCADE
);
CREATE TABLE Point_Accounts
(
point_account_id VARCHAR2(50),
total_points NUMBER(38,0),
passid NUMBER(38,0) NOT NULL,
PRIMARY KEY (point_account_id),
FOREIGN KEY (passid) REFERENCES Passengers(passid)
);
CREATE TABLE Empl_Incentives
(
incentive_id VARCHAR2(50),
passenger_id NUMBER(38,0),
PRIMARY KEY (incentive_id)
);
CREATE TABLE Empl_Referrals
(
referral_id VARCHAR2(50),
passenger_id NUMBER(38,0),
PRIMARY KEY (referral_id)
);
CREATE TABLE Flights(
flight_id VARCHAR2(50),
arrival_datetime DATE,
dept_datetime DATE,
source VARCHAR2(50),
destination VARCHAR2(50),
flight_miles NUMBER(38,0), --the miles collected from the flight
passid NUMBER(38,0) NOT NULL,
point_account_id VARCHAR2(50),
incentive_id VARCHAR2(50),
referral_id VARCHAR2(50),
percent_increase1 NUMBER(3,0),
percent_increase2 NUMBER(3,0),
PRIMARY KEY (flight_id),
FOREIGN KEY (passid) REFERENCES Passengers(passid),
FOREIGN KEY (point_account_id) REFERENCES Point_Accounts(point_account_id),
FOREIGN KEY (incentive_id) REFERENCES Empl_Incentives(incentive_id),
FOREIGN KEY (referral_id) REFERENCES Empl_Referrals(referral_id)
);
CREATE TABLE Trips
(
trip_id VARCHAR2(50),
arrival_datetime DATE,
dept_datetime DATE,
source VARCHAR2(50),
destination VARCHAR2(50),
trip_miles NUMBER(38,0), --the miles collected from the trip
PRIMARY KEY (trip_id)
);

CREATE TABLE Flights_Trips --name of the table representing the M-M relationship between Flights and Trips
(
flight_id VARCHAR2(50),
trip_id VARCHAR2(50) NOT NULL,
PRIMARY KEY (flight_id,trip_id),
FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);
CREATE TABLE Promotions
(
prom_id VARCHAR2(50),
prom_action VARCHAR2(50),
prom_period VARCHAR2(70),
p_description VARCHAR2(200),
PRIMARY KEY (prom_id)
);
CREATE TABLE Flights_Promotions
(
flight_id VARCHAR2(50),
prom_id VARCHAR2(50),
PRIMARY KEY (flight_id,prom_id),
FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
FOREIGN KEY (prom_id) REFERENCES Promotions(prom_id)
);
CREATE TABLE Cards
(
card_id VARCHAR2(50),
expiry_date DATE,
is_valid VARCHAR2(1),
c_date DATE,
passid NUMBER(38,0) NOT NULL, 
PRIMARY KEY(card_id),
FOREIGN KEY (passid) REFERENCES Passengers(passid)
);
CREATE TABLE ExchgCenters
(
center_id NUMBER(38,0),
center_name VARCHAR2(50),
c_location VARCHAR2(200),
PRIMARY KEY (center_id)
);
CREATE TABLE Awards
(
award_id NUMBER(38,0),
points_required NUMBER(38,0),
a_description VARCHAR2(400),
PRIMARY KEY (award_id)
);
CREATE TABLE Redemption_History --represents the redemption history linking passengers to awards to exchange centers to point accounts
(
passid NUMBER(38,0),
award_id NUMBER(38,0),
redemption_date DATE,
quantity NUMBER(38,0), -- by default 1 but this can be 2 or more if the same award is redeemed more than once on the same date by the same passenger in the same exchcenter
point_account_id VARCHAR2(50),
center_id NUMBER(38,0),
PRIMARY KEY (passid,award_id,point_account_id,center_id,redemption_date),
FOREIGN KEY (passid) REFERENCES passengers(passid),
FOREIGN KEY (award_id) REFERENCES Awards(award_id),
FOREIGN KEY (point_account_id) REFERENCES Point_Accounts(point_account_id),
FOREIGN KEY (center_id) REFERENCES ExchgCenters(center_id)
);