use labdb;
go

drop service [demo/InventoryService];
drop service [demo/OrderService];
drop queue dbo.demoInventoryQueue;
drop queue dbo.demoOrderQueue;
drop contract [demo/contracts/demoContract];
drop message type [demo/messages/demoRequest];
drop message type [demo/messages/demoResponse];
go

use master;
go

if exists(select top 1 1 from sys.databases where name = 'labdb')
  drop database labdb;
go
