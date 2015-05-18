

PRINT 'Loading configuration for environment: "$(ENVIRONMENT)"...'

IF '$(ENVIRONMENT)' = 'DEV'
	BEGIN
	
		:r ..\Environments\DEV\Setup.sql	

	END
	ELSE IF '$(ENVIRONMENT)' = 'INT'
	BEGIN
	
		:r ..\Environments\INT\Setup.sql

	END
	ELSE IF '$(ENVIRONMENT)' = 'TEST'
	BEGIN

		:r ..\Environments\TEST\Setup.sql


	END
	ELSE IF '$(ENVIRONMENT)' = 'UAT'
	BEGIN

		:r ..\Environments\UAT\Setup.sql

	END
	ELSE IF '$(ENVIRONMENT)' = 'PROD'
	BEGIN

		:r ..\Environments\PROD\Setup.sql

	PRINT 'PROD'

	END

PRINT 'Configuration for environment: "$(ENVIRONMENT)" loaded.'

