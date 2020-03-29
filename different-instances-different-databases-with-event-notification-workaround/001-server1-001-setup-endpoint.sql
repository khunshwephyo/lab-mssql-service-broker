use master;
go


if exists(select * from sys.endpoints where name='ServiceBrokerEndpoint')
  drop endpoint ServiceBrokerEndpoint;
go
create endpoint ServiceBrokerEndpoint
  state = started
  as tcp
  (
    listener_port = 4022,
    listener_ip = ALL
  )
  for service_broker
  (
    -- if servers are part of same windows domain and sql server service is run using active directory account, then authentication = WINDOWS is sufficient
    authentication = WINDOWS
    -- if servers are not same domain or if sql server service is running using built-in account, then authentication need to use Certificate
    -- authentication = CERTIFICATE cert_name
  );
go

select * from sys.endpoints;
go

-- assuming
-- [demo\s14dev1$] account is used for running SQL Server Service
create login [demo\s14dev1$] from windows with default_database=[master];
go
create user [demo\s14dev1$] for login [demo\s14dev1$];
go
grant connect on endpoint::ServiceBrokerEndpoint to [demo\s14dev1$];
go
