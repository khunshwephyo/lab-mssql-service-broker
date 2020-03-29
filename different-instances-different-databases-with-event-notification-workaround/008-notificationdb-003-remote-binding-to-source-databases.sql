use notificationdb;
go

create user customerdbuser without login;
go
create certificate customerdbusercert
  authorization customerdbuser 
  from file = N'C:\temp\customerdbusercert.cer';
go
grant send on service::[mycompany/services/notificationdb/customernotificationservice] to customerdbuser;
go
create remote service binding [mycompany/services/customerdb/notificationrequestservice]
  to service N'mycompany/services/customerdb/notificationrequestservice'
  with user = customerdbuser;
go
create route [mycompany/services/customerdb/notificationrequestservice] with
  service_name = N'mycompany/services/customerdb/notificationrequestservice',
  address = N'TCP://db1:4022';
go


create user orderdbuser without login;
go
create certificate orderdbusercert
  authorization orderdbuser 
  from file = N'C:\temp\orderdbusercert.cer';
go
grant send on service::[mycompany/services/notificationdb/ordernotificationservice] to orderdbuser;
go
create remote service binding [mycompany/services/orderdb/notificationrequestservice]
  to service N'mycompany/services/orderdb/notificationrequestservice'
  with user = orderdbuser;
go
create route [mycompany/services/orderdb/notificationrequestservice] with
  service_name = N'mycompany/services/orderdb/notificationrequestservice',
  address = N'TCP://db2:4022';
go


create user inventorydbuser without login;
go
create certificate inventorydbusercert
  authorization inventorydbuser 
  from file = N'C:\temp\inventorydbusercert.cer';
go
grant send on service::[mycompany/services/notificationdb/inventorynotificationservice] to inventorydbuser;
go
create remote service binding [mycompany/services/inventorydb/notificationrequestservice]
  to service N'mycompany/services/inventorydb/notificationrequestservice'
  with user = inventorydbuser;
go
create route [mycompany/services/inventorydb/notificationrequestservice] with
  service_name = N'mycompany/services/inventorydb/notificationrequestservice',
  address = N'TCP://db2:4022';
go

