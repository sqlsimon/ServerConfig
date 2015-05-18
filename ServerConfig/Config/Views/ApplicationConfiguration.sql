CREATE VIEW [Config].[ApplicationConfiguration] WITH SCHEMABINDING
	AS 
	SELECT 
		-- ac.ApplicationId
		a.ApplicationName
	--	,ac.ComponentId
		,c.ComponentName
	FROM Config.ApplicationComponents ac
	INNER JOIN Config.Applications a ON ac.ApplicationId = a.Id
	INNER JOIN Config.Components c ON ac.ComponentId = c.Id

