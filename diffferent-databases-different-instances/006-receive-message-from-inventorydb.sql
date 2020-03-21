use inventorydb;
go

select * from dbo.demoInventoryQueue;
go

declare @handle uniqueidentifier;
declare @message varchar(100);
declare @messageTypeName sysname;

begin transaction;

  waitfor
  (
    receive top(1)
      @handle = conversation_handle,
      @message = message_body,
      @messageTypeName = message_type_name 
    from
      dbo.demoInventoryQueue
  ), timeout 5000;

  select @message as message_received;

  if @messageTypeName = N'demo/messages/demoRequest'
    begin
      declare @replyMessage varchar(100);
      select @replyMessage = 'ack from db2.inventorydb';

      send
        on conversation @handle
        message type [demo/messages/demoResponse](@replyMessage);

      end conversation @handle;
    end

    select @replyMessage as message_replied;

commit transaction;

select * from sys.transmission_queue;
go