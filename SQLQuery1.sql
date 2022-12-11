--use AirCompany;

create table Bookings (
	BookingId int not null IDENTITY PRIMARY KEY,
	PassengerId int not null,
	BookingDateTime date DEFAULT GETDATE(),  --œŒÃ≈Õﬂ“‹ ‘”Õ ÷»ﬁ Õ¿ NOW()
	FlightId int not null,
	Amount int not null,
	Price int not null
	--—Œ«ƒ¿“‹ œŒÀ≈ —“¿“”—
)
drop table Bookings;


----—Œ«ƒ¿“‹ “¿¡À»÷” ¿Õ¿À»«¿ ƒ≈ﬂ“≈À‹ÕŒ—“»  ŒÃœ¿Õ»»------------------
----—Œ«ƒ¿“‹ “¿¡À»÷” œ≈–—ŒŒÕ¿À¿ » œ»ÀŒ“Œ¬  Œ“Œ–€≈ Õ¿’Œƒﬂ“—ﬂ Õ¿ –≈…—≈------------------


--------------Users------------------------------------------------------------------
--Add Users--
go
CREATE PROCEDURE sp_InsertUsers
	@login varchar(50),
	@password varchar(50),
	@fname nvarchar(50),
	@lname nvarchar(50),
	@mail varchar(50)
AS
BEGIN
	INSERT INTO Users(Login,Password,FirstName,LastName,Email) values (@login,@password,@fname,@lname,@mail)
END;

--Update info in AdminPanel---
go
CREATE PROCEDURE sp_UpdateInfoInAdminPanel
	@role int,
	@id_users int,
	@login varchar(50),
	@password varchar(50),
	@fname nvarchar(50),
	@lname nvarchar(50),
	@mail varchar(50)
as
begin
	update Users set Users.Roles = @role, Users.Login = @login, Users.Password = @password, Users.FirstName = @fname, Users.LastName = @lname, Users.Email = @mail
	where Users.Id = @id_users
end;


--Login Users--
go
CREATE PROCEDURE sp_GetUser
 @login varchar(50), 
 @password varchar(50),
 @role int out
as 
begin
	select Users.Login, Users.Password from Users where Users.Login = @login AND Users.Password = @password
	SELECT @role = Users.Roles FROM Users where Users.Login = @login AND Users.Password = @password
end;

drop procedure sp_GetUser;

--Update User---œŒƒ ¬Œœ–Œ—ŒÃ ≈Ÿ®  ¿  œ–¿¬»À‹ÕŒ —ƒ≈À¿“‹---
go
CREATE PROCEDURE sp_UpdateUsers
	@id_users int,
	@login varchar(50),
	@password varchar(50),
	@mail varchar(50)
as
begin
	update Users set Users.Login = @login where Users.Id = @id_users
	update Users set Users.Password = @password where Users.Id = @id_users
	update Users set Users.Email = @mail where Users.Id = @id_users
end;
	
exec sp_UpdateUsers @id_users = 3, @login = 'abc', @password = '12345678', @mail = 'dikun.2002@mail.ru';

drop procedure sp_UpdateUsers;		



--Delete User--
go
CREATE PROCEDURE sp_DeleteUsers
	@id_user int
as
begin
	delete Users where Users.Id = @id_user
end;

-- ALTER TABLE Users ADD DEFAULT '0' FOR Roles;

-----------Select Users in Admin Panel---------------------
go
CREATE PROCEDURE sp_SelectUsersInAdmin
as
begin
	Select * from Users
end;

exec sp_SelectUsersInAdmin;

-----------Select Users in User Panel---------------------
go
Create procedure sp_SelectUsersInUser
	@id_users int out
as
begin
	Select * from Users where Users.Id = @id_users
end;

exec sp_SelectUsersInUser @id_users = 1;

drop procedure sp_SelectUsersInUser;


--------------------------------------------Airports----------------------------------------------
---------Add Airports----------
go
Create procedure sp_AddAirports
	@AirportCode varchar(50),
	@Name varchar(50),
	@City varchar(50)
as
begin
	INSERT INTO Airports(AirportCode,Name,City) values (@AirportCode,@Name,@City)
end;

---------Delete Airports----------
go
Create procedure sp_DeleteAirports
	@AirportCode varchar(50)
