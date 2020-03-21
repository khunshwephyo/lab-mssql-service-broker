use orderdb;
go

create user inventorydbuser without login;
go

create certificate inventorydbcert 
  authorization inventorydbuser
  from file = N'C:\temp\inventorydbcert.cer';
go

if exists(select * from sys.routes where name = N'inventorydbroute')
  drop route inventorydbroute;
go

create route inventorydbroute with
  service_name = N'demo/InventoryService',
  address = N'TCP://db2:4022';
go


use msdb;
go

if exists(select * from sys.routes where name = N'orderdbroute')
  drop route orderdbroute;
go

create route orderdbroute with
  service_name = N'demo/OrderService',
  address = N'LOCAL';
go


use orderdb;
go

grant send 
  on service::[demo/OrderService]
  to inventorydbuser;

create remote 
  service binding remoteBindingForInventory
  to service N'demo/InventoryService'
  with user = inventorydbuser;
go



