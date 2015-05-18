CREATE TABLE [Config].[ApplicationComponents]
(
	 [ApplicationId] INT NOT NULL 
	,[ComponentId] INT NOT NULL
	 CONSTRAINT [PK_ApplicationComponents] PRIMARY KEY (ApplicationId,ComponentId)
)
