use AirCompany;
--Users--------------------------
CREATE LOGIN AirCompanyAdmin WITH PASSWORD = '0000', DEFAULT_DATABASE = AirCompany, CHECK_EXPIRATION = OFF, CHECK_POLICY = On;
go
CREATE LOGIN AirCompanyUser WITH PASSWORD = '0000', DEFAULT_DATABASE = AirCompany, CHECK_EXPIRATION = OFF, CHECK_POLICY = On;
go

CREATE USER AirCompanyAdmin FOR LOGIN AirCompanyAdmin WITH DEFAULT_SCHEMA=[dbo]
CREATE USER AirCompanyUser FOR LOGIN AirCompanyUser WITH DEFAULT_SCHEMA=[dbo]


CREATE ROLE AirCompanyUser_Role
go
grant execute on sp_InsertUsers to AirCompanyUser_Role
grant execute on sp_NewAddOrder to AirCompanyUser_Role
grant execute on sp_DeleteUsers to AirCompanyUser_Role
grant execute on sp_DeleteOrder to AirCompanyUser_Role
grant execute on sp_UpdateUsers to AirCompanyUser_Role
grant execute on sp_GetFlights  to AirCompanyUser_Role
grant execute on sp_SearchFlight  to AirCompanyUser_Role
grant execute on sp_GetUser to AirCompanyUser_Role
grant execute on sp_GetUserOrder to AirCompanyUser_Role
grant execute on sp_OrderStatus  to AirCompanyUser_Role
grant execute on sp_GetStaffOnFlight to AirCompanyUser_Role
go

exec sp_InsertUsers @login = 'Igor', @password = '12345', @fname = 'Igor', @lname = 'Dikun', @mail = 'dikun9489@gmail.com';


--------Users table----------
create table Users (
	Id int not null IDENTITY Primary key,
	Login varchar(50) not null,
	Password varchar(50) not null,
	FirstName nvarchar(50) not null,
	LastName nvarchar(50) not null,
	Email varchar(50) not null,
	Roles int not null DEFAULT '0'
)

drop table Users;

create index id_user on Users(Id);
drop index Users.id_user;

--------Flights table----------
create table Flights (
	FlightId int not null IDENTITY Primary key,
	FlightNumber int not null,
	DepartureDateTime date not null,
--	TimeDepart time not null,
	DepartureAirport varchar(50) not null,
	TotalPlaces int not null check(TotalPlaces <= 200 and TotalPlaces >= 0),
	ArrivalDateTime date not null,
--	TimeArrival time not null,
	ArrivalAirport varchar(50) not null,
	Price int not null,
	Status varchar(50) not null DEFAULT 'In process',
	FlightClass int not null
)

drop table Flights;

--------Table a Airports----------
create table Airports (
	AirportCode varchar(50) not null,
	Name varchar(50) not null Primary key,
	City varchar(50),
	AirportType varchar(50) not null
)

drop table Airports;

--------Bookings table----------
create table Bookings (
	BookingId int not null IDENTITY PRIMARY KEY,
	PassengerId int not null,
	BookingDateTime datetime DEFAULT GETDATE(),
	FlightId int not null,
	DepartureAirport varchar(50),
	ArrivalAirport varchar(50),
	FlightClass int,
	Amount int not null,
	Price int not null,
	Status varchar(50) not null DEFAULT 'Waiting'
)

drop table Bookings;

----Staff table------------------
create table Staff (
	PersonalId int not null IDENTITY PRIMARY KEY,
	FirstName nvarchar(50) not null,
	SecondName nvarchar(50) not null,
	LastName nvarchar(50) not null,
	Birthday date not null,
	Post nvarchar(50) not null,
	Experience varchar(10) not null,
	Number varchar(20) not null,
	FlightId int not null
)

drop table Staff;

--------Statistics table----------
create table Statistic(
	ConfirmedFlightsCount int not null,
	CanceledFlightCount int not null,
	Profit int,
	Ratio int
)

drop table Statistic;


--------------Procedure on Users------------------------------------------------------------------
--Add Users--
go
CREATE PROCEDURE sp_InsertUsers
	@login varchar(50),
	@password varchar(50),
	@fname nvarchar(50),
	@lname nvarchar(50),
	@mail varchar(50)
AS
BEGIN try
	IF EXISTS (SELECT * FROM Users WHERE login = LTRIM(RTRIM(@login)))
			RAISERROR ('[ERROR] signUpUser: User with this login already exists.', 17, 1);
	INSERT INTO Users(Login,Password,FirstName,LastName,Email) values (@login,@password,@fname,@lname,@mail)

