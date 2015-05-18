
SET NOCOUNT ON

DELETE FROM SSIS.EnvironmentVars WHERE [Environment] = 'DEV' 

INSERT INTO SSIS.EnvironmentVars (Environment,[Application],VariableName,DataType,Value,Sensitive)
VALUES
	('DEV','Application1','Variable1','String','testdb','False'),
	('DEV','Application1','Variable2','Int32','200','False'),
	('DEV','Application1','Variable3','DateTime','20140116','False'),
	('DEV','Application1','Variable4','Boolean','True','False'),
	('DEV','Application2','ConfigPath','String','HelloWorld','False')
SET NOCOUNT OFF