

/*

 Here you would add a condition for each "Project" that would wanted to release server level objects for. and then create a "ProjectX_ServerConfig.sql" 
 script that was not in the build. 

 It may be worth including some tables in the server config database that track what projects and Jobs where released and have the ServerConfig database
 not dropped and recreated each time to allow for tracking of deployments. 

*/

/* ServerConfigMain.sql */

DECLARE @BuildMessage NVARCHAR(4000)

DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
DECLARE @jobId BINARY(16)

DECLARE @Applications TABLE (Id INT,ApplicationName NVARCHAR(128))

INSERT INTO @Applications (Id,ApplicationName)
SELECT listpos,nstr FROM config.StringToTable('$(APPLICATION_LIST)',',')

SELECT * FROM @Applications

DECLARE @CurrentApplication    NVARCHAR(128)
DECLARE @CurrentApplicationEnv NVARCHAR(128)
DECLARE @CurrentAppID		INT = 1
DECLARE @MaxAppID			INT = (SELECT MAX(Id) FROM @Applications)


WHILE @CurrentAppID <= @MaxAppID
BEGIN

	SELECT @CurrentApplication = ApplicationName, @CurrentApplicationEnv = ApplicationName+'_$(ENVIRONMENT)' 
	FROM @Applications WHERE Id = @CurrentAppID

	SELECT @BuildMessage  = 'Created by automated build "'+ @CurrentApplicationEnv + '" on ' + CONVERT(VARCHAR(20),GETDATE(),120)

	/* 
	/////////////////////////////////////////////////////////////////////////////////////////////////////// 
									Load the appropriate configuration
	/////////////////////////////////////////////////////////////////////////////////////////////////////// 
	*/
	:r	.\Helpers\LoadConfiguration.sql


	/* 
	/////////////////////////////////////////////////////////////////////////////////////////////////////// 
									SSISDB CONFIGURATION
	/////////////////////////////////////////////////////////////////////////////////////////////////////// 
	*/

	/*	Assumes that the SSISDB database has been created and the folder to hold the Application 
		This should have been done by the SSIS Deployment
	*/

	-- Is the application configured to have SSIS artefacts deployed
	IF EXISTS (SELECT 1 FROM Config.ApplicationConfiguration WHERE ApplicationName = @CurrentApplication AND ComponentName = 'SSIS')
	BEGIN 

		-- Perform a check for SSISDB and Application folder 
		IF EXISTS (SELECT 1 FROM $(SSISCATALOG_DB).catalog.folders WHERE name = @CurrentApplication)
		BEGIN 
			PRINT 'Found SSIS Catalog and Application folder'

			/* Check the environment exists */
			IF EXISTS (SELECT 1 FROM $(SSISCATALOG_DB).catalog.environments e 
				   INNER JOIN $(SSISCATALOG_DB).catalog.folders f ON e.folder_id = f.folder_id
				   WHERE f.name = @CurrentApplication AND e.name = @CurrentApplicationEnv)
			BEGIN
				PRINT 'Dropping SSIS Catalog Environment "' + @CurrentApplicationEnv + '" for application "' + @CurrentApplication+'"'
				-- REMOVE THE ENVIRONMENT HERE
				EXEC $(SSISCATALOG_DB).[catalog].[delete_environment] @folder_name = @CurrentApplication, @environment_name = @CurrentApplicationEnv

			END
	
			PRINT 'Creating SSIS Catalog Environment "' + @CurrentApplicationEnv + '" for application "' + @CurrentApplication+'"'


			EXEC $(SSISCATALOG_DB).[catalog].[create_environment] @folder_name = @CurrentApplication
																, @environment_name = @CurrentApplicationEnv
																, @environment_description = @BuildMessage

			PRINT 'Creating Environment Variables for environment "' + @CurrentApplicationEnv + '" for application "' + @CurrentApplication+'"'
		
			:r .\Helpers\SSIS.CreateEnvironmentVariables.sql
		

		END
		ELSE 
		RAISERROR('ERROR: unable to find the folder %s in %s',16,1,@CurrentApplication,'$(SSISCATALOG_DB)')

	END


	/* //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// */


	IF @CurrentApplication = 'Application1'
	BEGIN

	:r .\Application1_ServerConfig.sql


	END


	IF @CurrentApplication = 'Application2'
	BEGIN

	:r .\Application2_ServerConfig.sql


	END


	SELECT @CurrentAppID += 1
END