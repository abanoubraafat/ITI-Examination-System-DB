-----------------------AddOneORMoreTrack---------------
CREATE OR ALTER PROC AddTracks
    @TrackNames NVARCHAR(MAX)
AS
BEGIN
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


exec AddTracks  @TrackNames = 'jjjj';
exec AddTracks @TrackNames = 'C#';
select * from Track

----------------------------Update the Track-----------

CREATE PROCEDURE UpdateTrackNames
    @OldTrackName nvarchar(50),
    @NewTrackName nvarchar(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Track WHERE Name = @OldTrackName)
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
    @OldTrackName = 'jjjj',
    @NewTrackName = 'c++';
select * from Track
EXEC UpdateTrackNames
    @OldTrackName = '.net',
    @NewTrackName = 'c++';

----------------------------Delete Track---------------

CREATE PROCEDURE DeleteTrack
    @TrackID nvarchar(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Track WHERE ID = @TrackID)
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
EXEC DeleteTrack @TrackID = 8;
select * from Track