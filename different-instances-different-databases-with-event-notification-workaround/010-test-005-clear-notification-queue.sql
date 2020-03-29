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
      dbo.notificationqueue
  ), timeout 5000;

  select @message as message_received;

  if(@messageType = N'http://schemas.microsoft.com/SQL/Notifications/EventNotification')
  begin
    select @message as message_received;
    end conversation @handle;
  end
    
commit transaction;
go

select * from dbo.notificationqueue;
go

