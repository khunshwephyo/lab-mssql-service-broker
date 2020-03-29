use notificationdb;
go
declare @handle uniqueidentifier;
declare @message nvarchar(100);
declare @messageType sysname;
begin transaction;
  waitfor
  (
    receive top(1)
      @handle = conversation_handle,
      @message = message_body,
      @messageType = message_type_name
    from
      dbo.inventorynotificationqueue
  ), timeout 5000;

  select @message as message_received;

  if(@messageType = N'mycompany/messages/notificationrequest')
  begin
    declare @replyMsg nvarchar(100);
    select @replyMsg = 'yay! i got it';
    send 
      on conversation @handle
      message type [mycompany/messages/notificationresponse](@replyMsg);
    end conversation @handle;
  end
    
commit transaction;
go
select * from sys.transmission_queue;
go

