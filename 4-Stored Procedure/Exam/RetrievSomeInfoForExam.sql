--Getting All Exams:
CREATE OR ALTER PROCEDURE GetAllExams
AS
BEGIN
    SELECT *
    FROM Exam
END
--test
EXEC GetAllExams

--Getting Exams for a Specific Course:
CREATE OR ALTER PROCEDURE GetExamsByCourse
    @CourseID INT
AS
BEGIN
    SELECT *
    FROM Exam
    WHERE ID = @CourseID
END
--test
EXEC GetExamsByCourse  @CourseID = 1

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
--test
EXEC GetExamsByDateRange @StartDate = '2024-01-01', @EndDate = '2024-01-31'

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
--test
EXEC GetExamDetailsWithCourseInfo @ExamID = 30


--Retrieving Detailed Exam Information:
CREATE OR ALTER PROCEDURE GetDetailedExamInfo
    @ExamID INT
AS
BEGIN

    SELECT E.ID AS ExamID, E.NumberOfQuestions, E.StartTime, E.EndTime, E.TotalDegree,
           E.Corrective, E.Normal,
           C.ID AS CourseID, C.[Name] AS CourseName, C.MinDegree, C.MaxDegree, C.[Description] AS CourseDescription,
           I.ID AS InstructorID, I.FName + ' ' + I.LName AS InstructorName, I.Email AS InstructorEmail
    FROM Exam E
    INNER JOIN Course C ON E.ID = C.ID
    INNER JOIN InstructorCourse IC ON C.ID = IC.Course_ID
    INNER JOIN Instructor I ON IC.Instructor_ID = I.ID
    WHERE E.ID = @ExamID
END
--test

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
--test
EXEC GetExamsWithCourseInfo
-------
-- Create a view that combines information from StudentExamQuestions, ExamQuestion, Student, Exam, and Question tables
CREATE OR ALTER VIEW ExamResultsView
AS
SELECT 
    se.Std_ID,
    se.Exam_ID,
    se.Questions_result,
    se.Std_Answer_Text_Question,
    se.Std_Answer_Choose_Question,
    se.Std_Answer_True_or_False,
    se.Questions_Id,
    eq.QuestionType,
    eq.QuestionGrade,
    q.Correct_Answer_Text_Questions,
    q.Correct_Answer_Choose_Question,
    q.Correct_Answer_True_or_False,
    e.TotalDegree
FROM StudentExamQuestions se
INNER JOIN ExamQuestion eq ON se.Exam_ID = eq.Exam_ID AND se.Questions_Id = eq.Question_ID
INNER JOIN Question q ON se.Questions_Id = q.Questions_ID
INNER JOIN Exam e ON se.Exam_ID = e.ID;
--test
SELECT * FROM ExamResultsView WHERE Std_ID = 1 AND Exam_ID = 2;
