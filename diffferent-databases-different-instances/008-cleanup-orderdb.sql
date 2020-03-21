use master;
go

if exists(select * from sys.endpoints where name = N'orderendpoint')
  drop endpoint orderEndPoint;
go

use msdb;
go

if exists(select * from sys.routes where name = N'orderdbroute')
  drop route orderdbroute;
go

use orderdb;
go
drop route inventorydbroute;
drop remote service binding remoteBindingForInventory;
drop certificate inventorydbcert;
drop user inventorydbuser;
go

drop service [demo/OrderService];
drop queue dbo.demoOrderQueue;
drop contract [demo/contracts/demoContract];
drop message type [demo/messages/demoRequest];
drop message type [demo/messages/demoResponse];
drop master key ;
drop user orderdbuser;
go

use master;
go

if exists(select top 1 1 from sys.databases where name = 'orderdb')
  drop database orderdb;
go 
