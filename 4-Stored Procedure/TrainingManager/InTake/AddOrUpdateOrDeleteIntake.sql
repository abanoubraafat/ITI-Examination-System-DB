-------------------------AddOneIntake -------------------

CREATE OR ALTER PROCEDURE AddIntake
    @IntakeName nvarchar(50)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Intake WHERE Name = @IntakeName)
    BEGIN
         INSERT INTO Intake (Name)
        VALUES (@IntakeName);
        SELECT 'Intake added successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Intake name already exists in the database.' AS ResultMessage;
    END
END;
GO

--------------------------update the intake ------------

CREATE OR ALTER PROCEDURE UpdateIntakeNames
    @OldIntakeName nvarchar(50),
    @NewIntakeName nvarchar(50)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Intake WHERE Name = @OldIntakeName)
    BEGIN
        UPDATE Intake
        SET Name = @NewIntakeName
        WHERE Name = @OldIntakeName;

        SELECT 'Intake updated successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Intake not found IN data base' AS ResultMessage;
    END
END;
GO


----------------------------Delete Intake-------------

CREATE OR ALTER PROCEDURE DeleteIntake
    @IntakeID nvarchar(50)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Intake WHERE ID = @IntakeID)
    BEGIN
        DELETE FROM Intake
        WHERE ID = @IntakeID;

        SELECT 'Intake deleted successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Intake not found In data base' AS ResultMessage;
    END
END;
Go