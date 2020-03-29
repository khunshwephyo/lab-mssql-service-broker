use master;
go

-- web1 = server name that will host external activation service
create login [demo\web1$] from windows;
go

use notificationdb;
go

create user [demo\web1$] for login [demo\web1$];
go

-- for external activation service that monitors dbo.notificationqueue
grant connect to [demo\web1$];
grant references on schema::dbo to [demo\web1$];
grant view definition to [demo\web1$];
grant receive on dbo.notificationqueue to [demo\web1$];
go

-- for application that runs upon notification
grant connect to [demo\web1$];
grant references on schema::dbo to [demo\web1$];
grant receive on dbo.customernotificationqueue to [demo\web1$];
grant receive on dbo.ordernotificationqueue to [demo\web1$];
grant receive on dbo.inventorynotificationqueue to [demo\web1$];
go


