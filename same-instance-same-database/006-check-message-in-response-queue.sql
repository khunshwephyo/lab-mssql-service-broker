use labdb;
go


select * from dbo.demoOrderQueue;
go

-- if data is not in queue, temporarily could be in transmission queue
select * from sys.transmission_queue;
go