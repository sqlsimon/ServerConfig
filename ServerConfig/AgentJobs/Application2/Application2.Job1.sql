
/****** Object:  Job [Job1]    Script Date: 04/08/2014 15:49:58 ******/
BEGIN TRANSACTION

/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 04/08/2014 15:49:58 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Application2' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Application2'

END

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = 'Application2_Job1')
	EXEC msdb.dbo.sp_delete_job @job_name=N'Application2_Job1', @delete_unused_schedule=1


EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Application2_Job1', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Application2_Job1', 
		@category_name=N'Application2', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT

/****** Object:  Step [Run Inbound.Applications.Extract.dtsx]    Script Date: 04/08/2014 15:49:58 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run Inbound.Applications.Extract.dtsx', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=N'/ISSERVER "\"\SSISDB\ETL\Application.Inbound.etl\Inbound.Applications.Extract.dtsx\"" /SERVER "\".\"" /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1 /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E', 
		@database_name=N'master', 
		@flags=0

EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1

EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'

COMMIT TRANSACTION




