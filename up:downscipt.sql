--Down Script

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='FK_departments_department_hotel_id')
    alter table departments drop constraint FK_departments_department_hotel_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='FK_departments_department_service_id')
    alter table departments drop constraint FK_departments_department_service_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='FK_departments_department_employee_id')
    alter table departments drop constraint FK_departments_department_employee_id

drop table if exists departments 

drop table if exists services

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='FK_ratings_rating_service_id')
    alter table ratings drop constraint FK_ratings_rating_service_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='FK_ratings_rating_guest_id')
    alter table ratings drop constraint FK_ratings_rating_guest_id

drop table if exists ratings 

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='FK_checkins_checkin_guest_id')
    alter table checkins drop constraint FK_checkins_checkin_guest_id

drop table if exists checkins

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='FK_guests_guest_room_id')
    alter table guests drop constraint FK_guests_guest_room_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='FK_guests_guest_hotel_id')
    alter table guests drop constraint FK_guests_guest_hotel_id

drop table if exists guests

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='FK_employees_employee_hotel_id')
    alter table employees drop constraint FK_employees_employee_hotel_id

drop table if exists employees

drop table if exists rooms

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='FK_hotels_hotel_owner_id')
    alter table hotels drop constraint FK_hotels_hotel_owner_id

drop table if exists hotels

drop table if exists owners

drop database if exists hotel_management 
use [master]
GO
if exists (select name from sys.databases where name='hotel_management')
    alter database hotem_management set single_user with rollback IMMEDIATE
GO
drop database if exists hotel_management;
GO

-- Up Script

create database hotel_management

create table [dbo].[owners](
    [owner_id] [int] NOT NULL,
    [owner_firstname] [varchar] (20) NOT NULL,
    [owner_lastname] [varchar] (20) NOT NULL,
    [owner_hotel] [varchar] (50) NOT NULL,
    CONSTRAINT [PK_owners_owner_id] PRIMARY KEY (owner_id)
)

create table [dbo].[hotels]( 
    [hotel_id] [int] NOT NULL,
    [hotel_email] [varchar] (50) NOT NULL,
    [hotel_address] [varchar] (50) NOT NULL,
    [hotel_number] [int] NOT NULL,
    [hotel_floor] [int] NOT NULL,
    [hotel_room_count] [int] NOT NULL,
    [hotel_department_id] [int] NOT NULL,
    [hotel_owner_id] [int] NOT NULL,
    CONSTRAINT [PK_hotels_hotel_id] PRIMARY KEY ([hotel_id]),
    CONSTRAINT [U_hotels_hotel_email] unique ([hotel_email]),
    CONSTRAINT [U_hotels_hotel_owner_id] UNIQUE ([hotel_owner_id]),
    CONSTRAINT [FK_hotels_hotel_owner_id] FOREIGN KEY (hotel_owner_id) references owners(owner_id)
)

create table [dbo].[rooms](
    [room_id] [int] NOT NULL,
    [room_hotel_id] [int] NOT NULL,
    [room_number] [int] NOT NULL,
    [room_floor] [int] NOT NULL,
    [room_type] [varchar] (20) NOT NULL,
    [room_booked] [char] (3) NOT NULL,
    CONSTRAINT [PK_rooms_room_hotel_id] PRIMARY KEY ([room_hotel_id]),
    CONSTRAINT [U_rooms_room_number] unique ([room_number])
)

create table [dbo].[employees](
    [employee_id] [int] NOT NULL,
    [employee_title] [varchar] (50) NOT NULL,
    [employee_address] [varchar] (50) NOT NULL,
    [employee_department] [varchar] (50) NOT NULL,
    [employee_salary] [int] NOT NULL,
    [employee_hotel_id] [int] NOT NULL,
    CONSTRAINT [PK_employees_employee_id] PRIMARY KEY ([employee_id]),
    CONSTRAINT [FK_employees_employee_hotel_id] FOREIGN KEY (employee_hotel_id) references rooms(room_hotel_id)
)

create table [dbo].[guests](
    [guest_id] [int] NOT NULL,
    [guest_address] [varchar] (50) NOT NULL,
    [guest_payment] [varchar] (10) NOT NULL,
    [guest_returning] [char] (3),
    [guest_room_id] [int] NOT NULL,
    [guest_hotel_id] [int] NOT NULL,
    CONSTRAINT [PK_guests_guest_id] PRIMARY KEY ([guest_id]),
    CONSTRAINT [U_guests_guest_email] unique ([guest_room_id]),
    CONSTRAINT [FK_guests_guest_room_id] FOREIGN KEY ([guest_room_id]) references rooms(room_hotel_id),
    CONSTRAINT [FK_guests_guest_hotel_id] FOREIGN KEY ([guest_hotel_id]) references hotels(hotel_id)
)

