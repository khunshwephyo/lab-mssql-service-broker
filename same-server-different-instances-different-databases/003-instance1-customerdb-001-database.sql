use master;
go

if exists(select top 1 1 from sys.databases where name = 'customerdb')
  drop database customerdb;
go 
create database customerdb;
go

select 
  name,
  service_broker_guid,
  is_broker_enabled,
  is_honor_broker_priority_on 
from
  sys.databases 
where
  name = 'customerdb';
go

-- enable service broker
alter database customerdb
  set enable_broker;
go

-- to disable service broker
--alter database customerdb
--  set disable_broker;
--go

-- mark database as TRUSTWORTHY 
-- so that it can access resources across different databases
alter database customerdb set trustworthy on
go

