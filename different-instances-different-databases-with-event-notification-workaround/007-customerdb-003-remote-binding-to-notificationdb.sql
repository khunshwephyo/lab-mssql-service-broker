use customerdb;
go
create user notificationdbuser without login;
go
create certificate notificationdbusercert
  authorization notificationdbuser
  from file = N'C:\temp\notificationdbusercert.cer';
go
grant send on service::[mycompany/services/customerdb/notificationrequestservice] to notificationdbuser;
go
create remote service binding [mycompany/services/notificationdb/customernotificationservice] 
  to service N'mycompany/services/notificationdb/customernotificationservice'
  with user = notificationdbuser;
go
create route [mycompany/services/notificationdb/customernotificationservice] with 
  service_name = N'mycompany/services/notificationdb/customernotificationservice',
  address = N'TCP://db2:4022';
go