use master;
go


if exists
(
  select top 1 1 from sys.databases where name = 'labdb'
) 
    drop database labdb 
go

create database labdb
go

select 
	name,
  service_broker_guid,
  is_broker_enabled,
  is_honor_broker_priority_on 
from
  sys.databases 
where
  name = 'labdb';
go

-- enable service broker
alter database labdb
  set enable_broker;
go

-- to disable service broker
--alter database labdb
--  set disable_broker;
--go