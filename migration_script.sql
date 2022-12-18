-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: AirCompany
-- Source Schemata: AirCompany
-- Created: Mon Dec 19 00:06:27 2022
-- Workbench Version: 8.0.31
-- ----------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Schema AirCompany
-- ----------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `AirCompany` ;
CREATE SCHEMA IF NOT EXISTS `AirCompany` ;

-- ----------------------------------------------------------------------------
-- Table AirCompany.Staff
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirCompany`.`Staff` (
  `PersonalId` INT NOT NULL,
  `FirstName` VARCHAR(50) CHARACTER SET 'utf8mb4' NOT NULL,
  `SecondName` VARCHAR(50) CHARACTER SET 'utf8mb4' NOT NULL,
  `LastName` VARCHAR(50) CHARACTER SET 'utf8mb4' NOT NULL,
  `Birthday` DATE NOT NULL,
  `Post` VARCHAR(50) CHARACTER SET 'utf8mb4' NOT NULL,
  `Experience` VARCHAR(10) NOT NULL,
  `Number` VARCHAR(20) NOT NULL,
  `FlightId` INT NOT NULL,
  PRIMARY KEY (`PersonalId`));

-- ----------------------------------------------------------------------------
-- Table AirCompany.Statistic
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirCompany`.`Statistic` (
  `ConfirmedFlightsCount` INT NOT NULL,
  `CanceledFlightCount` INT NOT NULL,
  `Profit` INT NULL);

-- ----------------------------------------------------------------------------
-- Table AirCompany.Users
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirCompany`.`Users` (
  `Id` INT NOT NULL,
  `Login` VARCHAR(50) NOT NULL,
  `Password` VARCHAR(50) NOT NULL,
  `FirstName` VARCHAR(50) CHARACTER SET 'utf8mb4' NOT NULL,
  `LastName` VARCHAR(50) CHARACTER SET 'utf8mb4' NOT NULL,
  `Email` VARCHAR(50) NOT NULL,
  `Roles` INT NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`));

-- ----------------------------------------------------------------------------
-- Table AirCompany.Flights
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirCompany`.`Flights` (
  `FlightId` INT NOT NULL,
  `FlightNumber` INT NOT NULL,
  `DepartureDateTime` DATETIME(6) NOT NULL,
  `DepartureAirport` VARCHAR(50) NOT NULL,
  `TotalPlaces` INT NOT NULL,
  `ArrivalDateTime` DATETIME(6) NOT NULL,
  `ArrivalAirport` VARCHAR(50) NOT NULL,
  `Price` INT NOT NULL,
  `Status` VARCHAR(50) NOT NULL DEFAULT 'In process',
  PRIMARY KEY (`FlightId`),
  CONSTRAINT `FK_Flights_Airports`
    FOREIGN KEY (`DepartureAirport`)
    REFERENCES `AirCompany`.`Airports` (`Name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Flights_Airports1`
    FOREIGN KEY (`ArrivalAirport`)
    REFERENCES `AirCompany`.`Airports` (`Name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table AirCompany.Airports
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirCompany`.`Airports` (
  `AirportCode` VARCHAR(50) NOT NULL,
  `Name` VARCHAR(50) NOT NULL,
  `City` VARCHAR(50) NULL,
  `AirportType` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Name`));

-- ----------------------------------------------------------------------------
-- Table AirCompany.Bookings
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirCompany`.`Bookings` (
  `BookingId` INT NOT NULL,
  `PassengerId` INT NOT NULL,
  `BookingDateTime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `FlightId` INT NOT NULL,
  `Amount` INT NOT NULL,
  `Price` INT NOT NULL,
  `Status` VARCHAR(50) NOT NULL DEFAULT 'Waiting',
  PRIMARY KEY (`BookingId`),
  CONSTRAINT `FK_Bookings_Users`
    FOREIGN KEY (`PassengerId`)
    REFERENCES `AirCompany`.`Users` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Bookings_Flights`
    FOREIGN KEY (`FlightId`)
    REFERENCES `AirCompany`.`Flights` (`FlightId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- ----------------------------------------------------------------------------
