/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

PRINT ' Deploying Server level configuration for ' + @CurrentApplication;

/* 
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
								AGENT JOBS
/////////////////////////////////////////////////////////////////////////////////////////////////////// 
*/

PRINT ' Deploying Agent Jobs for configuration '+ @CurrentApplication;

SET @JobId = NULL

:r .\AgentJobs\Application2\Application2.Job1.sql

--SET @JobId = NULL

--:r .\AgentJobs\Application2\Application2.Job2.sql

SELECT 'SQL Agent Job [' + j.name + '] deployed to msdb on ' + @@servername + ' on ' +  CONVERT(VARCHAR(20),j.date_created,120) 
FROM msdb.dbo.sysjobs j
INNER JOIN msdb.dbo.syscategories c ON j.category_id = c.category_id
and c.name = @CurrentApplication
