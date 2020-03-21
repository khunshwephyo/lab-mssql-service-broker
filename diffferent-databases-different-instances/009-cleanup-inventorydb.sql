use master;
go

if exists(select * from sys.endpoints where name = N'inventoryendpoint')
  drop endpoint inventoryendpoint;
go

use msdb;
go

if exists(select * from sys.routes where name = N'inventorydbroute')
  drop route inventorydbroute;
go

use inventorydb;
go
drop route orderdbrout;
drop remote service binding remoteBindingForOrder;
drop certificate orderdbcert;
drop user orderdbuser;
go

drop service [demo/InventoryService];
drop queue dbo.demoInventoryQueue;
drop contract [demo/contracts/demoContract];
drop message type [demo/messages/demoRequest];
drop message type [demo/messages/demoResponse];
drop master key ;
drop user inventorydbuser;
go

use master;
go

if exists(select top 1 1 from sys.databases where name = 'inventorydb')
  drop database inventorydb;
go 
