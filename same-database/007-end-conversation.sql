-- need to run this twice
--    one to read received message
--    one to end conversation

use labdb;
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
      dbo.demoOrderQueue
  ), timeout 1000;

  select 
    @message as message_received,
    @messageTypeName as message_type;

  if @messageTypeName = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
    end conversation @handle;
  else 
    select @message as message_received;
  
commit transaction;
go

