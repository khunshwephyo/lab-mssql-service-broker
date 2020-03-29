# lab-mssql-service-broker

## same-instance-same-database

SQL scripts that send and receive messages within same database of an instance.

## same-instance-different-databases

SQL scripts that send and receive messages between two different databases in same instance.

## different-instances-different-databases-with-event-notification-workaround

SQL scripts that send and receive messages among three different databases in two different instances.

### Server 1 

Server Name = db1
Service Broker EndPoint Port = 4022
Database Instance = s14dev1
Database Port = 14331
Databases = customerdb

### Server 2

Server Name = db2
Service Broker EndPoint Port = 4022
Database Instance = s14dev1
Database Port = 14331
Databases = orderdb, inventorydb, notificationdb

### Server 3

Server Name = web1

Installed with following components.

* SQL Server Service Broker External Activator (SSBEA 64bit)
* .NET Framework 3.5 (required for SSBEA above)
* .NET Framework 4.8 (required for application that are activated upon notification)

### Notification Flow

1. customerdb, orderdb, and inventorydb sends messages to notificationdb.
2. notificationdb sends notification to web1
3. applications on web1 runs upon receiving notification from notificationdb.
4. each application simply logs the message into a file.

## References

1. https://www.databasejournal.com/article.php/3880181/Arshad-Ali.htm
2. https://docs.microsoft.com/en-us/sql/relational-databases/service-broker/configure-dialog-security-for-event-notifications?view=sql-server-2017 - I could not make this work on my test environment.  So I used the workaround above.
3. https://www.apress.com/gp/book/9781590599990
