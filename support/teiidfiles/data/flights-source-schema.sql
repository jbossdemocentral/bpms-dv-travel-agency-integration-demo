

CREATE TABLE IF NOT EXISTS flight_info
(
   flight_no      VARCHAR(24) NOT NULL,
   airline        VARCHAR(24),
   origin         VARCHAR(36),
   destination    VARCHAR(36),
   price          decimal(20,4),
   departs        timestamp,
   arrives        timestamp
);

DELETE FROM flight_info;

CREATE TABLE IF NOT EXISTS flight_bookings
(
   booking_id    VARCHAR(30) NOT NULL,
   flight_no       VARCHAR(24),
   departs       timestamp,
   arrives       timestamp
);

DELETE from flight_bookings;

INSERT INTO flight_info VALUES(880, 'United', 'Denver', 'NYC', 199.00, '2015-06-23 08:00:00', '2015-06-23 10:00:00');
INSERT INTO flight_info VALUES(881, 'United', 'NYC', 'Denver', 199.00, '2015-06-23 08:00:00', '2015-06-23 10:00:00');
INSERT INTO flight_info VALUES(1621, 'American', 'London', 'Edinburgh', 199.00, '2015-06-20 08:00:00', '2015-06-20 10:00:00');
INSERT INTO flight_info VALUES(1622, 'American', 'Edinburgh', 'London', 199.00, '2015-06-20 08:00:00', '2015-06-20 10:00:00');




    
