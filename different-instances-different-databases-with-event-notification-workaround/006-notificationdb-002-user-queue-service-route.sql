use notificationdb;
go

-- master key for encrypting data
create master key encryption by password = N'Password1234!';
go

-- create user and certificate to be used for service broker dialog security
create user notificationdbuser without login;
go
create certificate notificationdbusercert 
  authorization notificationdbuser
  with 
    subject = N'Certificate for notificationdbuser',
    expiry_date = N'12/31/2022';
go
backup certificate notificationdbusercert  
  to file = N'C:\Temp\notificationdbusercert.cer';
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


create queue dbo.customernotificationqueue
  with status = on;
go
create service [mycompany/services/notificationdb/customernotificationservice] 
  authorization notificationdbuser 
  on queue dbo.customernotificationqueue([mycompany/contracts/notificationcontract]);
go

create queue dbo.ordernotificationqueue
  with status = on;
go
create service [mycompany/services/notificationdb/ordernotificationservice] 
  authorization notificationdbuser 
  on queue dbo.ordernotificationqueue([mycompany/contracts/notificationcontract]);
go

create queue dbo.inventorynotificationqueue
  with status = on;
go
create service [mycompany/services/notificationdb/inventorynotificationservice] 
  authorization notificationdbuser 
  on queue dbo.inventorynotificationqueue([mycompany/contracts/notificationcontract]);
go



use msdb;
go
if exists(select * from sys.routes where name = N'mycompany/services/notificationdb/customernotificationservice')
  drop route [mycompany/services/notificationdb/customernotificationservice];
go
create route [mycompany/services/notificationdb/customernotificationservice] with
  service_name = N'mycompany/services/notificationdb/customernotificationservice',
  address = N'LOCAL';
go

if exists(select * from sys.routes where name = N'mycompany/services/notificationdb/ordernotificationservice')
  drop route [mycompany/services/notificationdb/ordernotificationservice];
go
create route [mycompany/services/notificationdb/ordernotificationservice] with
  service_name = N'mycompany/services/notificationdb/ordernotificationservice',
  address = N'LOCAL';
go

if exists(select * from sys.routes where name = N'mycompany/services/notificationdb/inventorynotificationservice')
  drop route [mycompany/services/notificationdb/inventorynotificationservice];
go
create route [mycompany/services/notificationdb/inventorynotificationservice] with
  service_name = N'mycompany/services/notificationdb/inventorynotificationservice',
  address = N'LOCAL';
go