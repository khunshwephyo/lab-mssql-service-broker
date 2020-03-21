use orderdb;
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

create queue dbo.demoOrderQueue with status = on;
go

create service [demo/OrderService] 
  on queue dbo.demoOrderQueue;
go