END try
begin catch
DECLARE @errorMessage NVARCHAR(MAX), @errorSeverity INT, @errorState INT;
        SELECT  @errorMessage = ERROR_MESSAGE(), 
				@errorSeverity = ERROR_SEVERITY(),
				@errorState = ERROR_STATE();
		
		RAISERROR (@errorMessage, @errorSeverity, @errorState);
        RETURN -1;
	END CATCH;	

exec sp_InsertUsers @login = 'Admin', @password = '12345', @fname = 'Igor', @lname = 'Dikun', @mail = 'dikun9489@gmail.com';

drop procedure sp_InsertUsers;
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

exec sp_UpdateInfoInAdminPanel @role = 1, @login = 'Admin', @password = '12345', @fname = 'Igor', @lname = 'Dikun', @mail = 'dikun9489@gmail.com', @id_users = 1; 

--Login Users--
go
CREATE PROCEDURE sp_GetUser
 @login varchar(50), 
 @password varchar(50),
 @role int out
as 
begin
DECLARE	@countWithThisEmailAndPassword INT;
	SET @countWithThisEmailAndPassword = 
			(
				SELECT COUNT(*) 
				FROM users 
				WHERE
					 password = @password
			);
			IF (@countWithThisEmailAndPassword = 0)
				RAISERROR('[ERROR] signInUser: Incorrect password.', 17, 1);
			ELSE
				PRINT 'You successfully signed in! Hello, ' + LTRIM(RTRIM(@login));
				select Users.Login, Users.Password from Users where Users.Login = @login AND Users.Password = @password
				SELECT @role = Users.Roles FROM Users where Users.Login = @login AND Users.Password = @password
			RETURN 1;
end;

select * from Users;

exec sp_GetUser @login = 'Admin', @password = '12345', @role = 1;

drop procedure sp_GetUser;

--Update User---œŒƒ ¬Œœ–Œ—ŒÃ ≈Ÿ®  ¿  œ–¿¬»À‹ÕŒ —ƒ≈À¿“‹ ◊≈–≈« œ–»ÀŒ∆≈Õ»≈---
go
CREATE PROCEDURE sp_UpdateUsers
	@login varchar(50),
	@password varchar(50),
	@mail varchar(50)
as
begin
	update Users set Users.Password = @password where Users.Login = @login
	update Users set Users.Email = @mail where Users.Login = @login
end;
	
exec sp_UpdateUsers  @login = 'Admin', @password = '123456', @mail = 'dikun.2002@mail.ru';

drop procedure sp_UpdateUsers;		



--Delete User--
go
CREATE PROCEDURE sp_DeleteUsers
	@id_user int
as
begin
	delete Users where Users.Id = @id_user
end;

exec sp_DeleteUsers @id_user = 2;

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

exec sp_SelectUsersInUser @id_users = 99999;
go

SELECT COUNT(*) FROM Users;
go
SET STATISTICS TIME ON;
go
select * from Users;

drop procedure sp_SelectUsersInUser;


--------------------------------------------Procedure on Airports----------------------------------------------
---------Add Airports----------
go
Create procedure sp_AddAirports
	@AirportCode varchar(50),
	@Name varchar(50),
	@City varchar(50),
	@AirportType varchar(50)
as
begin
	INSERT INTO Airports(AirportCode,Name,City,AirportType) values (@AirportCode,@Name,@City,@AirportType)
end;

drop procedure sp_AddAirports;

exec sp_AddAirports @AirportCode = 'BRL', @Name = 'Berlin', @City = 'Berlin', @AirportType = 'International';
exec sp_AddAirports @AirportCode = 'MSK', @Name = 'Moskow', @City = 'Moskow', @AirportType = 'International';
exec sp_AddAirports @AirportCode = 'LAS', @Name = 'Los-Angeles', @City = 'Los-Angeles', @AirportType = 'International';
exec sp_AddAirports @AirportCode = 'PRS', @Name = 'Paris', @City = 'Paris', @AirportType = 'International';

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
	@City varchar(50),
	@AirportType varchar(50)
as
begin
	update Airports set Airports.AirportCode = @AirportCode where Airports.AirportCode = @AirportCode
	update Airports set Airports.Name = @Name where Airports.AirportCode = @AirportCode
	update Airports set Airports.City = @City where Airports.AirportCode = @AirportCode
	update Airports set Airports.AirportType = @AirportType where Airports.AirportCode = @AirportCode
end;

drop procedure sp_UpdateAirports;

