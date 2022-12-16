use AirCompany;

--Export products proc
go
create or alter procedure ExportXML
as
begin
	select  Id, Login, Password, FirstName, LastName, Email, Roles from Users
		for xml path('user'), root('users');

	exec master.dbo.sp_configure 'show advanced options', 1
		reconfigure with override;
	exec master.dbo.sp_configure 'xp_cmdshell', 1
		reconfigure with override;

	declare @fileName nvarchar(100)
	declare @sqlStr varchar(1000)
	declare @sqlCmd varchar(1000)

	set @fileName = 'D:\export.xml';
	set @sqlStr = 'use AirCompany; select  Id, Login, Password, FirstName, LastName, Email, Roles from Users for xml path(''user''), root(''users'') ';
	set @sqlCmd = 'bcp "' + @sqlStr + '" queryout ' + @fileName + ' -w -T -S WIN-I00JS7JRQF8\RDCB';
	exec xp_cmdshell @sqlCmd;
end;

drop procedure ExportXML;

exec ExportXML;

--Import user procedure 
go
create or alter procedure ImportFromXML
as begin
DECLARE @xml XML;

SELECT @xml = CONVERT(xml, BulkColumn, 2) FROM OPENROWSET(BULK 'D:\Учёба\3 курс\1 семестр\CursWork\CourseWork\import.xml', SINGLE_BLOB) AS x

INSERT INTO  Users(Login, Password, FirstName, LastName, Email, Roles)
SELECT 
	t.x.query('Login').value('.', 'varchar(50)') ,
	t.x.query('Password').value('.', 'varchar(50)'),
	t.x.query('FirstName').value('.', 'nvarchar(50)'),
	t.x.query('LastName').value('.', 'nvarchar(50)'),
	t.x.query('Email').value('.', 'varchar(50)'),
	t.x.query('Roles').value('.', 'int')
FROM @xml.nodes('//Users/User') t(x)
end

select * from Users;

drop procedure ImportFromXML;

exec ImportFromXML;