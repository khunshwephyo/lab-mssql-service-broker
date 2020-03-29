use customerdb;
go
declare @handle uniqueidentifier;
declare @message nvarchar(100);
begin transaction;
  begin dialog @handle
    from service [mycompany/services/customerdb/notificationrequestservice]
    to service N'mycompany/services/notificationdb/customernotificationservice'
    on contract [mycompany/contracts/notificationcontract]
    with encryption = on;
  select @message = N'hello world from customerdb';
  send 
    on conversation @handle
    message type [mycompany/messages/notificationrequest](@message);
  select
    @message as message_sent;
commit transaction;
go
select * from sys.transmission_queue;
select * from sys.conversation_endpoints;
go
