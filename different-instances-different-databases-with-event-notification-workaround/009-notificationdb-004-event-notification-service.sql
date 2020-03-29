use notificationdb;
go

create queue dbo.notificationqueue
  with status=on;
go
if exists(select * from sys.services where name = N'mycompany/services/notificationdb/notificationservice')
  drop service [mycompany/services/notificationdb/notificationservice];
go
create service [mycompany/services/notificationdb/notificationservice]
  on queue dbo.notificationqueue
  (
    [http://schemas.microsoft.com/SQL/Notifications/PostEventNotification]
  );
go


create event notification customernotificationevent
  on queue dbo.customernotificationqueue
  for QUEUE_ACTIVATION
  to service N'mycompany/services/notificationdb/notificationservice', 'current database';
go
create event notification ordernotificationevent
  on queue dbo.ordernotificationqueue
  for QUEUE_ACTIVATION
  to service N'mycompany/services/notificationdb/notificationservice', 'current database';
go
create event notification inventorynotificationevent
  on queue dbo.inventorynotificationqueue
  for QUEUE_ACTIVATION
  to service N'mycompany/services/notificationdb/notificationservice', 'current database';
go
