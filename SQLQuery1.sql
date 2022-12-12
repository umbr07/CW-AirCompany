--use AirCompany;


create table Bookings (
	BookingId int not null IDENTITY PRIMARY KEY,
	PassengerId int not null,
	BookingDateTime datetime DEFAULT GETDATE(),
	FlightId int not null,
	Amount int not null,
	Price int not null,
	Status varchar(50) not null DEFAULT 'Waiting'
)
drop table Bookings;


----янгдюрэ рюакхжс юмюкхгю деърекэмнярх йнлоюмхх------------------

----янгдюрэ рюакхжс оепяннмюкю х охкнрнб йнрнпше мюундъряъ мю пеияе------------------
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

----намнбхрэ рюакхжс ющпнонпрнб х днаюбхрэ рхо ющпнонпрю------------------
----ондслюрэ йюй ядекюрэ опюбхкэмн----------------------------------------
--create table Airports (
--	AirportCode varchar(50) not null PRIMARY KEY,
--	Name varchar(50) not null,
--	City varchar(50) not null,
--	AirportType varchar(50) not null
--)


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

--Update User---онд бнопнянл еы╗ йюй опюбхкэмн ядекюрэ вепег опхкнфемхе---
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


--------------------------------------------Procedure on Airports----------------------------------------------
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


--------------------------------------------Procedure on Flights----------------------------------------------

------------------днаюбхрэ ярюрся пеияю (гюйнмвем хкх б опнжеяяе)--------------------------------
------------------еякх гюйнмвем,рн оняке хд╗р ондяв╗р гюйнмвеммшу пеиянб х ме гюйнмвеммшу х ху яннрмньемхе--------------------

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



--------------------------------------------Procedure on Bookings----------------------------------------------
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

exec sp_NewAddOrder @id_user = 1, @id_flight = 1, @amount = 8, @price = 3200;

----намнбкемхе ярюрсяю гюйюгю вепег кхвмши йюахмер онкэгнбюрекъ----днаюбхрэ онке OrderStatus-------------------------
----намнбкемхе ярюрсяю гюйюгю вепег оюмекэ юдлхмхярпюрнпю------------------------------------------------------------
go
Create procedure sp_OrderStatus
	@status varchar(50) = 'Confirmed',
	@id_booking int
as
begin
	update Bookings set Bookings.Status = @status from Bookings where Bookings.BookingId = @id_booking
end;

exec sp_OrderStatus @id_booking = 1;

----Delete Order----дндекюрэ сдюкемхе он йнккхвеярбс ахкернб-----------------------------------------
----ме онкмне сдюкемхе гюйюгю, ю вюярхвмне сдюкемхе
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

exec sp_GetUserOrder @id_user = 2;

----Select order-----------------------------------
go 
Create procedure sp_ShowOrder
as
begin
	Select * from Bookings
end;

--------------------------------------------Triggers and Procedure on Tickets----------------------------------------------
----ядекюрэ днаюбкемхе ахкерю вепег рпхцеп опх япюаюршбюмхх опнжедспш хглемемхе ярюрсяю гюйюгю----
--create trigger Add_to_Tickets
--on Bookings
--after insert
	
--as
--insert into Tickets(


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

exec sp_InsertStaff @FirstName = 'Yaskovish', @SecondName = 'Mark', @LastName = 'Eduardovich',
@Birthday = '19-04-2002', @Post = 'Pilot',@Experience = '2 ЦНДЮ',@Number = '+375298436373', @FlightId = 1;

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
--go
--create procedure sp_GetStaffOnFlight
--	@id_person int
--as
--begin try
--	select Flights.FlightId,Staff.FirstName, Staff.SecondName, Staff.LastName, Staff.Post, Flights.DepartureAirport, Flights.ArrivalAirport
--	from Staff inner join 
--	Flights on Flights.FlightId = Staff.FlightId and Staff.PersonalId = @id_person
--end try
--begin catch
--	rollback
--	SELECT ERROR_MESSAGE() AS ErrorMessage;
--end catch

--drop procedure sp_GetStaffOnFlight;

--exec sp_GetStaffOnFlight @id_person = 1;