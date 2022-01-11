# Hotel-Management-System
IST 659 Fall 2021 
Project Proposal: Hotel Management System
Nick Giancola, Sean O’Brien, Hrishikesh Telang

## Business Description
The goal of this project is to create a hotel management system to keep track of guests, bookings, and employees to track overall performance and enable the hotel to maximize their space efficiently. This system will help the hotel keep track of the guests that are currently staying at the hotel. They can also track the length of their guests’ stay, which will allow them to book new reservations to make sure there is minimal downtime in between guests.

## Business Details
1.	A hotel consists of numerous operations such as a front desk reception, booking, reservation, ratings, housekeeping, maintaining CRM, etc. 
2.	A hotel can have multiple chains across the country or across the world. A hotel chain may have multiple hotels.
3.	A hotel has multiple rooms and floors, and the rooms can also have various types
4.	The customer can book the hotel and make the payment either online or in person at the hotel
5.	A guest record is also stored in the management system that entails name, age, address, check in date and time, check out date and time, etc.

## Problem Statement
It can be difficult for hotels to keep track of all their guests, considering many guests are beginning and ending their stay on the same day. This can lead to problems with overbooking and/or rooms going unused, which can result in a loss of potential profits. 

## Proposed Solution
With a comprehensive database system, both management and guests will benefit immensely, as management can be assured that the hotel is operating as efficiently as possible and guests will have the booking process and their stay go smoothly.

## Users
The primary end consumers of this product are the hotel guests who will be using it for easier access to their hotel and room to enjoy their stay as much as possible. For the guests, they are on vacation, so as a hotel chain we want to ensure that they can access the hotel in the smoothest way possible and not have to encounter any confusion that could lead to issues and a poor review. On the other end, hotel management will be able to track each guest and each hotel room to make sure that the room is prepared and the guest stay is reserved and paid for. They can also see if the guest has stayed with the hotel before and have a record of all past visits. The hotel administration can use the database management system to view all transactions between the hotel and the guests to make sure there are no outstanding balances. 

## Questions that our queries answer:
1. How many distinct guest have made bookings for a particular month?
2. How many available rooms are in a particular hotel for a given date?
3. How many hotels are in a hotel chain?
4. How many books has a customer made in one year?
5. How many rooms are booked in a particular hotel on a given date?
6. List all the unique countries hotels are located in.
7. How many rooms are available in a given hotel?
8. List all the hotels that have a URL available.
9. List the rate for a room at a given time during the year.

## Views and Triggers:
We have inserted two views and two triggers in our database. They are:

### Views:
1. GuestsDetails – This view shows all the information about the guests. 
2. EmployeeDetails – This view shows all the information about the employees and their respective departments.
### Triggers:
1. BookingAudit_OnInsert – When a new booking is generated, this trigger will create a booking audit table and insert the data into it.
2. BookingAudit_OnDelete – When a booking is deleted, this trigger will be called and a row will be inserted on the Booking Audit table with the information of the booking that is being deleted.
