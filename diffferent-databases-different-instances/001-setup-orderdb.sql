use master;
go

--create endpoint. default port is 4022
if exists(select * from sys.endpoints where name = 'orderendpoint')
  drop endpoint orderendpoint;
go

create endpoint orderendpoint
  state = started
  as tcp(listener_port = 4022)
  for service_broker(authentication=windows);
go

if exists(select top 1 1 from sys.databases where name = 'orderdb')
  drop database orderdb;
go 

create database orderdb;
go

select 
	name,
  service_broker_guid,
  is_broker_enabled,
  is_honor_broker_priority_on 
from
  sys.databases 
where
  name = 'orderdb';
go

-- enable service broker
alter database orderdb
  set enable_broker;
go

-- to disable service broker
--alter database orderdb
--  set disable_broker;
--go

-- mark database as TRUSTWORTHY 
-- so that it can access resources across different databases
alter database orderdb set trustworthy on
go

use orderdb;
go

create master key encryption by password = N'Password1234!';
go

create user orderdbuser without login;
go

create certificate orderdbcert 
  authorization orderdbuser
  with 
    subject = N'Certificate for orderdbuser',
    expiry_date = N'12/12/2021';
go

backup certificate orderdbcert 
  to file = N'C:\Temp\orderdbcert.cer';
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

create queue dbo.demoOrderQueue with status = on;
go

create service [demo/OrderService] 
  authorization orderdbuser
  on queue dbo.demoOrderQueue([demo/contracts/demoContract]);
go

