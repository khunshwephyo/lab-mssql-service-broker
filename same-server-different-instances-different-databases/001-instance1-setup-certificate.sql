use master;
go

if not exists(select * from sys.symmetric_keys where name like '%DatabaseMasterKey%')
  create master key encryption by password = N'Password1234!';
go

if not exists (select * from sys.certificates where name ='instance1cert')
  create certificate instance1cert
  with 
    subject = N'Certificate for instance1',
    expiry_date = N'12/31/2050';
go

backup certificate instance1cert
  to file = N'C:\temp\instance1cert.cer';
go