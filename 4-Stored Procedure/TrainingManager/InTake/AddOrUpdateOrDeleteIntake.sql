-------------------------AddOneIntake -------------------

CREATE PROCEDURE AddIntake
	@Username varchar(10),
	@Password varchar(10),	
    @IntakeName nvarchar(50)
AS
BEGIN
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
   ELSE IF NOT EXISTS (SELECT 1 FROM Intake WHERE Name = @IntakeName)
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

CREATE PROCEDURE UpdateIntakeNames
	@Username varchar(10),
	@Password varchar(10),	
    @OldIntakeName nvarchar(50),
    @NewIntakeName nvarchar(50)
AS
BEGIN
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    ELSE IF EXISTS (SELECT 1 FROM Intake WHERE Name = @OldIntakeName)
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

CREATE PROCEDURE DeleteIntake
	@Username varchar(10),
	@Password varchar(10),	
    @IntakeID nvarchar(50)
AS
BEGIN
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    ELSE IF EXISTS (SELECT 1 FROM Intake WHERE ID = @IntakeID)
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