as
begin
	delete Airports where Airports.AirportCode = @AirportCode
end;

---------Update Airports----------
go
Create procedure sp_UpdateAirports
	@AirportCode varchar(50),
	@Name varchar(50),
	@City varchar(50)
as
begin
	update Airports set Airports.AirportCode = @AirportCode where Airports.AirportCode = @AirportCode
	update Airports set Airports.Name = @Name where Airports.AirportCode = @AirportCode
	update Airports set Airports.City = @City where Airports.AirportCode = @AirportCode
end;

---------Show all Airports----------
go
Create procedure sp_ShowAllAirports
as
begin
	select * from Airports
end;

--exec sp_ShowAllAirports;


--------------------------------------------Flights----------------------------------------------
----Add Flights------------------------------------
go
Create procedure sp_AddFlight
	@Flightnumber int,
	@DepartureDatetime datetime,
	@Departureairport varchar(50),
	@Totalplaces int,
	@ArrivalDatetime datetime,
	@Arrivalairport varchar(50),
	@price int
as
begin
	insert into Flights(FlightNumber, DepartureDateTime, DepartureAirport, TotalPlaces, ArrivalDateTime,ArrivalAirport,Price)
	values (@Flightnumber, @DepartureDatetime, @Departureairport, @Totalplaces,@ArrivalDatetime, @Arrivalairport, @price)
end;
	
----Update info Flight------------------------------
go
Create procedure sp_UpdateInfoFlight
	@Flights_id int,
	@Flightnumber int,
	@DepartureDatetime datetime,
	@Departureairport varchar(50),
	@Totalplaces int,
	@ArrivalDatetime datetime,
	@Arrivalairport varchar(50),
	@price int
as
begin
	update Flights set Flights.FlightNumber = @Flightnumber where Flights.FlightId = @Flights_id
	update Flights set Flights.DepartureDateTime = @DepartureDatetime where Flights.FlightId = @Flights_id
	update Flights set Flights.DepartureAirport = @Departureairport where Flights.FlightId = @Flights_id
	update Flights set Flights.TotalPlaces = @Totalplaces where Flights.FlightId = @Flights_id
	update Flights set Flights.ArrivalDateTime = @ArrivalDatetime where Flights.FlightId = @Flights_id
	update Flights set Flights.ArrivalAirport = @Arrivalairport where Flights.FlightId = @Flights_id
	update Flights set Flights.Price = @price where Flights.FlightId = @Flights_id
end;

----Delete Flights------------------------------
go
Create procedure sp_DeleteFlight
	@Flights_id int
as
begin
	Delete Flights where Flights.FlightId = @Flights_id
end;

exec sp_DeleteFlight @Flights_id = 1;

----Get Flights------------------------------
go
Create procedure sp_GetFlights
as
begin
	select*from Flights
end;

exec sp_GetFlights;

----Search Flights----------
go
create procedure sp_SearchFlight
	@DepartureDatetime datetime = null,
	@Departureairport varchar(50) = null,
	@ArrivalAirport varchar(50) = null
as
begin try
	if @DepartureDatetime is not null and @Departureairport is not null and @ArrivalAirport is not null
		Select Flights.FlightNumber, Flights.DepartureDateTime, Flights.DepartureAirport, Flights.TotalPlaces, Flights.ArrivalDateTime, Flights.ArrivalAirport, Flights.Price
		from Flights
	else if @Departureairport is not null and @ArrivalAirport is not null
		Select Flights.FlightNumber, Flights.DepartureDateTime, Flights.DepartureAirport, Flights.TotalPlaces, Flights.ArrivalDateTime, Flights.ArrivalAirport, Flights.Price
		from Flights where Flights.DepartureAirport = @Departureairport and Flights.ArrivalAirport = @ArrivalAirport
end try
begin catch
	rollback
	select ERROR_MESSAGE() as ErrorMessage;
end catch

exec sp_SearchFlight @DepartureDatetime = '2022-05-12 12:35:40.000', @Departureairport = 'Berlin', @ArrivalAirport = 'Moskow';
exec sp_SearchFlight @Departureairport = 'Moskow', @ArrivalAirport = 'Berlin';

drop procedure sp_SearchFlight;


