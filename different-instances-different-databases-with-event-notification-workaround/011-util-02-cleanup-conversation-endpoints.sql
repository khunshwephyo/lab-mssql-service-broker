use inventorydb;
go


DECLARE @conversationHandle uniqueidentifier 

SELECT TOP 1 
	@conversationHandle = conversation_handle 
FROM  
	sys.conversation_endpoints    

WHILE 
	@@rowcount = 1
BEGIN    
     END CONVERSATION @conversationHandle WITH CLEANUP    

     SELECT TOP 1 
		@conversationHandle = conversation_handle 
	FROM 
		sys.conversation_endpoints    
END
GO 