---------Show all Airports----------
go
Create procedure sp_ShowAllAirports
as
begin
	select * from Airports
end;

exec sp_ShowAllAirports;


--------------------------------------------Procedure on Flights----------------------------------------------
----Add Flights------------------------------------
go
Create procedure sp_AddFlight
	@Flightnumber int,
	@DepartureDateTime date,
--	@TimeDeparture time,
	@Departureairport varchar(50),
	@Totalplaces int, --Ó„‡ÌË˜ÂÌËÂ 
	@ArrivalDateTime date,
--	@TimeArrival time,
	@Arrivalairport varchar(50),
	@price int,
	@FlightClass int
as
begin
	insert into Flights(FlightNumber, DepartureDateTime, DepartureAirport, TotalPlaces, ArrivalDateTime,ArrivalAirport,Price,FlightClass)
	values (@Flightnumber, @DepartureDateTime, @Departureairport, @Totalplaces,@ArrivalDateTime, @Arrivalairport, @price,@FlightClass)
end;



exec sp_AddFlight @Flightnumber = 1, @DepartureDateTime = '16-12-2022', @Departureairport = 'Los-Angeles',@Totalplaces = 200, @ArrivalDateTime = '16-12-2022',@Arrivalairport = 'Paris', @price = 780,@FlightClass = 1;
exec sp_AddFlight @Flightnumber = 2, @DepartureDatetime = '18-12-2022 16:37:00',@Departureairport = 'Moskow',@Totalplaces = 200, @ArrivalDatetime = '19-12-2022 07:45', @Arrivalairport = 'Los-Angeles', @price = 1640, @FlightClass = 2;
exec sp_AddFlight @Flightnumber = 3, @DepartureDatetime = '18-12-2022 8:00',@Departureairport = 'Berlin',@Totalplaces = 200, @ArrivalDatetime = '18-12-2022 15:45', @Arrivalairport = 'Moskow', @price = 640, @FlightClass = 1;
exec sp_AddFlight @Flightnumber = 4, @DepartureDatetime = '20-12-2022 12:28',@Departureairport = 'Berlin',@Totalplaces = 200, @ArrivalDatetime = '20-12-2022 19:56', @Arrivalairport = 'Paris', @price = 340, @FlightClass =2;

drop procedure sp_AddFlight;
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
	@price int,
	@class int
as
begin
	update Flights set Flights.FlightNumber = @Flightnumber where Flights.FlightId = @Flights_id
	update Flights set Flights.DepartureDateTime = @DepartureDatetime where Flights.FlightId = @Flights_id
	update Flights set Flights.DepartureAirport = @Departureairport where Flights.FlightId = @Flights_id
	update Flights set Flights.TotalPlaces = @Totalplaces where Flights.FlightId = @Flights_id
	update Flights set Flights.ArrivalDateTime = @ArrivalDatetime where Flights.FlightId = @Flights_id
	update Flights set Flights.ArrivalAirport = @Arrivalairport where Flights.FlightId = @Flights_id
	update Flights set Flights.Price = @price where Flights.FlightId = @Flights_id
	update Flights set Flights.FlightClass = @class where Flights.FlightId = @Flights_id
end;

drop procedure sp_UpdateInfoFlight;
----Update Flights status------------------------------
go
create procedure sp_FlightStatusCompleted
	@status varchar(50) = 'Completed',
	@Flight_id int
as
begin
	update Flights set Flights.Status = @status where Flights.FlightId = @Flight_id
end;

exec sp_FlightStatusCompleted @Flight_id = 3;


go
create procedure sp_FlightStatusCanceled
	@status varchar(50) = 'Canceled',
	@Flight_id int
as
begin
	update Flights set Flights.Status = @status where Flights.FlightId = @Flight_id
	update Bookings set Bookings.Status = @status where Bookings.FlightId = @Flight_id
end;

exec sp_FlightStatusCanceled @Flight_id = 1;

drop procedure sp_FlightStatusCanceled;
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
	@DepartureDatetime date = null,
--	@TimeDepart time = null,
	@Departureairport varchar(50) = null,
	@ArrivalAirport varchar(50) = null
