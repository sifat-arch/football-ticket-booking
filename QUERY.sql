DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

create table Users(
    user_id SERIAL,
    full_name VARCHAR(100),
    email VARCHAR(150),
    role VARCHAR(20),
    phone_number VARCHAR(15),

   constraint pk_users primary key(user_id),
   constraint uq_users_email unique (email),
   constraint chk_users_role check(role in('Ticket Manager', 'Football Fan'))
   
  );



CREATE TABLE Matches (
    match_id serial,
    fixture varchar(100),
    tournament_category varchar(100),
    base_ticket_price decimal(10,2),
    match_status varchar(20),

    constraint pk_matches primary key (match_id), 
    constraint chk_base_ticket_price check(base_ticket_price >= 0),
    constraint chk_match_status check (match_status in ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
   
    
);




CREATE TABLE Bookings (
    booking_id serial,
    user_id int,
    match_id int,
    seat_number varchar(50),
    payment_status varchar(20),
    total_cost decimal(10,2),

    constraint pk_bookings primary key (booking_id),
    constraint fk_bookings_user foreign key (user_id) references Users(user_id),
    constraint fk_bookings_match foreign key(match_id) references Matches(match_id),
    constraint chk_total_cost check (total_cost >= 0),
    constraint chk_payment_status check(payment_status in ('Pending', 'Confirmed', 'Cancelled', 'Refunded'))
 
);

-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);

-- query-1
select match_id,fixture,base_ticket_price from matches 
where tournament_category='Champions League' and match_status = 'Available'

--query-2
select user_id,full_name,email from users

-- query-3
select booking_id,user_id,match_id,coalesce(payment_status,'Action Required') as systematic_status from bookings
where payment_status is null

-- query-4
select booking_id,full_name,fixture,round(total_cost) from bookings
inner join users using(user_id)
inner join matches using(match_id)

-- query-5
select user_id,full_name,booking_id from users
left join bookings using(user_id)


-- query-6

select booking_id,match_id,total_cost from bookings
where total_cost > (
   select avg(total_cost) from bookings
)

-- query-7
select match_id,fixture, base_ticket_price from matches
order by base_ticket_price desc limit 2 offset 1