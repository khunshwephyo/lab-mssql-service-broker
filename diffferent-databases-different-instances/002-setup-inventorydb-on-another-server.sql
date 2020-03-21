use master;
go

--create endpoint. default port is 4022
if exists(select * from sys.endpoints where name = 'inventoryendpoint')
  drop endpoint inventoryendpoint;
go

create endpoint inventoryendpoint
  state = started
  as tcp(listener_port = 4022)
  for service_broker(authentication=windows);
go

if exists(select top 1 1 from sys.databases where name = 'inventorydb')
  drop database inventorydb;
go 

create database inventorydb;
go

select 
	name,
  service_broker_guid,
  is_broker_enabled,
  is_honor_broker_priority_on 
from
  sys.databases 
where
  name = 'inventorydb';
go

-- enable service broker
alter database inventorydb
  set enable_broker;
go

-- to disable service broker
--alter database inventorydb
--  set disable_broker;
--go

-- mark database as TRUSTWORTHY 
-- so that it can access resources across different databases
alter database inventorydb set trustworthy on
go

use inventorydb;
go

create master key encryption by password = N'Password1234!';
go

create user inventorydbuser without login;
go

create certificate inventorydbcert 
  authorization inventorydbuser
  with 
    subject = N'Certificate for inventorydbuser',
    expiry_date = N'12/12/2021';
go

backup certificate inventorydbcert 
  to file = N'C:\Temp\inventorydbcert.cer';
go

create message type [demo/messages/demoRequest];
create message type [demo/messages/demoResponse];
go

create contract [demo/contracts/demoContract]
(
  [demo/messages/demoRequest] sent by initiator,
  [demo/messages/demoResponse] sent by target
);
go

create queue dbo.demoInventoryQueue with status = on;
go

create service [demo/InventoryService] 
  authorization inventorydbuser
  on queue dbo.demoInventoryQueue([demo/contracts/demoContract]);
go
