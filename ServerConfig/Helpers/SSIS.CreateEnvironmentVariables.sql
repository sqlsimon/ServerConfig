


IF '$(ENVIRONMENT)' = 'DEV'
	BEGIN

	PRINT 'DEV'

		:r ..\Environments\DEV\SSISVariables.sql	

	END
	ELSE IF '$(ENVIRONMENT)' = 'INT'
	BEGIN

	PRINT 'INT'

	END
	ELSE IF '$(ENVIRONMENT)' = 'TEST'
	BEGIN

	PRINT 'TEST'

	END
	ELSE IF '$(ENVIRONMENT)' = 'UAT'
	BEGIN

	PRINT 'UAT'

	END
	ELSE IF '$(ENVIRONMENT)' = 'PROD'
	BEGIN

	PRINT 'PROD'

	END

	DECLARE @EnvVarCounter INT = 1,
			@RowsToProcess INT = 0,
			@VarName NVARCHAR(128),
			@DataType NVARCHAR(128),
			@Value SQL_VARIANT,
			@Sensitive BIT,
			@SQLStmnt NVARCHAR(MAX)

			DECLARE @Variables TABLE 	
				([Id] INT IDENTITY (1,1)NOT NULL PRIMARY KEY
				,[VariableName] NVARCHAR(128) NOT NULL
				,[DataType] NVARCHAR(128) NOT NULL 
				,[Value] SQL_VARIANT NOT NULL
				,[Sensitive] BIT NOT NULL
			)
				
	INSERT INTO @Variables ([VariableName],[DataType],[Value],[Sensitive]) 
	SELECT [VariableName],[DataType],[Value],Sensitive FROM SSIS.EnvironmentVars 
	WHERE Environment = '$(ENVIRONMENT)' AND Application = @CurrentApplication
	
	SELECT @RowsToProcess = (SELECT MAX(ID) FROM @Variables)


																	

	WHILE (@EnvVarCounter <= @RowsToProcess)
	BEGIN
		SELECT @VarName = VariableName
			  ,@DataType = DataType
			  ,@Value = Value
			  ,@Sensitive = Sensitive
		FROM @Variables
		WHERE Id = @EnvVarCounter
		
			SELECT @SQLStmnt = 'DECLARE @TypedValue ' + 
				CASE @DataType 
					WHEN 'Boolean' THEN 'BIT'
					WHEN 'Byte' THEN 'VARBINARY'
					WHEN 'DateTime' THEN 'DATETIME2'
					WHEN 'Double' THEN 'DECIMAL'
					WHEN 'Int16' THEN 'SMALLINT'
					WHEN 'Int32' THEN 'INT'
					WHEN 'Int64' THEN 'BIGINT'
					WHEN 'Single' THEN 'DECIMAL'
					WHEN 'String' THEN 'NVARCHAR(4000)'
					WHEN 'UInt32' THEN 'INT'
					WHEN 'UInt64' THEN 'BIGINT'
				END +
				' = '+
				CASE @DataType 
					WHEN 'Boolean' THEN '''' + CONVERT(VARCHAR(6),@Value) + ''''
					WHEN 'Byte' THEN 'VARBINARY'
					WHEN 'DateTime' THEN '''' + CONVERT(VARCHAR(50),@Value) + ''''
					WHEN 'Double' THEN CONVERT(VARCHAR(50),@Value)
					WHEN 'Int16' THEN CONVERT(VARCHAR(50),@Value)
					WHEN 'Int32' THEN CONVERT(VARCHAR(50),@Value)
					WHEN 'Int64' THEN CONVERT(VARCHAR(50),@Value)
					WHEN 'Single' THEN CONVERT(VARCHAR(50),@Value)
					WHEN 'String' THEN '''' + CONVERT(NVARCHAR(4000),@Value) + ''''
					WHEN 'UInt32' THEN CONVERT(VARCHAR(50),@Value)
					WHEN 'UInt64' THEN CONVERT(VARCHAR(50),@Value)
				END 
				 + 
				' EXEC $(SSISCATALOG_DB).[catalog].[create_environment_variable] ' +
				'			 @environment_name = N'''+ @CurrentApplicationEnv +'''' +
				',@folder_name  = N'''+ @CurrentApplication +'''' +
				',@variable_name = N''' + @VarName + '''' +
				',@Sensitive = ' + CAST(@Sensitive AS VARCHAR(6)) + 
				',@data_type = N''' + @DataType + '''' +
				',@description = N''' + @BuildMessage + '''' +
				',@value = @TypedValue'


			   EXEC sp_executesql @Stmnt =  @SQLStmnt


		SELECT @EnvVarCounter += 1

	END
