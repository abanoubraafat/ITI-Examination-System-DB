--Trigger To prevent drop any table from system
CREATE OR ALTER Trigger ddlt_PreventDDLDropTable
ON DATABASE FOR DROP_TABLE
AS

SELECT
 EventType = EVENTDATA().value('(EVENT_INSTANCE/EventType)[1]', 'sysname'),
 PostTime = EVENTDATA().value('(EVENT_INSTANCE/PostTime)[1]', 'datetime'),
 LoginName = EVENTDATA().value('(EVENT_INSTANCE/LoginName)[1]', 'sysname'),
 UserName = EVENTDATA().value('(EVENT_INSTANCE/UserName)[1]', 'sysname'),
 DatabaseName = EVENTDATA().value('(EVENT_INSTANCE/DatabaseName)[1]', 'sysname'),
 SchemaName = EVENTDATA().value('(EVENT_INSTANCE/SchemaName)[1]', 'sysname'),
 ObjectName = EVENTDATA().value('(EVENT_INSTANCE/ObjectName)[1]', 'sysname'),
 ObjectType = EVENTDATA().value('(EVENT_INSTANCE/ObjectType)[1]', 'sysname'),
 CommandText = EVENTDATA().value('(EVENT_INSTANCE//TSQLCommand[1]/CommandText)[1]', 'nvarchar(max)')

RAISERROR ('You can not drop table in this database', 10, 1);
ROLLBACK;

DROP TABLE [dbo].[TrainngManagerManage]