--------------------------------------------Bookings----------------------------------------------
----Add Order-------------------
go
Create procedure sp_NewAddOrder
	@id_user int,
	@id_flight int,
	@amount int,
	@price int
as
begin
	insert into Bookings (PassengerId, FlightId,Amount,Price) values(@id_user,@id_flight,@amount,@price)
	update Flights set Flights.TotalPlaces -= @amount from Flights where Flights.FlightId = @id_flight
end;

drop procedure sp_NewAddOrder;

exec sp_NewAddOrder @id_user = 7, @id_flight = 1, @amount = 8, @price = 3200;

----Œ¡ÕŒ¬À≈Õ»≈ —“¿“”—¿ «¿ ¿«¿ ◊≈–≈« À»◊Õ€…  ¿¡»Õ≈“ œŒÀ‹«Œ¬¿“≈Àﬂ----ƒŒ¡¿¬»“‹ œŒÀ≈ OrderStatus-------------------------
go
Create procedure sp_OrderStatus
	@status varchar(50) = 'confirmed',
	@id_booking int
as
begin
	update Bookings set Bookings.OrderStatus = @status from Bookings where Bookings.BookingId = @id_booking
end;

----Delete Order----ƒŒƒ≈À¿“‹ ”ƒ¿À≈Õ»≈ «¿ ¿«¿-----------------------------------------
go
Create procedure sp_DeleteOrder
	@id_booking int
as
begin
	update Flights set Flights.TotalPlaces += Bookings.Amount from Flights inner join Bookings
	on Flights.FlightId = Bookings.BookingId and Bookings.BookingId = @id_booking
	where Flights.FlightId in ( select FlightId from Bookings where BookingId = @id_booking)
	delete from Bookings where Bookings.BookingId = @id_booking
end;

exec sp_DeleteOrder @id_booking = 10;

drop procedure sp_DeleteOrder;
--go
--create PROCEDURE DELETEORDER  --›“” œ–Œ÷≈ƒ”–” Ã€ œ≈–≈œ»—€¬¿≈Ã--
--  (
--  @id_booking int
--  )
--AS
--	begin
--	 	 update Schedule set Schedule.countTicket += Orders.countOrder
--			 from Schedule inner join Orders 
--			 on Schedule.id_schedule = Orders.id_schedule and Orders.id_order = @id_order
--			 where Schedule.id_schedule in (select id_schedule from Orders WHERE id_order = @id_order)  	 
--		 delete from Orders where Orders.id_order = @id_order
--	 commit
--	end
--END try
--Begin catch
--	rollback--
--	SELECT ERROR_MESSAGE() AS ErrorMessage;
--end catch


----Select of order by ID-----------------------------------
go 
Create procedure sp_GetOrderById
	@id_booking int
as
begin
	Select * from Bookings where Bookings.BookingId = @id_booking
end;

drop procedure sp_GetOrderById;

exec sp_GetOrderById @id_booking = 1;

-------------------Show the user's order by his ID--------------------------------------
go
Create procedure sp_GetUserOrder
	@id_user int
as
begin try
	SELECT Bookings.BookingId, Flights.DepartureDateTime, Flights.DepartureAirport, 
	Flights.ArrivalDateTime, Flights.ArrivalAirport, Bookings.Amount 
	FROM Bookings INNER JOIN
	Flights on Flights.FlightId = Bookings.FlightId and  Bookings.PassengerId = @id_user
end try 
begin catch
	rollback
	SELECT ERROR_MESSAGE() AS ErrorMessage;
end catch

exec sp_GetUserOrder @id_user = 2;

----Select order-----------------------------------
go 
Create procedure sp_ShowOrder
as
begin
	Select * from Bookings
end;

--------------------------------------------Tickets----------------------------------------------
----—ƒ≈À¿“‹ ƒŒ¡¿¬À≈Õ»≈ ¡»À≈“¿ ◊≈–≈« “–»√≈– œ–» —–¿¡¿“€¬¿Õ»» œ–Œ÷≈ƒ”–€ »«Ã≈Õ≈Õ»≈ —“¿“”—¿ «¿ ¿«¿----
create trigger Add_to_Tickets
on Bookings
after insert
	
as
insert into Tickets(


--------------------------------------------Staff----------------------------------------------
