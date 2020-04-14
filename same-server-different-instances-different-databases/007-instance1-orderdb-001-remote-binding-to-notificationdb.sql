use orderdb;
go
create user notificationdbuser without login;
go
create certificate notificationdbusercert
  authorization notificationdbuser
  from file = N'C:\temp\notificationdbusercert.cer';
go
grant send on service::[mycompany/services/orderdb/notificationrequestservice] to notificationdbuser;
go
create remote service binding [mycompany/services/notificationdb/ordernotificationservice] 
  to service N'mycompany/services/notificationdb/ordernotificationservice'
  with user = notificationdbuser;
go
create route [mycompany/services/notificationdb/ordernotificationservice] with 
  service_name = N'mycompany/services/notificationdb/ordernotificationservice',
  address = N'TCP://localhost:4023';
go