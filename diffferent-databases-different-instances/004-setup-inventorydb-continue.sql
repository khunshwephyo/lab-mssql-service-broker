use inventorydb;
go

create user orderdbuser without login;
go

create certificate orderdbcert
  authorization orderdbuser
  from file = N'c:\temp\orderdbcert.cer';
go

if exists(select * from sys.routes where name = N'orderdbroute')
  drop route orderdbroute;
go

create route orderdbroute with
  service_name = N'demo/OrderService',
  address = N'TCP://db1:4022';
go

use msdb;
go

if exists(select * from sys.routes where name = N'inventorydbroute')
  drop route inventorydbroute;
go

create route inventorydbroute with
  service_name = N'demo/InventoryService',
  address = N'LOCAL';
go

use inventorydb;
go

grant send 
  on service::[demo/InventoryService]
  to orderdbuser;

create remote 
  service binding remoteBindingForOrder
  to service N'demo/OrderService'
  with user = orderdbuser;
go

