-------------------------------------AddNewStudent------------------------

CREATE OR ALTER PROCEDURE AddStudent
	@ID INT,
    @FName nvarchar(15),
    @LName nvarchar(15),
    @GraduationYear char(4),
    @Email nvarchar(50),
    @Password nvarchar(50)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Student WHERE Email = @Email)
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
            INSERT INTO Student (ID,FName, LName, GraduationYear, Email, [Password])
            VALUES (@ID,  @FName, @LName, @GraduationYear, @Email, @Password);

            SELECT 'Student added successfully.' AS ResultMessage;
        END
        ELSE
        BEGIN
            SELECT 'Invalid email or password format.' AS ResultMessage;
        END
    END
    ELSE
    BEGIN
        SELECT 'Student with the same email already exists IN database' AS ResultMessage;
    END
END;
--test
SELECT * from Student
EXEC AddStudent
    @ID=7,
    @FName = 'ali',
    @LName = 'abdella',
    @GraduationYear = '2020',
    @Email = 'ali88@gmail.com',
    @Password = 'Pass123Y';
SELECT * from Student

--------------- Incorrect pass or email------------------ 
EXEC AddStudent
	@ID=8,
    @FName = 'ali',
    @LName = 'abdella',
    @GraduationYear = '2020',
    @Email = 'ali88@gmail',
    @Password = 'Pass123F';

-------------------------Update Student -------------------

CREATE PROCEDURE UpdateStudent
    @StudentID int,
    @FName nvarchar(15),
    @LName nvarchar(15),
    @GraduationYear char(4),
    @Email nvarchar(50),
    @Password nvarchar(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Student WHERE ID = @StudentID)
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
            UPDATE Student
            SET 
                FName = @FName,
                LName = @LName,
                GraduationYear = @GraduationYear,
                Email = @Email,
                [Password] = @Password
            WHERE ID = @StudentID;

            SELECT 'Student updated successfully.' AS ResultMessage;
        END
        ELSE
        BEGIN
            SELECT 'Invalid email or password format.' AS ResultMessage;
        END
    END
    ELSE
    BEGIN
        SELECT 'Student not found In data base' AS ResultMessage;
    END
END;
--test
SELECT * FROM Student
EXEC UpdateStudent
    @StudentID = 8, 
    @FName = 'mostafa',
    @LName = 'abdella',
    @GraduationYear = '2021',
    @Email = 'mostafaabdella88@gmail.com',
    @Password = 'Pass123H';
SELECT * FROM Student

----------------------------Delete student-------------

CREATE PROCEDURE DeleteStudent
    @StudentID int
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Student WHERE ID = @StudentID)
    BEGIN
        DELETE FROM Student
        WHERE ID = @StudentID;

        SELECT 'Student deleted successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Student not found In database' AS ResultMessage;
    END
END;
--test
SELECT * FROM Student
EXEC DeleteStudent @StudentID = 7;