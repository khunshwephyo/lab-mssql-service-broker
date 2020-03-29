select 
  s.name, 
  c.* 
from 
  sys.services s
join 
  sys.certificates c
  on s.principal_id = c.principal_id
where 
  c.is_active_for_begin_dialog = 1
  and pvt_key_encryption_type != 'NA'
order by 
  c.expiry_date desc;

select 
  b.remote_service_name, 
  b.remote_service_binding_id, 
  c.* 
from 
  sys.remote_service_bindings b
join 
  sys.certificates c 
  on b.remote_principal_id = c.principal_id
where 
  c.is_active_for_begin_dialog = 1
order by 
  c.expiry_date desc;

select * from sys.transmission_queue order by enqueue_time desc;

select * from sys.conversation_endpoints where far_service like '%Notification%'

select * from sys.routes;
