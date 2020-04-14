use master;
go

if exists(select * from sys.endpoints where name='ServiceBrokerEndpoint')
  drop endpoint ServiceBrokerEndpoint;
go
create endpoint ServiceBrokerEndpoint
  state = started
  as tcp
  (
    listener_port = 4023, -- must choose another port if it is taken by another instance
    listener_ip = ALL
  )
  for service_broker
  (
    -- if servers are part of same windows domain and sql server service is run using active directory account, then authentication = WINDOWS is sufficient
    -- authentication = WINDOWS
    -- if servers are not same domain or if sql server service is running using built-in account, then authentication need to use Certificate
    authentication = CERTIFICATE instance2cert,
    encryption = REQUIRED ALGORITHM AES
  );
go

select * from sys.endpoints;
go

-- assuming
-- [NT Service\MSSQL$INSTANCE2] account is used for running SQL Server Service of INSTANCE2
-- grant back account that runs SQL Server Service so that databases in this instance
-- can talk to one another using this endpoint.
create user [NT Service\MSSQL$INSTANCE2] for login [NT Service\MSSQL$INSTANCE2];
go
grant connect on endpoint::ServiceBrokerEndpoint to [NT Service\MSSQL$INSTANCE2];
go

-- assuming
-- [NT Service\MSSQL$INSTANCE1] account is used for running SQL Server Service of INSTANCE1
-- create and grant this account so that databases from INSTANCE1
-- can talk to databases in INSTANCE2 using this endpoint.
create login [NT Service\MSSQL$INSTANCE1] from windows with default_database=[master];
go
create user [NT Service\MSSQL$INSTANCE1] for login [NT Service\MSSQL$INSTANCE1];
go
grant connect on endpoint::ServiceBrokerEndpoint to [NT Service\MSSQL$INSTANCE1];
go
create certificate instance1cert
  authorization [NT Service\MSSQL$INSTANCE1]
  from file = N'c:\temp\instance1cert.cer';
go