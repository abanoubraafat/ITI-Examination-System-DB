--Getting All Exams:
CREATE OR ALTER PROCEDURE GetAllExams
AS
BEGIN
    SELECT *
    FROM Exam
END

Go


--Getting Exams for a Specific Course:
CREATE OR ALTER PROCEDURE GetExamsByCourse
    @CourseID INT
AS
BEGIN
    SELECT *
    FROM Exam
    WHERE ID = @CourseID
END

Go


--Getting Exams within a Date Range:
CREATE OR ALTER PROCEDURE GetExamsByDateRange
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT *
    FROM Exam
    WHERE StartTime BETWEEN @StartDate AND @EndDate
END
Go 


--Getting Exam Details along with Course Information:
CREATE OR ALTER PROCEDURE GetExamDetailsWithCourseInfo
    @ExamID INT
AS
BEGIN
    SELECT E.*, C.[Name] AS Course_Name, C.Description AS Course_Description
    FROM Exam E
    INNER JOIN Course C ON E.ID = C.ID
    WHERE E.ID = @ExamID
END
GO


--Retrieving Exams with Course Information:
CREATE OR ALTER PROCEDURE GetExamsWithCourseInfo
AS
BEGIN
    SELECT E.ID AS ExamID, E.NumberOfQuestions, E.StartTime, E.EndTime, E.TotalDegree,
           E.Corrective, E.Normal,
           C.ID AS CourseID, C.[Name] AS CourseName, C.MinDegree, C.MaxDegree, C.[Description] AS CourseDescription
    FROM Exam E
    INNER JOIN Course C ON E.ID = C.ID
END
Go

-------
-- Create a view that combines information from StudentExamQuestions, ExamQuestion, Student, Exam, and Question tables
