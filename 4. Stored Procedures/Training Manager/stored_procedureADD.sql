------------------- (1)addOneBranch-----------------------

create procedure AddBranch
    @BranchName nvarchar(50)
as
begin
    
    insert into Branch (Name)
    values (@BranchName);
end;
--test
exec AddBranch
    @BranchName = 'branch5';
 select * from Branch
 

 -------------------------------------(1)AddOneOrMoreBranch---------------------
 
create proc AddOneOrMoreBranche
    @BranchNames nvarchar(MAX)
as
begin
    create table #TempBranches
    (
        BranchName nvarchar(50)
    );
    insert into #TempBranches (BranchName)
    select value FROM STRING_SPLIT(@BranchNames, ',');
    if EXISTS (
        select 1
        from #TempBranches t
        where EXISTS (
            select 1
            from Branch B
            where B.Name = t.BranchName
        )
    )
    begin
        select distinct
            'The ' + t.BranchName + ' is already exist in the database' AS ResultMessage
        from #TempBranches t
        where EXISTS (
            select 1
            from Branch B
           where B.Name = t.BranchName
        );
    end
    else
    begin
        insert into Branch (Name)
        select  t.BranchName
        from #TempBranches t
        where NOT EXISTS (
            select 1
            from Branch B
            where B.Name = t.BranchName
        );

        SELECT 'Branches added successfully.' AS ResultMessage;
    END;
    DROP TABLE #TempBranches;
END;
--test
--select * from  Branch
--exec AddOneOrMoreBranche @BranchNames = 'cairo';
--select * from  Branch

-----------------------(2)AddOneORMoreTrack-----------------
CREATE OR ALTER PROC AddOneOrMoreTrack
    @TrackNames nvarchar(MAX)
AS
BEGIN
    CREATE TABLE #TempTracks
    (
        TrackName nvarchar(50)
    );

    INSERT INTO #TempTracks (TrackName)
    SELECT value FROM STRING_SPLIT(@TrackNames, ',');

    IF EXISTS (
        SELECT 1
        FROM #TempTracks t
        WHERE EXISTS (
            SELECT 1
            FROM Track T
            WHERE T.Name = t.Name
        )
    )
    BEGIN
        SELECT 'The ' + t.TrackName + ' is already exist in the database' AS ResultMessage
        FROM #TempTracks t
        WHERE EXISTS (
            SELECT 1
            FROM Track T
            WHERE T.Name = t.Name
        );
    END
    ELSE
    BEGIN
        INSERT INTO Track (Name)
        SELECT t.TrackName
        FROM #TempTracks t
        WHERE NOT EXISTS (
            SELECT 1
            FROM Track T
            WHERE T.Name = t.Name
        );

        SELECT 'Tracks added successfully.' AS ResultMessage;
    END;

    DROP TABLE #TempTracks;
END;
select * from Track
exec AddOneOrMoreTrack @TrackNames = 'c#';
exec AddOneOrMoreTrack @TrackNames = 'c#';
select * from Track



-------------------------(3)AddOneIntake -------------------

CREATE PROCEDURE AddIntake
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

--select * from Intake
exec AddIntake @IntakeName  = '44';
exec AddIntake @IntakeName  = '55';
select * from Intake

-------------------------(4)AddCourse -------------------

CREATE PROCEDURE AddCourse
    @CourseName nvarchar(50),
    @MinDegree int,
    @MaxDegree int,
    @Description nvarchar(max)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Course WHERE [Name] = @CourseName)
    BEGIN
        INSERT INTO Course ([Name], MinDegree, MaxDegree, [Description])
        VALUES (@CourseName, @MinDegree, @MaxDegree, @Description);

        SELECT 'Course added successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'The course ' + @CourseName + ' is already exist in the database' AS ResultMessage;
    END
END;
--test
select * from Course
EXEC AddCourse
    @CourseName = 'js',
    @MinDegree = 25,
    @MaxDegree = 70,
    @Description = 'third course in front End';
select * from Course
EXEC AddCourse
    @CourseName = 'css',
    @MinDegree = 25,
    @MaxDegree = 70,
    @Description = 'second course in front End';
select * from Course
	EXEC AddCourse
    @CourseName = 'css',
    @MinDegree = 25,
    @MaxDegree = 70,
    @Description = 'second course in front End';

-------------------------(5)AddNewInstractor -------------------

CREATE PROCEDURE AddInstructor
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
            @Password LIKE '%[0-9]%'
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
    @Password = 'Pass123';
SELECT * FROM Instructor
EXEC AddInstructor
    @FName = 'mostafa',
    @LName = 'abdella',
    @Email = 'mostafaabdella88@gmail.com',
    @Password = 'Pass123';
------with incorrect pass or email---------
EXEC AddInstructor
    @FName = 'mostafa',
    @LName = 'abdella',
    @Email = 'mostafaabdella88',
    @Password = 'Pass123';



-------------------------------------(6)AddNewStudent------------------------

CREATE PROCEDURE AddStudent
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
            @Password LIKE '%[0-9]%'
        )
        BEGIN
            INSERT INTO Student (FName, LName, GraduationYear, Email, [Password])
            VALUES (@FName, @LName, @GraduationYear, @Email, @Password);

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
    @FName = 'ali',
    @LName = 'abdella',
    @GraduationYear = '2020',
    @Email = 'ali88@gmail.com',
    @Password = 'Pass123';
SELECT * from Student
EXEC AddStudent
    @FName = 'ali',
    @LName = 'abdella',
    @GraduationYear = '2020',
    @Email = 'ali88@gmail.com',
    @Password = 'Pass123';
--------------- Incorrect pass or email------------------ 
EXEC AddStudent
    @FName = 'ali',
    @LName = 'abdella',
    @GraduationYear = '2020',
    @Email = 'ali88@gmail',
    @Password = 'Pass123';


-----------------------------(7)AddNewquestion--------------------------

CREATE PROCEDURE AddQuestion
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
    IF NOT EXISTS (
        SELECT 1 
        FROM Question 
        WHERE QuestionText = @QuestionText
    )
    BEGIN
        INSERT INTO Question ([Type], QuestionText, CorrectAnswer, True, False, Choise_1, Choise_2, Choise_3, Choise_4)
        VALUES (
            @QuestionType, 
            @QuestionText, 
            @CorrectAnswer, 
            @TrueOption, 
            @FalseOption, 
            @Choice1, 
            @Choice2, 
            @Choice3, 
            @Choice4
        );

        SELECT 'Question added successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Question with the same text already exists in database' AS ResultMessage;
    END
END;
--test 
SELECT * FROM Question
EXEC AddQuestion
    @QuestionType = 'Multiple Choice',
    @QuestionText = 'What is first course in front End?',
    @CorrectAnswer = 'HTML',
    @TrueOption = 0,
    @FalseOption = 0,
    @Choice1 = 'HTML',
    @Choice2 = 'css',
    @Choice3 = 'js',
    @Choice4 = 'c++';
SELECT * FROM Question
EXEC AddQuestion
    @QuestionType = 'Multiple Choice',
    @QuestionText = 'What is first course in front End?',
    @CorrectAnswer = 'HTML',
    @TrueOption = 0,
    @FalseOption = 0,
    @Choice1 = 'HTML',
    @Choice2 = 'css',
    @Choice3 = 'js',
    @Choice4 = 'c++';

	




