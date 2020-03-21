use orderdb;
go

select * from dbo.demoOrderQueue;
go

declare @handle uniqueidentifier;
declare @message varchar(100);
declare @messageType sysname;

begin transaction;

  waitfor
  (
    receive top(1)
      @handle = conversation_handle,
      @message = message_body,
      @messageType = message_type_name
    from
      dbo.demoOrderQueue
  ), timeout 5000;

  if (@messageType = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog')
    end conversation @handle;
  else 
    select @message as message_received;

commit transaction;
go
