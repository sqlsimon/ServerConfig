

TRUNCATE TABLE Config.Applications
TRUNCATE TABLE Config.Components
TRUNCATE TABLE Config.ApplicationComponents

INSERT INTO Config.Applications (Id,ApplicationName) VALUES 
(1,'Application1'),
(2,'Application2')


INSERT INTO Config.Components(Id,ComponentName) VALUES 
(1,'AgentJobs'),
(2,'SSIS')


INSERT INTO Config.ApplicationComponents(ApplicationId,ComponentId) VALUES 
(1,1),
(1,2),
(2,1),
(2,2)

