-----------------------AddOneORMoreTrack---------------
CREATE OR ALTER PROC AddTracks
	@Username varchar(10),
	@Password varchar(10),	
    @TrackNames NVARCHAR(MAX)
AS
BEGIN
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    BEGIN TRY
        CREATE TABLE #TempTracks
        (
            TrackName NVARCHAR(50)
        );

        INSERT INTO #TempTracks (TrackName)
        SELECT value FROM STRING_SPLIT(@TrackNames, ',');

        IF EXISTS (
            SELECT 1
            FROM #TempTracks
            WHERE NOT EXISTS (
                SELECT 1
                FROM Track T
                WHERE T.Name = #TempTracks.TrackName
            )
        )
        BEGIN
            INSERT INTO Track (Name)
            SELECT TrackName
            FROM #TempTracks
            WHERE NOT EXISTS (
                SELECT 1
                FROM Track T
                WHERE T.Name = #TempTracks.TrackName
            );

            SELECT 'Tracks added successfully.' AS ResultMessage;
        END
        ELSE
        BEGIN
            SELECT DISTINCT
                'The following track(s) already exist in the database: ' + 
                STRING_AGG(TrackName, ', ') AS ResultMessage
            FROM #TempTracks
            WHERE EXISTS (
                SELECT 1
                FROM Track T
                WHERE T.Name = #TempTracks.TrackName
            );
        END;

        DROP TABLE #TempTracks;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;


exec AddTracks  'manager', 'manager',  @TrackNames = 'jjjj';
exec AddTracks 'manager', 'manager',  @TrackNames = 'C#';
select * from Track

----------------------------Update the Track-----------

CREATE OR ALTER PROCEDURE UpdateTrackNames
	@Username varchar(10),
	@Password varchar(10),	
    @OldTrackName nvarchar(50),
    @NewTrackName nvarchar(50)
AS
BEGIN
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    ELSE IF EXISTS (SELECT 1 FROM Track WHERE Name = @OldTrackName)
    BEGIN
        UPDATE Track
        SET Name = @NewTrackName
        WHERE Name = @OldTrackName;

        SELECT 'Track updated successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Track not found IN data base' AS ResultMessage;
    END
END;
--test 
select * from Track
EXEC UpdateTrackNames
 'manager', 'manager', 
    @OldTrackName = 'jjjj',
    @NewTrackName = 'c++';
select * from Track
EXEC UpdateTrackNames
 'manager', 'manager', 
    @OldTrackName = '.net',
    @NewTrackName = 'c++';

----------------------------Delete Track---------------

CREATE OR ALTER PROCEDURE DeleteTrack
	@Username varchar(10),
	@Password varchar(10),	
    @TrackID nvarchar(50)
AS
BEGIN
IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    ELSE IF EXISTS (SELECT 1 FROM Track WHERE ID = @TrackID)
    BEGIN
        DELETE FROM Track
        WHERE ID = @TrackID;

        SELECT 'Track deleted successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Track not found In data base' AS ResultMessage;
    END
END;
--test 
select * from Track
EXEC DeleteTrack  'manager', 'manager',  @TrackID = 8;
select * from Track