create table [dbo].[checkins](
    [checkin_id] [int] NOT NULL,
    [checkin_days] [int] NOT NULL,
    [checkin_guest_id] [int] NOT NULL,
    [checkin_checkin_day] [date] NOT NULL, 
    [checkin_checkout_day] [date] NOT NULL,
    CONSTRAINT [PK_checkins_checkin_id] PRIMARY KEY ([checkin_id]),
    CONSTRAINT [U_checkins_checkin_guest_id] unique ([checkin_guest_id]),
    CONSTRAINT [FK_checkins_checkin_guest_id] FOREIGN KEY ([checkin_guest_id]) references guests(guest_id)
) 

create table [dbo].[services](
    [service_id] [int] NOT NULL,
    [service_description] [varchar] (50),
    [service_department] [varchar] (50) NOT NULL,
    [service_cost] [int] NOT NULL,
    [service_department_id] [int] NOT NULL,
    CONSTRAINT [PK_services_service_id] PRIMARY KEY (service_id)
)

create table [dbo].[ratings](
    [rating_id] [int] NOT NULL,
    [rating_service_id] [int] NOT NULL,
    [rating_rating_by] [varchar] (20) NOT NULL,
    [rating_rating_for] [varchar] (20) NOT NULL,
    [rating_score] [int] NOT NULL,
    [rating_guest_id] [int] NOT NULL,
    CONSTRAINT [PK_ratings_rating_id] PRIMARY KEY ([rating_id]),
    CONSTRAINT [FK_ratings_rating_service_id] FOREIGN KEY ([rating_service_id]) references services(service_id),
    CONSTRAINT [FK_ratings_rating_guest_id] FOREIGN KEY ([rating_guest_id]) references guests(guest_id)
)

create table [dbo].[departments](
    [department_id] [int] NOT NULL,
    [department_hotel_id] [int] NOT NULL,
    [department_job] [varchar] (20) NOT NULL,
    [department_employees] [int] NOT NULL,
    [department_service_id] [int] NOT NULL,
    [department_employee_id] [int] NOT NULL,
    CONSTRAINT [PK_departments_department_id] PRIMARY KEY (department_id),
    CONSTRAINT [FK_departments_department_hotel_id] FOREIGN KEY (department_hotel_id) references hotels(hotel_id),
    CONSTRAINT [FK_departments_department_service_id] FOREIGN KEY (department_service_id) references services(service_id),
    CONSTRAINT [FK_departments_department_employee_id] FOREIGN KEY (department_employee_id) references employees(employee_id)
)

-- Insert Data for Owners Table

insert into [dbo].[owners] ([owner_id], [owner_firstname], [owner_lastname], [owner_hotel])
VALUES (1, 'Bill', 'Hornbuckle', 'MGM Grand')
insert into [dbo].[owners] ([owner_id], [owner_firstname], [owner_lastname], [owner_hotel])
VALUES (2, 'Randy', 'Morton', 'Bellagio')
insert into [dbo].[owners] ([owner_id], [owner_firstname], [owner_lastname], [owner_hotel])
VALUES (3, 'Robert', 'Earl', 'Planet Hollywood')
insert into [dbo].[owners] ([owner_id], [owner_firstname], [owner_lastname], [owner_hotel])
VALUES (4, 'Kirk', 'Kerkorian', 'Mandalay Bay')
insert into [dbo].[owners] ([owner_id], [owner_firstname], [owner_lastname], [owner_hotel])
VALUES (5, 'Jay', 'Sarno', 'Caesars Palace')
insert into [dbo].[owners] ([owner_id], [owner_firstname], [owner_lastname], [owner_hotel])
VALUES (6, 'Matthew', 'Maddox', 'The Wynn')

-- Insert Data for Hotels Table

