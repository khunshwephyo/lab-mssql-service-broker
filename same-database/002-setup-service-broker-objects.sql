use labdb;
go

create message type [demo/messages/demoRequest];
create message type [demo/messages/demoResponse];
go

create contract [demo/contracts/demoContract]
(
  [demo/messages/demoRequest] sent by initiator,
  [demo/messages/demoResponse] sent by target
);
go

create queue dbo.demoInventoryQueue;
go

create service [demo/InventoryService]
  on queue dbo.demoInventoryQueue([demo/contracts/demoContract]);
go

create queue dbo.demoOrderQueue;
go

create service [demo/OrderService] 
  on queue dbo.demoOrderQueue;
go


