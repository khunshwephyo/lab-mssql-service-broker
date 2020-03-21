select * from sys.server_permissions as pm
join sys.server_principals as pr
on pm.grantee_principal_id = pr.principal_id
left outer join sys.endpoints as ep
on pm.major_id = ep.endpoint_id
where
  pm.permission_name = 'CONNECT'
  and pm.class_desc = 'ENDPOINT';

select * from sys.endpoints;

-- grant connect to gMSA
grant connect on endpoint::[inventoryendpoint] to [demo\s14dev1$];