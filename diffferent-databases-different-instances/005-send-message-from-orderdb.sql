use orderdb;
go

declare @handle uniqueidentifier;
declare @message varchar(100);

begin transaction;
  
  begin dialog @handle
    from service [demo/OrderService]
    to service N'demo/InventoryService'
    on contract [demo/contracts/demoContract]
    with encryption = on;

  select @message = N'this is message from db1.orderdb';

  send 
    on conversation @handle
    message type [demo/messages/demoRequest](@message);

  select
    @message as message_sent;

commit transaction;
go

select * from sys.transmission_queue;
go