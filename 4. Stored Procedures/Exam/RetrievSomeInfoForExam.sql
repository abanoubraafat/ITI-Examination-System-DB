--Getting All Exams:
CREATE PROCEDURE GetAllExams
AS
BEGIN
    SELECT *
    FROM Exam
END
--test
EXEC GetAllExams

--Getting Exams for a Specific Course:
CREATE PROCEDURE GetExamsByCourse
    @CourseID INT
AS
BEGIN
    SELECT *
    FROM Exam
    WHERE Course_ID = @CourseID
END
--test
EXEC GetExamsByCourse @CourseID = 1

--Getting Exams within a Date Range:
CREATE PROCEDURE GetExamsByDateRange
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
CREATE PROCEDURE GetExamDetailsWithCourseInfo
    @ExamID INT
AS
BEGIN
    SELECT E.*, C.[Name] AS CourseName, C.Description AS CourseDescription
    FROM Exam E
    INNER JOIN Course C ON E.Course_ID = C.ID
    WHERE E.ID = @ExamID
END
--test
EXEC GetExamDetailsWithCourseInfo @ExamID = 2

--Calculating Average Exam Score:
CREATE PROCEDURE CalculateAverageExamScore
    @ExamID INT
AS
BEGIN
    DECLARE @AverageScore DECIMAL(10, 2)

    SELECT @AverageScore = AVG(CAST(Grade AS DECIMAL(10, 2)))
    FROM StudentExam
    WHERE Exam_ID = @ExamID

    SELECT @AverageScore AS AverageScore
END
--test
EXEC CalculateAverageExamScore @ExamID = 1 --this exam deleted
EXEC CalculateAverageExamScore @ExamID = 2


--Retrieving Student Grades for an Exam:
CREATE PROCEDURE GetStudentGradesForExam
    @ExamID INT
AS
BEGIN
    SELECT S.ID AS StudentID, S.FName + ' ' + S.LName AS StudentName, SE.Grade
    FROM StudentExam SE
    INNER JOIN Student S ON SE.Std_ID = S.ID
    WHERE SE.Exam_ID = @ExamID
END
--test
EXEC GetStudentGradesForExam @ExamID = 2

--Updating Student Grade for an Exam:
CREATE PROCEDURE UpdateStudentGradeForExam
    @StudentID INT,
    @ExamID INT,
    @NewGrade INT
AS
BEGIN
    UPDATE StudentExam
    SET Grade = @NewGrade
    WHERE Std_ID = @StudentID AND Exam_ID = @ExamID
END
--test
select * from StudentExam
EXEC UpdateStudentGradeForExam @StudentID = 2, @ExamID = 2, @NewGrade = 85
select * from StudentExam

--Retrieving Detailed Exam Information:
CREATE PROCEDURE GetDetailedExamInfo
    @ExamID INT
AS
BEGIN
    SELECT E.ID AS ExamID, E.NumberOfQuestions, E.StartTime, E.EndTime, E.TotalDegree,
           E.Corrective, E.Normal,
           C.ID AS CourseID, C.[Name] AS CourseName, C.MinDegree, C.MaxDegree, C.[Description] AS CourseDescription,
           I.ID AS InstructorID, I.FName + ' ' + I.LName AS InstructorName, I.Email AS InstructorEmail
    FROM Exam E
    INNER JOIN Course C ON E.Course_ID = C.ID
    INNER JOIN InstructorCourse IC ON C.ID = IC.Course_ID
    INNER JOIN Instructor I ON IC.Instructor_ID = I.ID
    WHERE E.ID = @ExamID
END
--test
EXEC GetDetailedExamInfo @ExamID = 3

--Retrieving Exams with Course Information:
CREATE PROCEDURE GetExamsWithCourseInfo
AS
BEGIN
    SELECT E.ID AS ExamID, E.NumberOfQuestions, E.StartTime, E.EndTime, E.TotalDegree,
           E.Corrective, E.Normal,
           C.ID AS CourseID, C.[Name] AS CourseName, C.MinDegree, C.MaxDegree, C.[Description] AS CourseDescription
    FROM Exam E
    INNER JOIN Course C ON E.Course_ID = C.ID
END
--test
EXEC GetExamsWithCourseInfo
-------

-------


