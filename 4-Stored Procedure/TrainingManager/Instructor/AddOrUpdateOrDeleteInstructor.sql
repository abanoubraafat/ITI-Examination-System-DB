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
--test
SELECT * FROM Instructor
EXEC AddInstructor
    @FName = 'mostafa',
    @LName = 'abdella',
    @Email = 'mostafaabdella88@gmail.com',
    @Password = 'Pass123t';
SELECT * FROM Instructor
EXEC AddInstructor
    @FName = 'mostafa',
    @LName = 'abdella',
    @Email = 'mostafaabdella88@gmal.com',
    @Password = 'Pass123';
------with incorrect pass or email---------
EXEC AddInstructor
    @FName = 'mostafa',
    @LName = 'abdella',
    @Email = 'mostafaabdella88',
    @Password = 'Pass123';


-------------------------UpdateInstructor -------------------

CREATE PROCEDURE UpdateInstructor
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
-- Test 
SELECT * FROM Instructor
EXEC UpdateInstructor
    @InstructorID = 1, 
    @FName = 'abounob',
    @LName = 'bebo',
    @Email = 'bebo88@gmail.com',
    @Password = 'Pass1234';
SELECT * FROM Instructor
EXEC UpdateInstructor
    @InstructorID = 8 , 
    @FName = 'abounob',
    @LName = 'bebo',
    @Email = 'bebo88@gmail.com',
    @Password = 'Pass1234';

----------------------------Delete Instructor-------------

CREATE PROCEDURE DeleteInstructorByID
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
--test 
SELECT * FROM Instructor
EXEC DeleteInstructorByID @InstructorID = 8;