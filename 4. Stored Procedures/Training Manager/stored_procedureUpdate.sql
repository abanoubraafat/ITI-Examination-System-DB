--------------------(1)Update the Branch----------------

CREATE PROCEDURE UpdateBranchNames
    @OldBranchName nvarchar(50),
    @NewBranchName nvarchar(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Branch WHERE Name = @OldBranchName)
    BEGIN
        UPDATE Branch
        SET Name = @NewBranchName
        WHERE Name = @OldBranchName;

        SELECT 'Branch updated successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Branch not found IN data base' AS ResultMessage;
    END
END;

--test
select * from Branch
EXEC UpdateBranchNames
    @OldBranchName = 'cairo',
    @NewBranchName = 'miniya';
select * from Branch
EXEC UpdateBranchNames
    @OldBranchName = 'cairo',
    @NewBranchName = 'miniya';

----------------------------(2)Update the Track-----------

CREATE PROCEDURE UpdateTrackNames
    @OldTrackName NVARCHAR(50),
    @NewTrackName NVARCHAR(50)
AS
BEGIN
    PRINT 'Old Track Name: ' + @OldTrackName;
    PRINT 'New Track Name: ' + @NewTrackName;

    IF EXISTS (SELECT 1 FROM Track WHERE [Name] = @OldTrackName)
    BEGIN
        UPDATE Track
        SET [Name] = @NewTrackName
        WHERE [Name] = @OldTrackName;

        SELECT 'Track updated successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Track not found IN database' AS ResultMessage;
    END
END;

--test 
select * from Track
EXEC UpdateTrackNames
    @OldTrackName = 'c++',
    @NewTrackName = 'Full stack web developer using .NET';
select * from Track
EXEC UpdateTrackNames
    @OldTrackName = '.net',
    @NewTrackName = 'kkk';


--------------------------(3)update the intake ------------

CREATE PROCEDURE UpdateIntakeNames
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
--test 
select * from Intake
EXEC UpdateIntakeNames
    @OldIntakeName = '44',
    @NewIntakeName = '66';
select * from Intake
EXEC UpdateIntakeNames
    @OldIntakeName = '44',
    @NewIntakeName = '66';

-------------------------(4)UpdateCourse -------------------

CREATE PROCEDURE UpdateCourse
    @OldCourseName nvarchar(50),
    @NewCourseName nvarchar(50),
    @MinDegree int,
    @MaxDegree int,
    @Description nvarchar(max)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course WHERE [Name] = @OldCourseName)
    BEGIN
        UPDATE Course
        SET [Name] = @NewCourseName,
            MinDegree = @MinDegree,
            MaxDegree = @MaxDegree,
            [Description] = @Description
        WHERE [Name] = @OldCourseName;

        SELECT 'Course updated successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Course not found IN DATA BASE' AS ResultMessage;
    END
END;
--test
SELECT * FROM Course
EXEC UpdateCourse
    @OldCourseName = 'JS',
    @NewCourseName = 'HTML',
    @MinDegree = 10,
    @MaxDegree = 90,
    @Description = 'THE FIRST COURSE IN FRONT END';
SELECT * FROM Course
EXEC UpdateCourse
    @OldCourseName = 'JS',
    @NewCourseName = 'HTML',
    @MinDegree = 10,
    @MaxDegree = 90,
    @Description = 'THE FIRST COURSE IN FRONT END';
SELECT * FROM Course

-------------------------(5)UpdateInstractor -------------------

CREATE PROCEDURE UpdateInstructor
    @InstructorID int,
    @FName nvarchar(15),
    @LName nvarchar(15),
    @Email nvarchar(50),
    @Password nvarchar(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Instructor WHERE ID = @InstructorID)
    BEGIN
        IF (
            @Email LIKE '%@gmail.com' OR 
            @Email LIKE '%@yahoo.com' AND
            @Password LIKE '%[A-Z]%' AND
            @Password LIKE '%[a-z]%' AND
            @Password LIKE '%[0-9]%'
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
    @InstructorID = 5 , 
    @FName = 'abounob',
    @LName = 'bebo',
    @Email = 'bebo88@gmail.com',
    @Password = 'Pass1234';

-------------------------(6)Update Student -------------------

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
            @Password LIKE '%[0-9]%'
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
    @StudentID = 1, 
    @FName = 'mostafa',
    @LName = 'abdella',
    @GraduationYear = '2021',
    @Email = 'mostafaabdella88@gmail.com',
    @Password = 'Pass123';
SELECT * FROM Student
EXEC UpdateStudent
    @StudentID = 5, 
    @FName = 'mostafa',
    @LName = 'abdella',
    @GraduationYear = '2021',
    @Email = 'mostafaabdella88@gmail.com',
    @Password = 'Pass123';


-------------------------(7)Update Question -------------------

CREATE PROCEDURE UpdateQuestion
    @QuestionID int,
    @QuestionType nvarchar(15),
    @QuestionText nvarchar(max),
    @CorrectAnswer nvarchar(300),
    @TrueOption bit,
    @FalseOption bit,
    @Choice1 nvarchar(30),
    @Choice2 nvarchar(30),
    @Choice3 nvarchar(30),
    @Choice4 nvarchar(30)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Question WHERE ID = @QuestionID)
    BEGIN
        UPDATE Question
        SET 
            [Type] = @QuestionType,
            QuestionText = @QuestionText,
            CorrectAnswer = @CorrectAnswer,
            True = @TrueOption,
            False = @FalseOption,
            Choise_1 = @Choice1,
            Choise_2 = @Choice2,
            Choise_3 = @Choice3,
            Choise_4 = @Choice4
        WHERE ID = @QuestionID;

        SELECT 'Question updated successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Question not found IN data base' AS ResultMessage;
    END
END;

--test 
SELECT * FROM Question
EXEC UpdateQuestion
    @QuestionID = 2,
    @QuestionType = 'T or F',
    @QuestionText = 'HTML is first course in front End?',
    @CorrectAnswer = 'True',
    @TrueOption = 1,
    @FalseOption = 0,
    @Choice1 = '',
    @Choice2 = '',
    @Choice3 = '',
    @Choice4 = '';
SELECT * FROM Question
EXEC UpdateQuestion
    @QuestionID = 1,
    @QuestionType = 'T or F',
    @QuestionText = 'HTML is first course in front End?',
    @CorrectAnswer = 'True',
    @TrueOption = 1,
    @FalseOption = 0,
    @Choice1 = '',
    @Choice2 = '',
    @Choice3 = '',
    @Choice4 = '';


