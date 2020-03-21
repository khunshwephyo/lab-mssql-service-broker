use master;
go

if exists(select top 1 1 from sys.databases where name = 'inventorydb')
  drop database inventorydb 
go 

create database inventorydb
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
