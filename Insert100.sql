----------Insert 100.000 rows
use AirCompany;
GO
create or ALTER procedure InsertThousands as
begin
  declare @i int;
  set @i = 1;
  while @i <= 100000
    begin
      insert into Users(Login, Password, FirstName,LastName,Email,Roles )
        values ('test', cast(FLOOR(1000000*RAND()) as varchar(50)),'test','test','test', 0);
      set @i = @i + 1;
    end;
end;


exec InsertThousands;
go

SELECT COUNT(*) FROM Users;
go

SET STATISTICS TIME ON;
go
select * from Users;