use master;
go

if exists(select top 1 1 from sys.databases where name = 'notificationdb')
  drop database notificationdb;
go 
create database notificationdb;
go

select 
  name,
  service_broker_guid,
  is_broker_enabled,
  is_honor_broker_priority_on 
from
  sys.databases 
where
  name = 'notificationdb';
go

-- enable service broker
alter database notificationdb
  set enable_broker;
go

-- to disable service broker
--alter database notificationdb
--  set disable_broker;
--go

-- mark database as TRUSTWORTHY 
-- so that it can access resources across different databases
alter database notificationdb set trustworthy on
go