-- Table AirCompany.sysdiagrams
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirCompany`.`sysdiagrams` (
  `name` VARCHAR(160) NOT NULL,
  `principal_id` INT NOT NULL,
  `diagram_id` INT NOT NULL,
  `version` INT NULL,
  `definition` LONGBLOB NULL,
  PRIMARY KEY (`diagram_id`),
  UNIQUE INDEX `UK_principal_name` (`principal_id` ASC, `name` ASC) VISIBLE);

-- ----------------------------------------------------------------------------
-- Table AirCompany.Tickets
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `AirCompany`.`Tickets` (
  `TicketId` INT NOT NULL,
  `BuyerId` INT NULL,
  `FirstName` VARCHAR(50) CHARACTER SET 'utf8mb4' NULL,
  `LastName` VARCHAR(50) CHARACTER SET 'utf8mb4' NULL,
  `FlightId` INT NULL,
  PRIMARY KEY (`TicketId`));

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_SelectUsersInUser
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_SelectUsersInUser
-- 	@id_users int out
-- as
-- begin
-- 	Select * from Users where Users.Id = @id_users
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_AddFlight
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_AddFlight
-- 	@Flightnumber int,
-- 	@DepartureDatetime datetime,
-- 	@Departureairport varchar(50),
-- 	@Totalplaces int, --ограничение 
-- 	@ArrivalDatetime datetime,
-- 	@Arrivalairport varchar(50),
-- 	@price int
-- as
-- begin
-- 	insert into Flights(FlightNumber, DepartureDateTime, DepartureAirport, TotalPlaces, ArrivalDateTime,ArrivalAirport,Price)
-- 	values (@Flightnumber, @DepartureDatetime, @Departureairport, @Totalplaces,@ArrivalDatetime, @Arrivalairport, @price)
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_DeleteFlight
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_DeleteFlight
-- 	@Flights_id int
-- as
-- begin
-- 	Delete Flights where Flights.FlightId = @Flights_id
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_UpdateInfoFlight
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_UpdateInfoFlight
-- 	@Flights_id int,
-- 	@Flightnumber int,
-- 	@DepartureDatetime datetime,
-- 	@Departureairport varchar(50),
-- 	@Totalplaces int,
-- 	@ArrivalDatetime datetime,
-- 	@Arrivalairport varchar(50),
-- 	@price int
-- as
-- begin
-- 	update Flights set Flights.FlightNumber = @Flightnumber where Flights.FlightId = @Flights_id
-- 	update Flights set Flights.DepartureDateTime = @DepartureDatetime where Flights.FlightId = @Flights_id
-- 	update Flights set Flights.DepartureAirport = @Departureairport where Flights.FlightId = @Flights_id
-- 	update Flights set Flights.TotalPlaces = @Totalplaces where Flights.FlightId = @Flights_id
-- 	update Flights set Flights.ArrivalDateTime = @ArrivalDatetime where Flights.FlightId = @Flights_id
-- 	update Flights set Flights.ArrivalAirport = @Arrivalairport where Flights.FlightId = @Flights_id
-- 	update Flights set Flights.Price = @price where Flights.FlightId = @Flights_id
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_SearchFlight
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- create  OR REPLACE procedure sp_SearchFlight
-- 	@DepartureDatetime datetime = null,
-- 	@Departureairport varchar(50) = null,
-- 	@ArrivalAirport varchar(50) = null
-- as
-- begin try
-- 	if @DepartureDatetime is not null and @Departureairport is not null and @ArrivalAirport is not null
-- 		Select Flights.FlightNumber, Flights.DepartureDateTime, Flights.DepartureAirport, Flights.TotalPlaces, Flights.ArrivalDateTime, Flights.ArrivalAirport, Flights.Price
-- 		from Flights
-- 	else if @Departureairport is not null and @ArrivalAirport is not null
-- 		Select Flights.FlightNumber, Flights.DepartureDateTime, Flights.DepartureAirport, Flights.TotalPlaces, Flights.ArrivalDateTime, Flights.ArrivalAirport, Flights.Price
-- 		from Flights where Flights.DepartureAirport = @Departureairport and Flights.ArrivalAirport = @ArrivalAirport
-- end try
-- begin catch
-- 	rollback
-- 	select ERROR_MESSAGE() as ErrorMessage;
-- end catch;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_GetOrderById
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_GetOrderById
-- 	@id_booking int
-- as
-- begin
-- 	Select * from Bookings where Bookings.BookingId = @id_booking
-- end;
-- ;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_GetUserOrder
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_GetUserOrder
-- 	@id_user int
-- as
-- begin try
-- 	SELECT Bookings.BookingId, Flights.DepartureDateTime, Flights.DepartureAirport, 
-- 	Flights.ArrivalDateTime, Flights.ArrivalAirport, Bookings.Amount 
-- 	FROM Bookings INNER JOIN
-- 	Flights on Flights.FlightId = Bookings.FlightId and  Bookings.PassengerId = @id_user
-- end try 
-- begin catch
-- 	rollback
-- 	SELECT ERROR_MESSAGE() AS ErrorMessage;
-- end catch;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_ShowOrder
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_ShowOrder
-- as
-- begin
-- 	Select * from Bookings
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_DeleteOrder
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_DeleteOrder
-- 	@id_booking int,
-- 	@amount int
-- as
-- begin
-- 	select @amount = Bookings.Amount from Bookings where Bookings.BookingId = @id_booking
-- 	update Flights set Flights.TotalPlaces += @amount from Flights inner join Bookings on Flights.FlightId = Bookings.FlightId and Bookings.BookingId = @id_booking
-- 	delete from Bookings where Bookings.BookingId = @id_booking
-- end;
-- ;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_GetFlights
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_GetFlights
-- as
-- begin
-- 	select*from Flights
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_GetStaffOnFlight
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- create  OR REPLACE procedure sp_GetStaffOnFlight
-- 	@id_person int
-- as
-- begin try
-- 	select Flights.FlightId,Staff.FirstName, Staff.SecondName, Staff.LastName, Staff.Post, Flights.DepartureAirport, Flights.ArrivalAirport
-- 	from Staff inner join 
-- 	Flights on Flights.FlightId = Staff.FlightId and Staff.PersonalId = @id_person
-- end try
-- begin catch
-- 	rollback
-- 	SELECT ERROR_MESSAGE() AS ErrorMessage;
-- end catch
-- ;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_FlightStatusCompleted
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- create  OR REPLACE procedure sp_FlightStatusCompleted
-- 	@status varchar(50) = 'Completed',
-- 	@Flight_id int
-- as
-- begin
-- update Flights set Flights.Status = @status where Flights.FlightId = @Flight_id
-- end;
-- ;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_FlightStatusCanceled
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- create  OR REPLACE procedure sp_FlightStatusCanceled
-- 	@status varchar(50) = 'Canceled',
-- 	@Flight_id int
-- as
-- begin
-- update Flights set Flights.Status = @status where Flights.FlightId = @Flight_id
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_OrderStatus
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_OrderStatus
-- 	@status varchar(50) = 'Confirmed',
-- 	@id_booking int
-- as
-- begin
-- 	update Bookings set Bookings.Status = @status from Bookings where Bookings.BookingId = @id_booking
-- end;
-- ;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_CompletedCount
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- create  OR REPLACE procedure sp_CompletedCount
-- as
-- begin
-- 	DECLARE @statusConfirmed int;
-- 	DECLARE @statusCanceled int;
-- 	select @statusConfirmed = (select COUNT(*) from Flights where Flights.Status = 'Completed')
-- 	select @statusCanceled = (select COUNT(*) from Flights where Flights.Status = 'Canceled')
-- 	insert into Statistic(ConfirmedFlightsCount,CanceledFlightCount)
-- 	values (@statusConfirmed,@statusCanceled)
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_UpdateCount
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- create  OR REPLACE procedure sp_UpdateCount
-- as
-- begin
-- 	DECLARE @statusConfirmed int;
-- 	DECLARE @statusCanceled int;
-- 	select @statusConfirmed = (select COUNT(*) from Flights where Flights.Status = 'Completed')
-- 	select @statusCanceled = (select COUNT(*) from Flights where Flights.Status = 'Canceled')
-- 	update Statistic set Statistic.ConfirmedFlightsCount = @statusConfirmed
-- 	update Statistic set Statistic.CanceledFlightCount = @statusCanceled
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_DeleteStaff
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- create  OR REPLACE procedure sp_DeleteStaff
-- 	@id_person int
-- as
-- begin
-- 	delete Staff where Staff.PersonalId = @id_person
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.ExportXML
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- create    OR REPLACE procedure ExportXML
-- as
-- begin
-- 	select  Id, Login, Password, FirstName, LastName, Email, Roles from Users
-- 		for xml path('user'), root('users');
-- 
-- 	exec master.dbo.sp_configure 'show advanced options', 1
-- 		reconfigure with override;
-- 	exec master.dbo.sp_configure 'xp_cmdshell', 1
-- 		reconfigure with override;
-- 
-- 	declare @fileName nvarchar(100)
-- 	declare @sqlStr varchar(1000)
-- 	declare @sqlCmd varchar(1000)
-- 
-- 	set @fileName = 'D:\export.xml';
-- 	set @sqlStr = 'use AirCompany; select  Id, Login, Password, FirstName, LastName, Email, Roles from Users for xml path(''user''), root(''users'') ';
-- 	set @sqlCmd = 'bcp "' + @sqlStr + '" queryout ' + @fileName + ' -w -T -S WIN-I00JS7JRQF8\RDCB';
-- 	exec xp_cmdshell @sqlCmd;
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.ImportFromXML
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- create    OR REPLACE procedure ImportFromXML
-- as begin
-- DECLARE @xml XML;
-- 
-- SELECT @xml = CONVERT(xml, BulkColumn, 2) FROM OPENROWSET(BULK 'D:\Учёба\3 курс\1 семестр\CursWork\CourseWork\import.xml', SINGLE_BLOB) AS x
-- 
-- INSERT INTO  Users(Login, Password, FirstName, LastName, Email, Roles)
-- SELECT 
-- 	t.x.query('Login').value('.', 'varchar(50)') ,
-- 	t.x.query('Password').value('.', 'varchar(50)'),
-- 	t.x.query('FirstName').value('.', 'nvarchar(50)'),
-- 	t.x.query('LastName').value('.', 'nvarchar(50)'),
-- 	t.x.query('Email').value('.', 'varchar(50)'),
-- 	t.x.query('Roles').value('.', 'int')
-- FROM @xml.nodes('//Users/User') t(x)
-- end;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_InsertStaff
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- create  OR REPLACE procedure sp_InsertStaff
-- 	@FirstName nvarchar(50),
-- 	@SecondName nvarchar(50),
-- 	@LastName nvarchar(50),
-- 	@Birthday date,
-- 	@Post nvarchar(50),
-- 	@Experience varchar(10),
-- 	@Number varchar(20),
-- 	@FlightId int
-- as
-- begin
-- 	INSERT INTO Staff(FirstName,SecondName,LastName,Birthday,Post,Experience,Number,FlightId)
-- 	values (@FirstName,@SecondName,@LastName,@Birthday,@Post,@Experience,@Number,@FlightId)
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_UpdateStaffInfo
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- create  OR REPLACE procedure sp_UpdateStaffInfo
-- 	@PersonId int,
-- 	@FirstName nvarchar(50),
-- 	@SecondName nvarchar(50),
-- 	@LastName nvarchar(50),
-- 	@Birthday date,
-- 	@Post nvarchar(50),
-- 	@Experience varchar(10),
-- 	@Number varchar(20),
-- 	@FlightId int
-- as
-- begin
-- 	update Staff set Staff.FirstName = @FirstName where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.SecondName = @SecondName where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.LastName = @LastName where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.Birthday = @Birthday where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.Post = @Post where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.Experience = @Experience where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.Number = @Number where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.FlightId = @FlightId where Staff.PersonalId = @PersonId
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_SelectUsers
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- CREATE  OR REPLACE PROCEDURE sp_SelectUsers
-- AS
-- 	SELECT * FROM Users
-- 
-- ;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_InsertUsers
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- CREATE  OR REPLACE PROCEDURE sp_InsertUsers
-- 	@login nvarchar(50),
-- 	@password nvarchar(50),
-- 	@fname nvarchar(50),
-- 	@lname nvarchar(50),
-- 	@mail varchar(50)
-- AS
-- 	INSERT INTO Users(Login,Password,FirstName,LastName,Email)
-- 	VALUES(@login,@password,@fname,@lname,@mail)
-- 
-- ;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_upgraddiagrams
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_upgraddiagrams
-- 	AS
-- 	BEGIN
-- 		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
-- 			return 0;
-- 	
-- 		CREATE TABLE dbo.sysdiagrams
-- 		(
-- 			name sysname NOT NULL,
-- 			principal_id int NOT NULL,	-- we may change it to varbinary(85)
-- 			diagram_id int PRIMARY KEY IDENTITY,
-- 			version int,
-- 	
-- 			definition varbinary(max)
-- 			CONSTRAINT UK_principal_name UNIQUE
-- 			(
-- 				principal_id,
-- 				name
-- 			)
-- 		);
-- 
-- 
-- 		/* Add this if we need to have some form of extended properties for diagrams */
-- 		/*
-- 		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
-- 		BEGIN
-- 			CREATE TABLE dbo.sysdiagram_properties
-- 			(
-- 				diagram_id int,
-- 				name sysname,
-- 				value varbinary(max) NOT NULL
-- 			)
-- 		END
-- 		*/
-- 
-- 		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
-- 		begin
-- 			insert into dbo.sysdiagrams
-- 			(
-- 				[name],
-- 				[principal_id],
-- 				[version],
-- 				[definition]
-- 			)
-- 			select	 
-- 				convert(sysname, dgnm.[uvalue]),
-- 				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
-- 				0,							-- zero for old format, dgdef.[version],
-- 				dgdef.[lvalue]
-- 			from dbo.[dtproperties] dgnm
-- 				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
-- 				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
-- 				
-- 			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
-- 			return 2;
-- 		end
-- 		return 1;
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_NewAddOrder
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_NewAddOrder
-- 	@id_user int,
-- 	@id_flight int,
-- 	@amount int,
-- 	@price int
-- as
-- begin
-- 	DECLARE @total int;
-- 	declare @id_booking int;
-- 	select @total = Flights.TotalPlaces from Flights where @id_flight = Flights.FlightId
-- 	if
-- 	(@amount > @total) Raiserror(N'Seems the user that trying to delete does not exist',11,1)
-- 	else
-- 	insert into Bookings (PassengerId, FlightId,Amount,Price) values(@id_user,@id_flight,@amount,@price)
-- 	select top (1) @id_booking = Bookings.BookingId from Bookings where Bookings.Price = @price order by Bookings.BookingDateTime;
-- 	update Bookings set Bookings.Price *= @amount from Bookings where Bookings.BookingId = @id_booking;
-- 	update Flights set Flights.TotalPlaces -= @amount from Flights where Flights.FlightId = @id_flight
-- end;
-- ;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_helpdiagrams
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_helpdiagrams
-- 	(
-- 		@diagramname sysname = NULL,
-- 		@owner_id int = NULL
-- 	)
-- 	WITH EXECUTE AS N'dbo'
-- 	AS
-- 	BEGIN
-- 		DECLARE @user sysname
-- 		DECLARE @dboLogin bit
-- 		EXECUTE AS CALLER;
-- 			SET @user = USER_NAME();
-- 			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
-- 		REVERT;
-- 		SELECT
-- 			[Database] = DB_NAME(),
-- 			[Name] = name,
-- 			[ID] = diagram_id,
-- 			[Owner] = USER_NAME(principal_id),
-- 			[OwnerID] = principal_id
-- 		FROM
-- 			sysdiagrams
-- 		WHERE
-- 			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
-- 			(@diagramname IS NULL OR name = @diagramname) AND
-- 			(@owner_id IS NULL OR principal_id = @owner_id)
-- 		ORDER BY
-- 			4, 5, 1
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_helpdiagramdefinition
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_helpdiagramdefinition
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id	int	= null 		
-- 	)
-- 	WITH EXECUTE AS N'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 
-- 		declare @theId 		int
-- 		declare @IsDbo 		int
-- 		declare @DiagId		int
-- 		declare @UIDFound	int
-- 	
-- 		if(@diagramname is null)
-- 		begin
-- 			RAISERROR (N'E_INVALIDARG', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		execute as caller;
-- 		select @theId = DATABASE_PRINCIPAL_ID();
-- 		select @IsDbo = IS_MEMBER(N'db_owner');
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		revert; 
-- 	
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
-- 			return -3
-- 		end
-- 
-- 		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
-- 		return 0
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_creatediagram
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_creatediagram
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id		int	= null, 	
-- 		@version 		int,
-- 		@definition 	varbinary(max)
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 	
-- 		declare @theId int
-- 		declare @retval int
-- 		declare @IsDbo	int
-- 		declare @userName sysname
-- 		if(@version is null or @diagramname is null)
-- 		begin
-- 			RAISERROR (N'E_INVALIDARG', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		execute as caller;
-- 		select @theId = DATABASE_PRINCIPAL_ID(); 
-- 		select @IsDbo = IS_MEMBER(N'db_owner');
-- 		revert; 
-- 		
-- 		if @owner_id is null
-- 		begin
-- 			select @owner_id = @theId;
-- 		end
-- 		else
-- 		begin
-- 			if @theId <> @owner_id
-- 			begin
-- 				if @IsDbo = 0
-- 				begin
-- 					RAISERROR (N'E_INVALIDARG', 16, 1);
-- 					return -1
-- 				end
-- 				select @theId = @owner_id
-- 			end
-- 		end
-- 		-- next 2 line only for test, will be removed after define name unique
-- 		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
-- 		begin
-- 			RAISERROR ('The name is already used.', 16, 1);
-- 			return -2
-- 		end
-- 	
-- 		insert into dbo.sysdiagrams(name, principal_id , version, definition)
-- 				VALUES(@diagramname, @theId, @version, @definition) ;
-- 		
-- 		select @retval = @@IDENTITY 
-- 		return @retval
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_renamediagram
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_renamediagram
-- 	(
-- 		@diagramname 		sysname,
-- 		@owner_id		int	= null,
-- 		@new_diagramname	sysname
-- 	
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 		declare @theId 			int
-- 		declare @IsDbo 			int
-- 		
-- 		declare @UIDFound 		int
-- 		declare @DiagId			int
-- 		declare @DiagIdTarg		int
-- 		declare @u_name			sysname
-- 		if((@diagramname is null) or (@new_diagramname is null))
-- 		begin
-- 			RAISERROR ('Invalid value', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		EXECUTE AS CALLER;
-- 		select @theId = DATABASE_PRINCIPAL_ID();
-- 		select @IsDbo = IS_MEMBER(N'db_owner'); 
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		REVERT;
-- 	
-- 		select @u_name = USER_NAME(@owner_id)
-- 	
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
-- 			return -3
-- 		end
-- 	
-- 		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
-- 		--	return 0;
-- 	
-- 		if(@u_name is null)
-- 			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
-- 		else
-- 			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
-- 	
-- 		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
-- 		begin
-- 			RAISERROR ('The name is already used.', 16, 1);
-- 			return -2
-- 		end		
-- 	
-- 		if(@u_name is null)
-- 			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
-- 		else
-- 			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
-- 		return 0
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_alterdiagram
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_alterdiagram
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id	int	= null,
-- 		@version 	int,
-- 		@definition 	varbinary(max)
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 	
-- 		declare @theId 			int
-- 		declare @retval 		int
-- 		declare @IsDbo 			int
-- 		
-- 		declare @UIDFound 		int
-- 		declare @DiagId			int
-- 		declare @ShouldChangeUID	int
-- 	
-- 		if(@diagramname is null)
-- 		begin
-- 			RAISERROR ('Invalid ARG', 16, 1)
-- 			return -1
-- 		end
-- 	
-- 		execute as caller;
-- 		select @theId = DATABASE_PRINCIPAL_ID();	 
-- 		select @IsDbo = IS_MEMBER(N'db_owner'); 
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		revert;
-- 	
-- 		select @ShouldChangeUID = 0
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
-- 		
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
-- 			return -3
-- 		end
-- 	
-- 		if(@IsDbo <> 0)
-- 		begin
-- 			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
-- 			begin
-- 				select @ShouldChangeUID = 1 ;
-- 			end
-- 		end
-- 
-- 		-- update dds data			
-- 		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;
-- 
-- 		-- change owner
-- 		if(@ShouldChangeUID = 1)
-- 			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;
-- 
-- 		-- update dds version
-- 		if(@version is not null)
-- 			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;
-- 
-- 		return 0
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_dropdiagram
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- 
-- 	CREATE  OR REPLACE PROCEDURE dbo.sp_dropdiagram
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id	int	= null
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 		declare @theId 			int
-- 		declare @IsDbo 			int
-- 		
-- 		declare @UIDFound 		int
-- 		declare @DiagId			int
-- 	
-- 		if(@diagramname is null)
-- 		begin
-- 			RAISERROR ('Invalid value', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		EXECUTE AS CALLER;
-- 		select @theId = DATABASE_PRINCIPAL_ID();
-- 		select @IsDbo = IS_MEMBER(N'db_owner'); 
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		REVERT; 
-- 		
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
-- 			return -3
-- 		end
-- 	
-- 		delete from dbo.sysdiagrams where diagram_id = @DiagId;
-- 	
-- 		return 0;
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View AirCompany.fn_diagramobjects
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- 
-- 	CREATE  OR REPLACE FUNCTION dbo.fn_diagramobjects() 
-- 	RETURNS int
-- 	WITH EXECUTE AS N'dbo'
-- 	AS
-- 	BEGIN
-- 		declare @id_upgraddiagrams		int
-- 		declare @id_sysdiagrams			int
-- 		declare @id_helpdiagrams		int
-- 		declare @id_helpdiagramdefinition	int
-- 		declare @id_creatediagram	int
-- 		declare @id_renamediagram	int
-- 		declare @id_alterdiagram 	int 
-- 		declare @id_dropdiagram		int
-- 		declare @InstalledObjects	int
-- 
-- 		select @InstalledObjects = 0
-- 
-- 		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
-- 			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
-- 			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
-- 			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
-- 			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
-- 			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
-- 			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
-- 			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')
-- 
-- 		if @id_upgraddiagrams is not null
-- 			select @InstalledObjects = @InstalledObjects + 1
-- 		if @id_sysdiagrams is not null
-- 			select @InstalledObjects = @InstalledObjects + 2
-- 		if @id_helpdiagrams is not null
-- 			select @InstalledObjects = @InstalledObjects + 4
-- 		if @id_helpdiagramdefinition is not null
-- 			select @InstalledObjects = @InstalledObjects + 8
-- 		if @id_creatediagram is not null
-- 			select @InstalledObjects = @InstalledObjects + 16
-- 		if @id_renamediagram is not null
-- 			select @InstalledObjects = @InstalledObjects + 32
-- 		if @id_alterdiagram  is not null
-- 			select @InstalledObjects = @InstalledObjects + 64
-- 		if @id_dropdiagram is not null
-- 			select @InstalledObjects = @InstalledObjects + 128
-- 		
-- 		return @InstalledObjects 
-- 	END
-- 	;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_GetUser
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- CREATE  OR REPLACE PROCEDURE sp_GetUser
--  @login varchar(50), 
--  @password varchar(50),
--  @role int out
-- as 
-- begin
-- 	select Users.Login, Users.Password from Users where Users.Login = @login AND Users.Password = @password
-- 	SELECT @role = Users.Roles FROM Users where Users.Login = @login AND Users.Password = @password
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_SelectUsersInAdmin
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- CREATE  OR REPLACE PROCEDURE sp_SelectUsersInAdmin
-- as
-- begin
-- 	Select * from Users
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_UpdateInfoInAdminPanel
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- CREATE  OR REPLACE PROCEDURE sp_UpdateInfoInAdminPanel
-- 	@role int,
-- 	@id_users int,
-- 	@login varchar(50),
-- 	@password varchar(50),
-- 	@fname nvarchar(50),
-- 	@lname nvarchar(50),
-- 	@mail varchar(50)
-- as
-- begin
-- 	update Users set Users.Roles = @role, Users.Login = @login, Users.Password = @password, Users.FirstName = @fname, Users.LastName = @lname, Users.Email = @mail
-- 	where Users.Id = @id_users
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_DeleteUsers
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- CREATE  OR REPLACE PROCEDURE sp_DeleteUsers
-- 	@id_user int
-- as
-- begin
-- 	delete Users where Users.Id = @id_user
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_ShowAllAirports
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_ShowAllAirports
-- as
-- begin
-- 	select * from Airports
-- end;
-- ;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_DeleteAirports
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_DeleteAirports
-- 	@AirportCode varchar(50)
-- as
-- begin
-- 	delete Airports where Airports.AirportCode = @AirportCode
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_AddAirports
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_AddAirports
-- 	@AirportCode varchar(50),
-- 	@Name varchar(50),
-- 	@City varchar(50),
-- 	@AirportType varchar(50)
-- as
-- begin
-- 	INSERT INTO Airports(AirportCode,Name,City,AirportType) values (@AirportCode,@Name,@City,@AirportType)
-- end;;

-- ----------------------------------------------------------------------------
-- View AirCompany.sp_UpdateAirports
-- ----------------------------------------------------------------------------
-- USE `AirCompany`;
-- Create  OR REPLACE procedure sp_UpdateAirports
-- 	@AirportCode varchar(50),
-- 	@Name varchar(50),
-- 	@City varchar(50),
-- 	@AirportType varchar(50)
-- as
-- begin
-- 	update Airports set Airports.AirportCode = @AirportCode where Airports.AirportCode = @AirportCode
-- 	update Airports set Airports.Name = @Name where Airports.AirportCode = @AirportCode
-- 	update Airports set Airports.City = @City where Airports.AirportCode = @AirportCode
-- 	update Airports set Airports.AirportType = @AirportType where Airports.AirportCode = @AirportCode
-- end;;

-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_SelectUsersInUser
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_SelectUsersInUser
-- 	@id_users int out
-- as
-- begin
-- 	Select * from Users where Users.Id = @id_users
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_AddFlight
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_AddFlight
-- 	@Flightnumber int,
-- 	@DepartureDatetime datetime,
-- 	@Departureairport varchar(50),
-- 	@Totalplaces int, --ограничение 
-- 	@ArrivalDatetime datetime,
-- 	@Arrivalairport varchar(50),
-- 	@price int
-- as
-- begin
-- 	insert into Flights(FlightNumber, DepartureDateTime, DepartureAirport, TotalPlaces, ArrivalDateTime,ArrivalAirport,Price)
-- 	values (@Flightnumber, @DepartureDatetime, @Departureairport, @Totalplaces,@ArrivalDatetime, @Arrivalairport, @price)
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_DeleteFlight
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_DeleteFlight
-- 	@Flights_id int
-- as
-- begin
-- 	Delete Flights where Flights.FlightId = @Flights_id
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_UpdateInfoFlight
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_UpdateInfoFlight
-- 	@Flights_id int,
-- 	@Flightnumber int,
-- 	@DepartureDatetime datetime,
-- 	@Departureairport varchar(50),
-- 	@Totalplaces int,
-- 	@ArrivalDatetime datetime,
-- 	@Arrivalairport varchar(50),
-- 	@price int
-- as
-- begin
-- 	update Flights set Flights.FlightNumber = @Flightnumber where Flights.FlightId = @Flights_id
-- 	update Flights set Flights.DepartureDateTime = @DepartureDatetime where Flights.FlightId = @Flights_id
-- 	update Flights set Flights.DepartureAirport = @Departureairport where Flights.FlightId = @Flights_id
-- 	update Flights set Flights.TotalPlaces = @Totalplaces where Flights.FlightId = @Flights_id
-- 	update Flights set Flights.ArrivalDateTime = @ArrivalDatetime where Flights.FlightId = @Flights_id
-- 	update Flights set Flights.ArrivalAirport = @Arrivalairport where Flights.FlightId = @Flights_id
-- 	update Flights set Flights.Price = @price where Flights.FlightId = @Flights_id
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_SearchFlight
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- create procedure sp_SearchFlight
-- 	@DepartureDatetime datetime = null,
-- 	@Departureairport varchar(50) = null,
-- 	@ArrivalAirport varchar(50) = null
-- as
-- begin try
-- 	if @DepartureDatetime is not null and @Departureairport is not null and @ArrivalAirport is not null
-- 		Select Flights.FlightNumber, Flights.DepartureDateTime, Flights.DepartureAirport, Flights.TotalPlaces, Flights.ArrivalDateTime, Flights.ArrivalAirport, Flights.Price
-- 		from Flights
-- 	else if @Departureairport is not null and @ArrivalAirport is not null
-- 		Select Flights.FlightNumber, Flights.DepartureDateTime, Flights.DepartureAirport, Flights.TotalPlaces, Flights.ArrivalDateTime, Flights.ArrivalAirport, Flights.Price
-- 		from Flights where Flights.DepartureAirport = @Departureairport and Flights.ArrivalAirport = @ArrivalAirport
-- end try
-- begin catch
-- 	rollback
-- 	select ERROR_MESSAGE() as ErrorMessage;
-- end catch$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_GetOrderById
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_GetOrderById
-- 	@id_booking int
-- as
-- begin
-- 	Select * from Bookings where Bookings.BookingId = @id_booking
-- end;
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_GetUserOrder
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_GetUserOrder
-- 	@id_user int
-- as
-- begin try
-- 	SELECT Bookings.BookingId, Flights.DepartureDateTime, Flights.DepartureAirport, 
-- 	Flights.ArrivalDateTime, Flights.ArrivalAirport, Bookings.Amount 
-- 	FROM Bookings INNER JOIN
-- 	Flights on Flights.FlightId = Bookings.FlightId and  Bookings.PassengerId = @id_user
-- end try 
-- begin catch
-- 	rollback
-- 	SELECT ERROR_MESSAGE() AS ErrorMessage;
-- end catch$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_ShowOrder
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_ShowOrder
-- as
-- begin
-- 	Select * from Bookings
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_DeleteOrder
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_DeleteOrder
-- 	@id_booking int,
-- 	@amount int
-- as
-- begin
-- 	select @amount = Bookings.Amount from Bookings where Bookings.BookingId = @id_booking
-- 	update Flights set Flights.TotalPlaces += @amount from Flights inner join Bookings on Flights.FlightId = Bookings.FlightId and Bookings.BookingId = @id_booking
-- 	delete from Bookings where Bookings.BookingId = @id_booking
-- end;
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_GetFlights
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_GetFlights
-- as
-- begin
-- 	select*from Flights
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_GetStaffOnFlight
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- create procedure sp_GetStaffOnFlight
-- 	@id_person int
-- as
-- begin try
-- 	select Flights.FlightId,Staff.FirstName, Staff.SecondName, Staff.LastName, Staff.Post, Flights.DepartureAirport, Flights.ArrivalAirport
-- 	from Staff inner join 
-- 	Flights on Flights.FlightId = Staff.FlightId and Staff.PersonalId = @id_person
-- end try
-- begin catch
-- 	rollback
-- 	SELECT ERROR_MESSAGE() AS ErrorMessage;
-- end catch
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_FlightStatusCompleted
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- create procedure sp_FlightStatusCompleted
-- 	@status varchar(50) = 'Completed',
-- 	@Flight_id int
-- as
-- begin
-- update Flights set Flights.Status = @status where Flights.FlightId = @Flight_id
-- end;
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_FlightStatusCanceled
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- create procedure sp_FlightStatusCanceled
-- 	@status varchar(50) = 'Canceled',
-- 	@Flight_id int
-- as
-- begin
-- update Flights set Flights.Status = @status where Flights.FlightId = @Flight_id
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_OrderStatus
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_OrderStatus
-- 	@status varchar(50) = 'Confirmed',
-- 	@id_booking int
-- as
-- begin
-- 	update Bookings set Bookings.Status = @status from Bookings where Bookings.BookingId = @id_booking
-- end;
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_CompletedCount
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- create procedure sp_CompletedCount
-- as
-- begin
-- 	DECLARE @statusConfirmed int;
-- 	DECLARE @statusCanceled int;
-- 	select @statusConfirmed = (select COUNT(*) from Flights where Flights.Status = 'Completed')
-- 	select @statusCanceled = (select COUNT(*) from Flights where Flights.Status = 'Canceled')
-- 	insert into Statistic(ConfirmedFlightsCount,CanceledFlightCount)
-- 	values (@statusConfirmed,@statusCanceled)
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_UpdateCount
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- create procedure sp_UpdateCount
-- as
-- begin
-- 	DECLARE @statusConfirmed int;
-- 	DECLARE @statusCanceled int;
-- 	select @statusConfirmed = (select COUNT(*) from Flights where Flights.Status = 'Completed')
-- 	select @statusCanceled = (select COUNT(*) from Flights where Flights.Status = 'Canceled')
-- 	update Statistic set Statistic.ConfirmedFlightsCount = @statusConfirmed
-- 	update Statistic set Statistic.CanceledFlightCount = @statusCanceled
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_DeleteStaff
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- create procedure sp_DeleteStaff
-- 	@id_person int
-- as
-- begin
-- 	delete Staff where Staff.PersonalId = @id_person
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.ExportXML
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- create   procedure ExportXML
-- as
-- begin
-- 	select  Id, Login, Password, FirstName, LastName, Email, Roles from Users
-- 		for xml path('user'), root('users');
-- 
-- 	exec master.dbo.sp_configure 'show advanced options', 1
-- 		reconfigure with override;
-- 	exec master.dbo.sp_configure 'xp_cmdshell', 1
-- 		reconfigure with override;
-- 
-- 	declare @fileName nvarchar(100)
-- 	declare @sqlStr varchar(1000)
-- 	declare @sqlCmd varchar(1000)
-- 
-- 	set @fileName = 'D:\export.xml';
-- 	set @sqlStr = 'use AirCompany; select  Id, Login, Password, FirstName, LastName, Email, Roles from Users for xml path(''user''), root(''users'') ';
-- 	set @sqlCmd = 'bcp "' + @sqlStr + '" queryout ' + @fileName + ' -w -T -S WIN-I00JS7JRQF8\RDCB';
-- 	exec xp_cmdshell @sqlCmd;
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.ImportFromXML
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- create   procedure ImportFromXML
-- as begin
-- DECLARE @xml XML;
-- 
-- SELECT @xml = CONVERT(xml, BulkColumn, 2) FROM OPENROWSET(BULK 'D:\Учёба\3 курс\1 семестр\CursWork\CourseWork\import.xml', SINGLE_BLOB) AS x
-- 
-- INSERT INTO  Users(Login, Password, FirstName, LastName, Email, Roles)
-- SELECT 
-- 	t.x.query('Login').value('.', 'varchar(50)') ,
-- 	t.x.query('Password').value('.', 'varchar(50)'),
-- 	t.x.query('FirstName').value('.', 'nvarchar(50)'),
-- 	t.x.query('LastName').value('.', 'nvarchar(50)'),
-- 	t.x.query('Email').value('.', 'varchar(50)'),
-- 	t.x.query('Roles').value('.', 'int')
-- FROM @xml.nodes('//Users/User') t(x)
-- end$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_InsertStaff
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- create procedure sp_InsertStaff
-- 	@FirstName nvarchar(50),
-- 	@SecondName nvarchar(50),
-- 	@LastName nvarchar(50),
-- 	@Birthday date,
-- 	@Post nvarchar(50),
-- 	@Experience varchar(10),
-- 	@Number varchar(20),
-- 	@FlightId int
-- as
-- begin
-- 	INSERT INTO Staff(FirstName,SecondName,LastName,Birthday,Post,Experience,Number,FlightId)
-- 	values (@FirstName,@SecondName,@LastName,@Birthday,@Post,@Experience,@Number,@FlightId)
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_UpdateStaffInfo
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- create procedure sp_UpdateStaffInfo
-- 	@PersonId int,
-- 	@FirstName nvarchar(50),
-- 	@SecondName nvarchar(50),
-- 	@LastName nvarchar(50),
-- 	@Birthday date,
-- 	@Post nvarchar(50),
-- 	@Experience varchar(10),
-- 	@Number varchar(20),
-- 	@FlightId int
-- as
-- begin
-- 	update Staff set Staff.FirstName = @FirstName where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.SecondName = @SecondName where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.LastName = @LastName where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.Birthday = @Birthday where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.Post = @Post where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.Experience = @Experience where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.Number = @Number where Staff.PersonalId = @PersonId
-- 	update Staff set Staff.FlightId = @FlightId where Staff.PersonalId = @PersonId
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_SelectUsers
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- CREATE PROCEDURE sp_SelectUsers
-- AS
-- 	SELECT * FROM Users
-- 
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_InsertUsers
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- CREATE PROCEDURE sp_InsertUsers
-- 	@login nvarchar(50),
-- 	@password nvarchar(50),
-- 	@fname nvarchar(50),
-- 	@lname nvarchar(50),
-- 	@mail varchar(50)
-- AS
-- 	INSERT INTO Users(Login,Password,FirstName,LastName,Email)
-- 	VALUES(@login,@password,@fname,@lname,@mail)
-- 
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_upgraddiagrams
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_upgraddiagrams
-- 	AS
-- 	BEGIN
-- 		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
-- 			return 0;
-- 	
-- 		CREATE TABLE dbo.sysdiagrams
-- 		(
-- 			name sysname NOT NULL,
-- 			principal_id int NOT NULL,	-- we may change it to varbinary(85)
-- 			diagram_id int PRIMARY KEY IDENTITY,
-- 			version int,
-- 	
-- 			definition varbinary(max)
-- 			CONSTRAINT UK_principal_name UNIQUE
-- 			(
-- 				principal_id,
-- 				name
-- 			)
-- 		);
-- 
-- 
-- 		/* Add this if we need to have some form of extended properties for diagrams */
-- 		/*
-- 		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
-- 		BEGIN
-- 			CREATE TABLE dbo.sysdiagram_properties
-- 			(
-- 				diagram_id int,
-- 				name sysname,
-- 				value varbinary(max) NOT NULL
-- 			)
-- 		END
-- 		*/
-- 
-- 		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
-- 		begin
-- 			insert into dbo.sysdiagrams
-- 			(
-- 				[name],
-- 				[principal_id],
-- 				[version],
-- 				[definition]
-- 			)
-- 			select	 
-- 				convert(sysname, dgnm.[uvalue]),
-- 				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
-- 				0,							-- zero for old format, dgdef.[version],
-- 				dgdef.[lvalue]
-- 			from dbo.[dtproperties] dgnm
-- 				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
-- 				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
-- 				
-- 			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
-- 			return 2;
-- 		end
-- 		return 1;
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_NewAddOrder
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_NewAddOrder
-- 	@id_user int,
-- 	@id_flight int,
-- 	@amount int,
-- 	@price int
-- as
-- begin
-- 	DECLARE @total int;
-- 	declare @id_booking int;
-- 	select @total = Flights.TotalPlaces from Flights where @id_flight = Flights.FlightId
-- 	if
-- 	(@amount > @total) Raiserror(N'Seems the user that trying to delete does not exist',11,1)
-- 	else
-- 	insert into Bookings (PassengerId, FlightId,Amount,Price) values(@id_user,@id_flight,@amount,@price)
-- 	select top (1) @id_booking = Bookings.BookingId from Bookings where Bookings.Price = @price order by Bookings.BookingDateTime;
-- 	update Bookings set Bookings.Price *= @amount from Bookings where Bookings.BookingId = @id_booking;
-- 	update Flights set Flights.TotalPlaces -= @amount from Flights where Flights.FlightId = @id_flight
-- end;
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_helpdiagrams
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_helpdiagrams
-- 	(
-- 		@diagramname sysname = NULL,
-- 		@owner_id int = NULL
-- 	)
-- 	WITH EXECUTE AS N'dbo'
-- 	AS
-- 	BEGIN
-- 		DECLARE @user sysname
-- 		DECLARE @dboLogin bit
-- 		EXECUTE AS CALLER;
-- 			SET @user = USER_NAME();
-- 			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
-- 		REVERT;
-- 		SELECT
-- 			[Database] = DB_NAME(),
-- 			[Name] = name,
-- 			[ID] = diagram_id,
-- 			[Owner] = USER_NAME(principal_id),
-- 			[OwnerID] = principal_id
-- 		FROM
-- 			sysdiagrams
-- 		WHERE
-- 			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
-- 			(@diagramname IS NULL OR name = @diagramname) AND
-- 			(@owner_id IS NULL OR principal_id = @owner_id)
-- 		ORDER BY
-- 			4, 5, 1
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_helpdiagramdefinition
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_helpdiagramdefinition
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id	int	= null 		
-- 	)
-- 	WITH EXECUTE AS N'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 
-- 		declare @theId 		int
-- 		declare @IsDbo 		int
-- 		declare @DiagId		int
-- 		declare @UIDFound	int
-- 	
-- 		if(@diagramname is null)
-- 		begin
-- 			RAISERROR (N'E_INVALIDARG', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		execute as caller;
-- 		select @theId = DATABASE_PRINCIPAL_ID();
-- 		select @IsDbo = IS_MEMBER(N'db_owner');
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		revert; 
-- 	
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
-- 			return -3
-- 		end
-- 
-- 		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
-- 		return 0
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_creatediagram
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_creatediagram
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id		int	= null, 	
-- 		@version 		int,
-- 		@definition 	varbinary(max)
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 	
-- 		declare @theId int
-- 		declare @retval int
-- 		declare @IsDbo	int
-- 		declare @userName sysname
-- 		if(@version is null or @diagramname is null)
-- 		begin
-- 			RAISERROR (N'E_INVALIDARG', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		execute as caller;
-- 		select @theId = DATABASE_PRINCIPAL_ID(); 
-- 		select @IsDbo = IS_MEMBER(N'db_owner');
-- 		revert; 
-- 		
-- 		if @owner_id is null
-- 		begin
-- 			select @owner_id = @theId;
-- 		end
-- 		else
-- 		begin
-- 			if @theId <> @owner_id
-- 			begin
-- 				if @IsDbo = 0
-- 				begin
-- 					RAISERROR (N'E_INVALIDARG', 16, 1);
-- 					return -1
-- 				end
-- 				select @theId = @owner_id
-- 			end
-- 		end
-- 		-- next 2 line only for test, will be removed after define name unique
-- 		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
-- 		begin
-- 			RAISERROR ('The name is already used.', 16, 1);
-- 			return -2
-- 		end
-- 	
-- 		insert into dbo.sysdiagrams(name, principal_id , version, definition)
-- 				VALUES(@diagramname, @theId, @version, @definition) ;
-- 		
-- 		select @retval = @@IDENTITY 
-- 		return @retval
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_renamediagram
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_renamediagram
-- 	(
-- 		@diagramname 		sysname,
-- 		@owner_id		int	= null,
-- 		@new_diagramname	sysname
-- 	
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 		declare @theId 			int
-- 		declare @IsDbo 			int
-- 		
-- 		declare @UIDFound 		int
-- 		declare @DiagId			int
-- 		declare @DiagIdTarg		int
-- 		declare @u_name			sysname
-- 		if((@diagramname is null) or (@new_diagramname is null))
-- 		begin
-- 			RAISERROR ('Invalid value', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		EXECUTE AS CALLER;
-- 		select @theId = DATABASE_PRINCIPAL_ID();
-- 		select @IsDbo = IS_MEMBER(N'db_owner'); 
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		REVERT;
-- 	
-- 		select @u_name = USER_NAME(@owner_id)
-- 	
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
-- 			return -3
-- 		end
-- 	
-- 		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
-- 		--	return 0;
-- 	
-- 		if(@u_name is null)
-- 			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
-- 		else
-- 			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
-- 	
-- 		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
-- 		begin
-- 			RAISERROR ('The name is already used.', 16, 1);
-- 			return -2
-- 		end		
-- 	
-- 		if(@u_name is null)
-- 			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
-- 		else
-- 			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
-- 		return 0
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_alterdiagram
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_alterdiagram
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id	int	= null,
-- 		@version 	int,
-- 		@definition 	varbinary(max)
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 	
-- 		declare @theId 			int
-- 		declare @retval 		int
-- 		declare @IsDbo 			int
-- 		
-- 		declare @UIDFound 		int
-- 		declare @DiagId			int
-- 		declare @ShouldChangeUID	int
-- 	
-- 		if(@diagramname is null)
-- 		begin
-- 			RAISERROR ('Invalid ARG', 16, 1)
-- 			return -1
-- 		end
-- 	
-- 		execute as caller;
-- 		select @theId = DATABASE_PRINCIPAL_ID();	 
-- 		select @IsDbo = IS_MEMBER(N'db_owner'); 
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		revert;
-- 	
-- 		select @ShouldChangeUID = 0
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
-- 		
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
-- 			return -3
-- 		end
-- 	
-- 		if(@IsDbo <> 0)
-- 		begin
-- 			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
-- 			begin
-- 				select @ShouldChangeUID = 1 ;
-- 			end
-- 		end
-- 
-- 		-- update dds data			
-- 		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;
-- 
-- 		-- change owner
-- 		if(@ShouldChangeUID = 1)
-- 			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;
-- 
-- 		-- update dds version
-- 		if(@version is not null)
-- 			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;
-- 
-- 		return 0
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_dropdiagram
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- 
-- 	CREATE PROCEDURE dbo.sp_dropdiagram
-- 	(
-- 		@diagramname 	sysname,
-- 		@owner_id	int	= null
-- 	)
-- 	WITH EXECUTE AS 'dbo'
-- 	AS
-- 	BEGIN
-- 		set nocount on
-- 		declare @theId 			int
-- 		declare @IsDbo 			int
-- 		
-- 		declare @UIDFound 		int
-- 		declare @DiagId			int
-- 	
-- 		if(@diagramname is null)
-- 		begin
-- 			RAISERROR ('Invalid value', 16, 1);
-- 			return -1
-- 		end
-- 	
-- 		EXECUTE AS CALLER;
-- 		select @theId = DATABASE_PRINCIPAL_ID();
-- 		select @IsDbo = IS_MEMBER(N'db_owner'); 
-- 		if(@owner_id is null)
-- 			select @owner_id = @theId;
-- 		REVERT; 
-- 		
-- 		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
-- 		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
-- 		begin
-- 			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
-- 			return -3
-- 		end
-- 	
-- 		delete from dbo.sysdiagrams where diagram_id = @DiagId;
-- 	
-- 		return 0;
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_GetUser
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- CREATE PROCEDURE sp_GetUser
--  @login varchar(50), 
--  @password varchar(50),
--  @role int out
-- as 
-- begin
-- 	select Users.Login, Users.Password from Users where Users.Login = @login AND Users.Password = @password
-- 	SELECT @role = Users.Roles FROM Users where Users.Login = @login AND Users.Password = @password
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_SelectUsersInAdmin
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- CREATE PROCEDURE sp_SelectUsersInAdmin
-- as
-- begin
-- 	Select * from Users
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_UpdateInfoInAdminPanel
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- CREATE PROCEDURE sp_UpdateInfoInAdminPanel
-- 	@role int,
-- 	@id_users int,
-- 	@login varchar(50),
-- 	@password varchar(50),
-- 	@fname nvarchar(50),
-- 	@lname nvarchar(50),
-- 	@mail varchar(50)
-- as
-- begin
-- 	update Users set Users.Roles = @role, Users.Login = @login, Users.Password = @password, Users.FirstName = @fname, Users.LastName = @lname, Users.Email = @mail
-- 	where Users.Id = @id_users
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_DeleteUsers
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- CREATE PROCEDURE sp_DeleteUsers
-- 	@id_user int
-- as
-- begin
-- 	delete Users where Users.Id = @id_user
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_ShowAllAirports
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_ShowAllAirports
-- as
-- begin
-- 	select * from Airports
-- end;
-- $$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_DeleteAirports
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_DeleteAirports
-- 	@AirportCode varchar(50)
-- as
-- begin
-- 	delete Airports where Airports.AirportCode = @AirportCode
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_AddAirports
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_AddAirports
-- 	@AirportCode varchar(50),
-- 	@Name varchar(50),
-- 	@City varchar(50),
-- 	@AirportType varchar(50)
-- as
-- begin
-- 	INSERT INTO Airports(AirportCode,Name,City,AirportType) values (@AirportCode,@Name,@City,@AirportType)
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.sp_UpdateAirports
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- Create procedure sp_UpdateAirports
-- 	@AirportCode varchar(50),
-- 	@Name varchar(50),
-- 	@City varchar(50),
-- 	@AirportType varchar(50)
-- as
-- begin
-- 	update Airports set Airports.AirportCode = @AirportCode where Airports.AirportCode = @AirportCode
-- 	update Airports set Airports.Name = @Name where Airports.AirportCode = @AirportCode
-- 	update Airports set Airports.City = @City where Airports.AirportCode = @AirportCode
-- 	update Airports set Airports.AirportType = @AirportType where Airports.AirportCode = @AirportCode
-- end;$$
-- 
-- DELIMITER ;
-- 
-- ----------------------------------------------------------------------------
-- Routine AirCompany.fn_diagramobjects
-- ----------------------------------------------------------------------------
-- DELIMITER $$
-- 
-- DELIMITER $$
-- USE `AirCompany`$$
-- 
-- 	CREATE FUNCTION dbo.fn_diagramobjects() 
-- 	RETURNS int
-- 	WITH EXECUTE AS N'dbo'
-- 	AS
-- 	BEGIN
-- 		declare @id_upgraddiagrams		int
-- 		declare @id_sysdiagrams			int
-- 		declare @id_helpdiagrams		int
-- 		declare @id_helpdiagramdefinition	int
-- 		declare @id_creatediagram	int
-- 		declare @id_renamediagram	int
-- 		declare @id_alterdiagram 	int 
-- 		declare @id_dropdiagram		int
-- 		declare @InstalledObjects	int
-- 
-- 		select @InstalledObjects = 0
-- 
-- 		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
-- 			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
-- 			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
-- 			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
-- 			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
-- 			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
-- 			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
-- 			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')
-- 
-- 		if @id_upgraddiagrams is not null
-- 			select @InstalledObjects = @InstalledObjects + 1
-- 		if @id_sysdiagrams is not null
-- 			select @InstalledObjects = @InstalledObjects + 2
-- 		if @id_helpdiagrams is not null
-- 			select @InstalledObjects = @InstalledObjects + 4
-- 		if @id_helpdiagramdefinition is not null
-- 			select @InstalledObjects = @InstalledObjects + 8
-- 		if @id_creatediagram is not null
-- 			select @InstalledObjects = @InstalledObjects + 16
-- 		if @id_renamediagram is not null
-- 			select @InstalledObjects = @InstalledObjects + 32
-- 		if @id_alterdiagram  is not null
-- 			select @InstalledObjects = @InstalledObjects + 64
-- 		if @id_dropdiagram is not null
-- 			select @InstalledObjects = @InstalledObjects + 128
-- 		
-- 		return @InstalledObjects 
-- 	END
-- 	$$
-- 
-- DELIMITER ;
-- SET FOREIGN_KEY_CHECKS = 1;
