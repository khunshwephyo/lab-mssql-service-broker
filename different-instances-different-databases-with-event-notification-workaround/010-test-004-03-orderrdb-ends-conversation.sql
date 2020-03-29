use orderdb;
go
declare @handle uniqueidentifier;
declare @message nvarchar(100);
begin transaction;
  waitfor
  (
    receive top(1)
      @handle = conversation_handle,
      @message = message_body
    from
      dbo.notificationrequestqueue
  ), timeout 5000;

  end conversation @handle;
  
  select @message as message_received;
    
commit transaction;
go
select * from sys.transmission_queue;
go