use master;
go

if not exists(select * from sys.symmetric_keys where name like '%DatabaseMasterKey%')
  create master key encryption by password = N'Password1234!';
go

if not exists (select * from sys.certificates where name ='instance2cert')
  create certificate instance2cert
  with 
    subject = N'Certificate for instance2',
    expiry_date = N'12/31/2050';
go

backup certificate instance2cert
  to file = N'C:\temp\instance2cert.cer';
go