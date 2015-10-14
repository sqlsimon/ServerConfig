##ServerConfig Database Project
This project is intended to be used to configure server level elements of an SQL Server based Business Intelligence solution. Currently SQL Agent jobs and SSIS Environments are supported.

### Background
Typically an application would comprise:

* Application Databases
* A SSIS Project(s) deployed to the SSIS Catalog / SSIS Folder deployed to MSDB
* A SSIS Environment(s) 
* One or more SQL Agent jobs 
* SSAS Database

Application databases will be deployed and managed via other .sqlproj projects; SSIS Projects will be managed
via .dtproj deployments; and SSAS databases deployed via .dwproj projects. 

Traditionally, dealing with SSIS Environment configurations and Agent jobs has been dealt with out-of-band and
often environment configuration and jobs are not version controlled and manually set up on each environment.

The ServerConfig project attempts to address this gap, by allowing Agent Jobs and SSIS Environment configuration
to be source controlled and deployed as similar manner as possible to application Databases. In addition it allows
Agent Jobs and environment configuration to be packaged into a .dacpac file for deployment.

### Components

There are two main components to the project

* User Editable files 
* Helper objects 

Helper objects should not be edited. The following are helper objects:
	
* Objects in the "Config" Directory
* Objects in the "Helpers" Directory
* Objects in the "SSIS" Directory
* Objects in the "Security" Directory


User editable objects are

*	The ServerConfigMain.sql script
*	ApplicationX_ServerConfig.sql scripts
*	The Setup.sql and SSISVariales.sql Under the Environments\XXX folders
*   Scripts Under the AgentJobs\ApplicationX folders

###Setting up a new Application

To configure an application follow the steps below:    
  
*   Do this

 