insert into [dbo].[hotels] ([hotel_id], [hotel_email], [hotel_address], [hotel_number], [hotel_floor], [hotel_room_count], [hotel_department_id], [hotel_owner_id])
VALUES (1, 'MGM@gmail.com', '1000 Las Vegas Blv', 111, 31, 620, 11, 1)
insert into [dbo].[hotels] ([hotel_id], [hotel_email], [hotel_address], [hotel_number], [hotel_floor], [hotel_room_count], [hotel_department_id], [hotel_owner_id])
VALUES (2, 'Bellagio@gmail.com', '1001 Las Vegas Blv', 222, 25, 600, 12, 2)
insert into [dbo].[hotels] ([hotel_id], [hotel_email], [hotel_address], [hotel_number], [hotel_floor], [hotel_room_count], [hotel_department_id], [hotel_owner_id])
VALUES (3, 'PlanetHollywood@gmail.com', '1002 Las Vegas Blv', 333, 18, 400, 13, 3)
insert into [dbo].[hotels] ([hotel_id], [hotel_email], [hotel_address], [hotel_number], [hotel_floor], [hotel_room_count], [hotel_department_id], [hotel_owner_id])
VALUES (4,'MandalayBay@gmail.com', '1003 Las Vegas Blv', 444, 20, 450, 14, 4)
insert into [dbo].[hotels] ([hotel_id], [hotel_email], [hotel_address], [hotel_number], [hotel_floor], [hotel_room_count], [hotel_department_id], [hotel_owner_id])
VALUES (5, 'CaesarsPalace@gmail.com', '1004 Las Vegas Blv', 555, 21, 350, 15, 5)
insert into [dbo].[hotels] ([hotel_id], [hotel_email], [hotel_address], [hotel_number], [hotel_floor], [hotel_room_count], [hotel_department_id], [hotel_owner_id])
VALUES (6, 'wynn@gmail.com', '1005 Las Vegas Blv', 667, 40, 500, 16, 6)

-- Insert Data for Rooms Table

insert into [dbo].[rooms] ([room_id], [room_hotel_id], [room_number], [room_floor], [room_type], [room_booked])
VALUES (999, 1, 101, 1, 'Single', 'Y')
insert into [dbo].rooms ([room_id], [room_hotel_id], [room_number], [room_floor], [room_type], [room_booked])
VALUES (998, 2, 201, 2, 'Suite', 'Y')
insert into [dbo].rooms ([room_id], [room_hotel_id], [room_number], [room_floor], [room_type], [room_booked])
VALUES (997, 3, 210, 2, 'Double', 'N')
insert into [dbo].rooms ([room_id], [room_hotel_id], [room_number], [room_floor], [room_type], [room_booked])
VALUES (996, 4, 215, 2, 'Suite', 'Y')
insert into [dbo].rooms ([room_id], [room_hotel_id], [room_number], [room_floor], [room_type], [room_booked])
VALUES (995, 5, 301, 3, 'Single', 'Y')
insert into [dbo].rooms ([room_id], [room_hotel_id], [room_number], [room_floor], [room_type], [room_booked])
VALUES (994, 6, 102, 1, 'Single', 'N')

-- Insert Data for Employees Table

insert into [dbo].[employees] ([employee_id], [employee_title], [employee_address], [employee_department], [employee_salary], [employee_hotel_id])
values(1, 'Concierge', '101 Ostrom Ave', 'Reception', 30000, 1)
insert into [dbo].[employees] ([employee_id], [employee_title], [employee_address], [employee_department], [employee_salary], [employee_hotel_id])
values(2, 'Maid', '102 Ostrom Ave', 'Custodial', 25000, 2)
insert into [dbo].[employees] ([employee_id], [employee_title], [employee_address], [employee_department], [employee_salary], [employee_hotel_id])
values(3, 'Maid', '103 Ostrom Ave', 'Custodial', 25000, 3)
insert into [dbo].[employees] ([employee_id], [employee_title], [employee_address], [employee_department], [employee_salary], [employee_hotel_id])
values(4, 'Chef', '104 Ostrom Ave', 'Kitchen', 35000, 4)

-- Insert Data for Guests Table

insert into [dbo].[guests] ([guest_id], [guest_address], [guest_payment], [guest_room_id], [guest_returning], [guest_hotel_id])
VALUES (1, '123 Main Street', 'Y', 1, 'N', 1)
insert into [dbo].[guests] ([guest_id], [guest_address], [guest_payment], [guest_room_id], [guest_returning], [guest_hotel_id])
VALUES (2, '124 Main Street', 'N', 2, 'Y', 2)
insert into [dbo].[guests] ([guest_id], [guest_address], [guest_payment], [guest_room_id], [guest_returning], [guest_hotel_id])
VALUES (3, '125 Main Street', 'Y', 3, 'N', 3)
insert into [dbo].[guests] ([guest_id], [guest_address], [guest_payment], [guest_room_id], [guest_returning], [guest_hotel_id])
VALUES (4, '126 Main Street', 'N', 4, 'Y', 4)
insert into [dbo].[guests] ([guest_id], [guest_address], [guest_payment], [guest_room_id], [guest_returning], [guest_hotel_id])
VALUES (5, '127 Main Street', 'Y', 5, 'N', 5)

-- Insert Data for CheckIns Table