as
begin try
	if @DepartureDatetime is not null and @Departureairport is not null and @ArrivalAirport is not null
			Select Flights.FlightNumber, Flights.DepartureDateTime, Flights.DepartureAirport, Flights.TotalPlaces,Flights.ArrivalDateTime, Flights.ArrivalAirport, Flights.Price
		from Flights where Flights.DepartureDateTime = @DepartureDatetime and Flights.ArrivalAirport = @ArrivalAirport and Flights.DepartureAirport = @Departureairport
	else if @Departureairport is not null and @ArrivalAirport is not null
		Select Flights.FlightNumber, Flights.DepartureDateTime, Flights.DepartureAirport, Flights.TotalPlaces, Flights.ArrivalDateTime, Flights.ArrivalAirport, Flights.Price
		from Flights where Flights.DepartureAirport = @Departureairport and Flights.ArrivalAirport = @ArrivalAirport
end try
begin catch
		DECLARE @errorMessage NVARCHAR(MAX), @errorSeverity INT, @errorState INT;
        SELECT  @errorMessage = ERROR_MESSAGE(), 
				@errorSeverity = ERROR_SEVERITY(),
				@errorState = ERROR_STATE();

		RAISERROR (@errorMessage, @errorSeverity, @errorState);
        RETURN -1;
end catch

exec sp_SearchFlight @DepartureDatetime = '2022-12-16', @Departureairport = 'Los-Angeles', @ArrivalAirport = 'Paris';

exec sp_SearchFlight @Departureairport = 'Moskow', @ArrivalAirport = 'Los-Angeles';

drop procedure sp_SearchFlight;



--------------------------------------------Procedure on Bookings----------------------------------------------
----Add Order------------------
go
Create procedure sp_NewAddOrder
	@id_user int,
	@id_flight int,
	@amount int,
	@price int
as
begin
	DECLARE @total int;
	declare @id_booking int;
	declare @DepFlight varchar(50);
	declare @ArrFlight varchar(50);
	declare @ClassFlight int;
	select @total = Flights.TotalPlaces from Flights where @id_flight = Flights.FlightId
	select @DepFlight = Flights.DepartureAirport from Flights where @id_flight = Flights.FlightId
	select @ArrFlight = Flights.ArrivalAirport from Flights where @id_flight = Flights.FlightId
	select @ClassFlight = Flights.FlightClass from Flights where @id_flight = Flights.FlightId

	if
	(@amount > @total) Raiserror(N'Seems the user that trying to delete does not exist',11,1)
	else
	insert into Bookings (PassengerId, FlightId,DepartureAirport,ArrivalAirport,Amount,Price,FlightClass) values(@id_user,@id_flight,@DepFlight,@ArrFlight,@amount,@price,@ClassFlight)
	select top (1) @id_booking = Bookings.BookingId from Bookings where Bookings.Price = @price order by Bookings.BookingDateTime;
	update Bookings set Bookings.Price *= @amount from Bookings where Bookings.BookingId = @id_booking;
	update Flights set Flights.TotalPlaces -= @amount from Flights where Flights.FlightId = @id_flight
end;

drop procedure sp_NewAddOrder;

exec sp_NewAddOrder @id_flight = 2, @id_user = 1, @amount = 5, @price = 3900;

----------------------------------------------------------------------------
----------------------------------------------------------------------------
go
Create procedure sp_OrderStatus
	@status varchar(50) = 'Confirmed',
	@id_booking int
as
begin
	update Bookings set Bookings.Status = @status from Bookings where Bookings.BookingId = @id_booking
end;

exec sp_OrderStatus @id_booking = 6;

----Delete Order--------------------------------------
go
Create procedure sp_DeleteOrder
	@id_booking int,
	@amount int
as
begin
	select @amount = Bookings.Amount from Bookings where Bookings.BookingId = @id_booking
	update Flights set Flights.TotalPlaces += @amount from Flights inner join Bookings on Flights.FlightId = Bookings.FlightId and Bookings.BookingId = @id_booking
	delete from Bookings where Bookings.BookingId = @id_booking
end;

exec sp_DeleteOrder @id_booking = 3, @amount = 8;

drop procedure sp_DeleteOrder;

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

exec sp_GetUserOrder @id_user = 1;

----Select order-----------------------------------
go 
Create procedure sp_ShowOrder
as
begin
	Select * from Bookings
end;

exec sp_ShowOrder;

--------------------------------------------Triggers and Procedure on Tickets----------------------------------------------
----—ƒ≈À¿“‹ ƒŒ¡¿¬À≈Õ»≈ ¡»À≈“¿ ◊≈–≈« “–»√≈– œ–» —–¿¡¿“€¬¿Õ»» œ–Œ÷≈ƒ”–€ »«Ã≈Õ≈Õ»≈ —“¿“”—¿ «¿ ¿«¿----


--------------------------------------------Procedure on Staff----------------------------------------------

