use inventorydb;
go

drop service [demo/InventoryService]
drop queue dbo.demoInventoryQueue
drop contract [demo/contracts/demoContract]
drop message type [demo/messages/demoRequest];
drop message type [demo/messages/demoResponse];
go

use master 
go

if exists(select top 1 1 from sys.databases where name = 'inventorydb')
  drop database inventorydb
go


use orderdb;
go

drop service [demo/OrderService]
drop queue dbo.demoOrderQueue
drop contract [demo/contracts/demoContract]
drop message type [demo/messages/demoRequest];
drop message type [demo/messages/demoResponse];
go

use master 
go

if exists(select top 1 1 from sys.databases where name = 'orderdb')
  drop database orderdb
go
