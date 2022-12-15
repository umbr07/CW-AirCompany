use AirCompany;

--Export products proc
go 
create procedure ExProdToXml
as
begin
	select Id, Login, Password, FirstName, LastName, Email,Roles from Users
		for xml path('User'), root('Users');

	EXEC master.dbo.sp_configure 'show advanced options', 1
		reconfigure with override
	EXEC master .dbo.sp_configure 'xp_cmdshell', 1
		reconfigure with override;

	declare @fileName nvarchar(100)
	declare @sqlStr varchar(1000)
	declare @sqlCmd varchar(1000)
	
	set @fileName = 'D:\Учёба\3 курс\1 семестр\CursWork\CourseWork\export.xml';
	set @sqlStr = 'USE AirCompany; select Id, Login, Password, FirstName, LastName, Email,Roles from Users FOR XML PATH(''User''), ROOT(''Users'') '
	set @sqlCmd = 'bcp.exe "' + @sqlStr + '" queryout ' + @fileName + ' -w -T'
	EXEC xp_cmdshell @sqlCmd;
end;

drop procedure ExProdToXml;

exec ExProdToXml;

--Import product proc 
go
Create Procedure ImProdfromXml
AS
Begin
	INSERT INTO Users (Id, Login, Password, FirstName, LastName, Email, Roles)
	SELECT
	   MY_XML.User.query('Id').value('.', 'INT'),
	   MY_XML.User.query('Login').value('.', 'VARCHAR(50)'),
	   MY_XML.User.query('Password').value('.', 'VARCHAR(50)'),
	   MY_XML.User.query('FirstName').value('.', 'NVARCHAR(50)'),
	   MY_XML.User.query('LastName').value('.', 'NVARCHAR(50)'),
	   MY_XML.User.query('Email').value('.', 'VARCHAR(50)')
	   MY_XML.User.query('Roles').value('.', 'INT')

	FROM (SELECT CAST(MY_XML AS xml)
		  FROM OPENROWSET(BULK 'E:\3rd-course\1st-sem\DB\CW\Backups\Import.xml', SINGLE_BLOB) AS T(MY_XML)) AS T(MY_XML)
		  CROSS APPLY MY_XML.nodes('PRODUCTS/PRODUCT') AS MY_XML (PRODUCT);
End;

drop procedure ImProdfromXml;

Exec ImProdfromXml;