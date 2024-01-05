-----------------------------(1)Delete Branch-------------

CREATE PROCEDURE DeleteBranch
    @BranchName nvarchar(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Branch WHERE Name = @BranchName)
    BEGIN
        DELETE FROM Branch
        WHERE Name = @BranchName;

        SELECT 'Branch deleted successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Branch not found In data base' AS ResultMessage;
    END
END;
select * from Branch
EXEC DeleteBranch @BranchName = 'mansoura';
select * from Branch
EXEC DeleteBranch @BranchName = 'mansoura';

----------------------------(2)Delete Track---------------

CREATE PROCEDURE DeleteTrack
    @TrackName nvarchar(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Track WHERE Name = @TrackName)
    BEGIN
        DELETE FROM Track
        WHERE Name = @TrackName;

        SELECT 'Track deleted successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Track not found In data base' AS ResultMessage;
    END
END;
--test 
select * from Track
EXEC DeleteTrack @TrackName = 'c#';
select * from Track
EXEC DeleteTrack @TrackName = 'c#';


----------------------------(3)Delete Intake-------------

CREATE PROCEDURE DeleteIntake
    @IntakeName nvarchar(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Intake WHERE Name = @IntakeName)
    BEGIN
        DELETE FROM Intake
        WHERE Name = @IntakeName;

        SELECT 'Intake deleted successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Intake not found In data base' AS ResultMessage;
    END
END;
--test 
select * from Intake
EXEC DeleteIntake @IntakeName = '66';
select * from Intake
EXEC DeleteIntake @IntakeName = '66';

----------------------------(4)Delete Course-------------

CREATE PROCEDURE DeleteCourse
    @CourseName nvarchar(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course WHERE [Name] = @CourseName)
    BEGIN
        DELETE FROM Course
        WHERE [Name] = @CourseName;

        SELECT 'Course deleted successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Course not found iN data base' AS ResultMessage;
    END
END;
--test
Select * from Course
EXEC DeleteCourse @CourseName = 'HTML';
Select * from Course
EXEC DeleteCourse @CourseName = 'HTML';

----------------------------(5)Delete Instractor-------------

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
EXEC DeleteInstructorByID @InstructorID = 1;
EXEC DeleteInstructorByID @InstructorID = 4;
SELECT * FROM Instructor

----------------------------(6)Delete student-------------

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
EXEC DeleteStudent @StudentID = 1;
EXEC DeleteStudent @StudentID = 4;
SELECT * FROM Student
*/

----------------------------(7)Delete Question-------------

CREATE PROCEDURE DeleteQuestion
    @QuestionID int
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Question WHERE ID = @QuestionID)
    BEGIN
        DELETE FROM Question
        WHERE ID = @QuestionID;

        SELECT 'Question deleted successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Question not found IN data base' AS ResultMessage;
    END
END;
--test
SELECT * FROM Question
EXEC DeleteQuestion @QuestionID = 4;
EXEC DeleteQuestion @QuestionID = 1;








