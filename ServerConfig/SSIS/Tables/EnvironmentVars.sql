CREATE TABLE [SSIS].[EnvironmentVars]
(
	 [Id] INT IDENTITY (1,1)NOT NULL PRIMARY KEY
 	,[VariableName] NVARCHAR(128) NOT NULL
	,[DataType] NVARCHAR(128) NOT NULL 
	,[Value] SQL_VARIANT NOT NULL
	,[Sensitive] BIT NOT NULL, 
    [Application] NVARCHAR(128) NOT NULL, 
    [Environment] NVARCHAR(128) NOT NULL, 
    CONSTRAINT [CHK_Datatype] CHECK ([DataType] IN ('Boolean','Byte','DateTime','Double','Int16','Int32','Int64','Single','String','UInt32','UInt64'))
)
