-------------------------AddNewInstructor -------------------

CREATE Or ALTER PROCEDURE AddInstructor
    @FName nvarchar(15),
    @LName nvarchar(15),
    @Email nvarchar(50),
    @Password nvarchar(50)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Instructor WHERE Email = @Email)
    BEGIN
        IF (
            @Email LIKE '%@gmail.com' OR 
            @Email LIKE '%@yahoo.com' AND
            @Password LIKE '%[A-Z]%' AND
            @Password LIKE '%[a-z]%' AND
            @Password LIKE '%[0-9]%' AND
			LEN(@Password) >= 8 AND 
            LEN(@Password) <= 25
        )
        BEGIN
            INSERT INTO Instructor (FName, LName, Email, [Password])
            VALUES (@FName, @LName, @Email, @Password);

            SELECT 'Instructor added successfully.' AS ResultMessage;
        END
        ELSE
        BEGIN
            SELECT 'Invalid email or password format.' AS ResultMessage;
        END
    END
    ELSE
    BEGIN
        SELECT 'Instructor with the same email already exists IN DATA BASE' AS ResultMessage;
    END
END;
GO




-------------------------UpdateInstructor -------------------

CREATE OR ALTER PROCEDURE UpdateInstructor
    @InstructorID int,
    @FName nvarchar(15),
    @LName nvarchar(15),
    @Email nvarchar(50),
    @Password nvarchar(25)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Instructor WHERE ID = @InstructorID)
    BEGIN
        IF (
            @Email LIKE '%@gmail.com' OR 
            @Email LIKE '%@yahoo.com' AND
            @Password LIKE '%[A-Z]%' AND
            @Password LIKE '%[a-z]%' AND
            @Password LIKE '%[0-9]%' AND
			LEN(@Password) >= 8 AND 
            LEN(@Password) <= 25
        )
        BEGIN
            UPDATE Instructor
            SET 
                FName = @FName,
                LName = @LName,
                Email = @Email,
                [Password] = @Password
            WHERE ID = @InstructorID;

            SELECT 'Instructor updated successfully.' AS ResultMessage;
        END
        ELSE
        BEGIN
            SELECT 'Invalid email or password format.' AS ResultMessage;
        END
    END
    ELSE
    BEGIN
        SELECT 'Instructor not found In database' AS ResultMessage;
    END
END;
GO


----------------------------Delete Instructor-------------

CREATE OR ALTER PROCEDURE DeleteInstructorByID	
    @InstructorID int
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Instructor WHERE ID = @InstructorID)
    BEGIN
        DELETE FROM Instructor
        WHERE ID = @InstructorID;

        SELECT 'Instructor deleted successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Instructor not found IN data base' AS ResultMessage;
    END
END;
GO
