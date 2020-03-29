use customerdb;
go

-- master key for encrypting data
create master key encryption by password = N'Password1234!';
go

-- create user and certificate to be used for service broker dialog security
create user customerdbuser without login;
go
create certificate customerdbusercert 
  authorization customerdbuser
  with 
    subject = N'Certificate for customerdbuser',
    expiry_date = N'12/31/2022';
go
backup certificate customerdbusercert  
  to file = N'C:\Temp\customerdbusercert.cer';
go

-- create message type, contract, queue, and service used for notification
create message type [mycompany/messages/notificationrequest];
create message type [mycompany/messages/notificationresponse];
go
create contract [mycompany/contracts/notificationcontract]
(
  [mycompany/messages/notificationrequest] sent by initiator,
  [mycompany/messages/notificationresponse] sent by target
);
go
create queue dbo.notificationrequestqueue
  with status = on;
go
create service [mycompany/services/customerdb/notificationrequestservice] 
  authorization customerdbuser 
  on queue dbo.notificationrequestqueue([mycompany/contracts/notificationcontract]);
go


use msdb;
go
if exists(select * from sys.routes where name = N'mycompany/services/customerdb/notificationrequestservice')
  drop route [mycompany/services/customerdb/notificationrequestservice];
go
create route [mycompany/services/customerdb/notificationrequestservice] with
  service_name = N'mycompany/services/customerdb/notificationrequestservice',
  address = N'LOCAL';
go
