--use AirCompany;

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
	@BookingDatetime datetime = getDate(); ----œŒƒ ¬Œœ–Œ—ŒÃ----
as
begin
	insert into Bookings values(@id_user,@id_flight,@amount,@price)
	update Flights set Flights.TotalPlaces -= @amount from Flights where Flights.FlightId = @id_flight
end;

----Œ¡ÕŒ¬À≈Õ»≈ —“¿“”—¿ «¿ ¿«¿ ◊≈–≈« À»◊Õ€…  ¿¡»Õ≈“ œŒÀ‹«Œ¬¿“≈Àﬂ----

--	CREATE PROCEDURE NEWORDER --›“” œ–Œ÷≈ƒ”–” Ã€ œ≈–≈œ»—€¬¿≈Ã--
--(
--@id_user int,
--@id_schedule int,	
--@countOrder int
--)
--as
--begin try
--	begin
--		insert into Orders values (@id_user, @id_schedule, @countOrder)
--		update Schedule  set Schedule.countTicket -= @countOrder
--			from Schedule where Schedule.id_schedule = @id_schedule
--		commit
--	end
--end try
--begin catch
--	select ERROR_MESSAGE() as ErrorMessage;
--end catch
--go

----Delete Order----
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

----—ƒ≈À¿“‹ ƒŒ¡¿¬À≈Õ»≈ ƒ¿“€ ¬ ¡–ŒÕ»–Œ¬¿Õ»≈ — œŒÃŒŸ‹ﬁ “–»√≈–¿ œ–» —–¿¡¿“€¬¿Õ»» œ–Œ÷≈ƒ”–€----

--------------------------------------------Tickets----------------------------------------------
----—ƒ≈À¿“‹ ƒŒ¡¿¬À≈Õ»≈ ¡»À≈“¿ ◊≈–≈« “–»√≈– œ–» —–¿¡¿“€¬¿Õ»» œ–Œ÷≈ƒ”–€ »«Ã≈Õ≈Õ»≈ —“¿“”—¿ «¿ ¿«¿----