insert into [dbo].[checkins] ([checkin_id], [checkin_days], [checkin_checkin_day], [checkin_checkout_day], [checkin_guest_id])
VALUES (123, 5, '2021-07-04', '2021-07-09', 1)
insert into [dbo].[checkins] ([checkin_id], [checkin_days], [checkin_checkin_day], [checkin_checkout_day], [checkin_guest_id])
VALUES (234, 3, '2021-08-01', '2021-08-04', 2)
insert into [dbo].[checkins] ([checkin_id], [checkin_days], [checkin_checkin_day], [checkin_checkout_day], [checkin_guest_id])
VALUES (345, 7, '2021-08-20', '2021-08-27', 3)
insert into [dbo].[checkins] ([checkin_id], [checkin_days], [checkin_checkin_day], [checkin_checkout_day], [checkin_guest_id])
VALUES (456, 2, '2021-09-14', '2021-09-16', 4)
insert into [dbo].[checkins] ([checkin_id], [checkin_days], [checkin_checkin_day], [checkin_checkout_day], [checkin_guest_id])
VALUES (567, 9, '2021-11-17', '2021-11-26', 5)

-- Insert Data for Services Table

insert into [dbo].[services] ([service_id], [service_description], [service_department], [service_cost], [service_department_id])
VALUES (000, 'Guest housekeeping', 'Custodial', 20, 245)
insert into [dbo].[services] ([service_id], [service_description], [service_department], [service_cost], [service_department_id])
VALUES (001, 'Room service', 'Kitchen', 54, 356)
insert into [dbo].[services] ([service_id], [service_description], [service_department], [service_cost], [service_department_id])
VALUES (002, 'Room key replacement', 'Reception', 15, 467)
insert into [dbo].[services] ([service_id], [service_description], [service_department], [service_cost], [service_department_id])
VALUES (003, 'TV repair', 'Custodial', 42, 578)
insert into [dbo].[services] ([service_id], [service_description], [service_department], [service_cost], [service_department_id])
VALUES (004, 'Internet connection issue', 'Reception', 30, 689)

-- Insert Data for Ratings Table

insert into [dbo].[ratings] ([rating_id], [rating_service_id], [rating_rating_by], [rating_rating_for], [rating_score], [rating_guest_id])
VALUES (789, 000, 'Harrison Bryant', 'Devin Singletary', 3, 1)
insert into [dbo].[ratings] ([rating_id], [rating_service_id], [rating_rating_by], [rating_rating_for], [rating_score], [rating_guest_id])
VALUES (890, 001, 'Wyatt Teller', 'Matt Breida', 5, 2)
insert into [dbo].[ratings] ([rating_id], [rating_service_id], [rating_rating_by], [rating_rating_for], [rating_score], [rating_guest_id])
VALUES (901, 002, 'JC Tretter', 'Sonya Blade', 2, 3)
insert into [dbo].[ratings] ([rating_id], [rating_service_id], [rating_rating_by], [rating_rating_for], [rating_score], [rating_guest_id])
VALUES (012, 003, 'Dee Haslam', 'Cassie Cage', 4, 4)
insert into [dbo].[ratings] ([rating_id], [rating_service_id], [rating_rating_by], [rating_rating_for], [rating_score], [rating_guest_id])
VALUES (123, 004, 'Jarvis Landry', 'Kim Kardashian', 3, 5)

-- Insert Data for Departments Table

insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (110, 1, 'Custodial', 100, 000, 2)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (111, 1, 'Reception', 15, 001, 1)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (112, 1, 'Kitchen', 30, 002, 4)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (210, 2, 'Custodial', 120, 003, 2)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (211, 2, 'Reception', 10, 004, 1)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (212, 2, 'Kitchen', 35, 000, 4)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (310, 3, 'Custodial', 110, 001, 2)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (311, 3, 'Reception', 18, 002, 1)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (312, 3, 'Kitchen', 28, 003, 4)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (410, 4, 'Custodial', 104, 004, 2)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (411, 4, 'Reception', 12, 000, 1)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (412, 4, 'Kitchen', 25, 001, 4)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (510, 5, 'Custodial', 200, 002, 2)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (511, 5, 'Reception', 13, 003, 1)
insert into [dbo].[departments] ([department_id], [department_hotel_id], [department_job], [department_employees], [department_service_id], [department_employee_id])
VALUES (512, 5, 'Kitchen', 32, 004, 4)


select * from hotels
select * from guests
select * from rooms
select * from employees
select * from checkins
select * from ratings
select * from services
select * from departments 
select * from owners 

-- User Stories

select * from rooms where room_booked = 'N'

select rating_rating_by, rating_rating_for, rating_score from ratings

select checkin_guest_id, checkin_checkin_day, checkin_checkout_day from checkins

