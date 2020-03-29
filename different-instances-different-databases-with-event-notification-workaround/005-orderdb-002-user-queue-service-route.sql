use orderdb;
go

-- master key for encrypting data
create master key encryption by password = N'Password1234!';
go

-- create user and certificate to be used for service broker dialog security
create user orderdbuser without login;
go
create certificate orderdbusercert 
  authorization orderdbuser
  with 
    subject = N'Certificate for orderdbuser',
    expiry_date = N'12/31/2022';
go
backup certificate orderdbusercert  
  to file = N'C:\Temp\orderdbusercert.cer';
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
create service [mycompany/services/orderdb/notificationrequestservice] 
  authorization orderdbuser 
  on queue dbo.notificationrequestqueue([mycompany/contracts/notificationcontract]);
go

-- declare this service at msdb so that it can be reached by other database instances
use msdb;
go
if exists(select * from sys.routes where name = N'mycompany/services/orderdb/notificationrequestservice')
  drop route [mycompany/services/orderdb/notificationrequestservice];
go
create route [mycompany/services/orderdb/notificationrequestservice] with
  service_name = N'mycompany/services/orderdb/notificationrequestservice',
  address = N'LOCAL';
go
