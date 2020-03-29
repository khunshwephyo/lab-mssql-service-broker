use labdb;
go


select * from dbo.demoInventoryQueue;
go

-- if data is not in queue, temporarily could be in transmission queue
select * from sys.transmission_queue;
go