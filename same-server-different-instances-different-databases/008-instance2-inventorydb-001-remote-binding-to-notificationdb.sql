use inventorydb;
go
create user notificationdbuser without login;
go
create certificate notificationdbusercert
  authorization notificationdbuser
  from file = N'C:\temp\notificationdbusercert.cer';
go
grant send on service::[mycompany/services/inventorydb/notificationrequestservice] to notificationdbuser;
go

create remote service binding [mycompany/services/notificationdb/inventorynotificationservice] 
  to service N'mycompany/services/notificationdb/inventorynotificationservice'
  with user = notificationdbuser;
go
create route [mycompany/services/notificationdb/inventorynotificationservice] with 
  service_name = N'mycompany/services/notificationdb/inventorynotificationservice',
  address = N'TCP://localhost:4023';
go