----Add Personal in Staff table-----------------------------
go
create procedure sp_InsertStaff
	@FirstName nvarchar(50),
	@SecondName nvarchar(50),
	@LastName nvarchar(50),
	@Birthday date,
	@Post nvarchar(50),
	@Experience varchar(10),
	@Number varchar(20),
	@FlightId int
as
begin
	INSERT INTO Staff(FirstName,SecondName,LastName,Birthday,Post,Experience,Number,FlightId)
	values (@FirstName,@SecondName,@LastName,@Birthday,@Post,@Experience,@Number,@FlightId)
end;

exec sp_InsertStaff @FirstName = 'Yaskovich', @SecondName = 'Mark', @LastName = 'Eduardovich',
@Birthday = '19-04-2002', @Post = 'Pilot',@Experience = '2 „Ó‰‡',@Number = '+375298436373', @FlightId = 1;

drop procedure sp_InsertStaff;

----Delete Personal in Staff table-----------------------------
go
create procedure sp_DeleteStaff
	@id_person int
as
begin
	delete Staff where Staff.PersonalId = @id_person
end;

exec sp_DeleteStaff @id_person = 1;

----Update Personal information in Staff table------------------
go
create procedure sp_UpdateStaffInfo
	@PersonId int,
	@FirstName nvarchar(50),
	@SecondName nvarchar(50),
	@LastName nvarchar(50),
	@Birthday date,
	@Post nvarchar(50),
	@Experience varchar(10),
	@Number varchar(20),
	@FlightId int
as
begin
	update Staff set Staff.FirstName = @FirstName where Staff.PersonalId = @PersonId
	update Staff set Staff.SecondName = @SecondName where Staff.PersonalId = @PersonId
	update Staff set Staff.LastName = @LastName where Staff.PersonalId = @PersonId
	update Staff set Staff.Birthday = @Birthday where Staff.PersonalId = @PersonId
	update Staff set Staff.Post = @Post where Staff.PersonalId = @PersonId
	update Staff set Staff.Experience = @Experience where Staff.PersonalId = @PersonId
	update Staff set Staff.Number = @Number where Staff.PersonalId = @PersonId
	update Staff set Staff.FlightId = @FlightId where Staff.PersonalId = @PersonId
end;

------------Shows which pilot is on which flight-------------------------------------
go
create procedure sp_GetStaffOnFlight
	@id_person int
as
begin try
	select Flights.FlightId,Staff.FirstName, Staff.SecondName, Staff.LastName, Staff.Post, Flights.DepartureAirport,Flights.ArrivalAirport, Flights.ArrivalAirport
	from Staff inner join 
	Flights on Flights.FlightId = Staff.FlightId and Staff.PersonalId = @id_person
end try
begin catch
	rollback
	SELECT ERROR_MESSAGE() AS ErrorMessage;
end catch

drop procedure sp_GetStaffOnFlight;

exec sp_GetStaffOnFlight @id_person = 2;

-------------Shows all staff in table------------
go
create procedure sp_ShowStaff
as
begin
	select * from Staff;
end;

exec sp_ShowStaff;
----------------------------------Procedure on Statistics--------------------------
go
create procedure sp_CompletedCount
as
begin
	DECLARE @statusConfirmed int;
	DECLARE @statusCanceled int;
	DECLARE @Profit int;
	----
	Declare @Oneclass decimal;
	Declare @Twoclass decimal;
	Declare @Delenie decimal;
	----
	select @statusConfirmed = (select COUNT(*) from Flights where Flights.Status = 'Completed')
	select @statusCanceled = (select COUNT(*) from Flights where Flights.Status = 'Canceled')
	select @Profit =SUM(Price) from Bookings where CAST(BookingDateTime AS time)   BETWEEN CAST('2022-12-19 21:26:18.557' AS time) AND CAST('2022-12-19 21:36:45.180' AS time) and Status = 'Confirmed';
	select @Oneclass = count(*) from Bookings where FlightClass = '1';
	select @Twoclass = count(*) from Bookings where FlightClass = '2';
	select @Delenie = @Oneclass/@Twoclass;

	insert into Statistic(ConfirmedFlightsCount,CanceledFlightCount,Profit,Ratio)
	values (@statusConfirmed,@statusCanceled,@Profit,@Delenie)
	select*from Statistic
end;

exec sp_CompletedCount;
drop procedure sp_CompletedCount; 
truncate table Statistic;

go
create procedure sp_ShowStatistic
as
begin
	select * from Statistic
end;

exec sp_ShowStatistic;

drop procedure sp_CompletedCount;