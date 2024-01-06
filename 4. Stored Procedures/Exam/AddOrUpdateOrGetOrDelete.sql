--Create Procedure for Adding an Exam:
CREATE PROCEDURE AddExam
    @NumberOfQuestions INT,
    @StartTime DATE,
    @EndTime DATE,
    @TotalDegree INT,
    @Corrective BIT,
    @Normal BIT,
    @Course_ID INT
AS
BEGIN
    INSERT INTO Exam (NumberOfQuestions, StartTime, EndTime, TotalDegree, Corrective, Normal, Course_ID)
    VALUES (@NumberOfQuestions, @StartTime, @EndTime, @TotalDegree, @Corrective, @Normal, @Course_ID)
END
--test
EXEC AddExam 
    @NumberOfQuestions = 20,
    @StartTime = '2024-01-07',
    @EndTime = '2024-01-07',
    @TotalDegree = 20,
    @Corrective = 0,
    @Normal = 1,
    @Course_ID = 1

--Read Procedure to Get Exam Details:
CREATE PROCEDURE GetExamDetails
    @ExamID INT
AS
BEGIN
    SELECT *
    FROM Exam
    WHERE ID = @ExamID
END
--test
EXEC GetExamDetails @ExamID = 1

--Update Procedure to Modify Exam Details:
CREATE PROCEDURE UpdateExam
    @ExamID INT,
    @NumberOfQuestions INT,
    @StartTime DATE,
    @EndTime DATE,
    @TotalDegree INT,
    @Corrective BIT,
    @Normal BIT,
    @Course_ID INT
AS
BEGIN
    UPDATE Exam
    SET NumberOfQuestions = @NumberOfQuestions,
        StartTime = @StartTime,
        EndTime = @EndTime,
        TotalDegree = @TotalDegree,
        Corrective = @Corrective,
        Normal = @Normal,
        Course_ID = @Course_ID
    WHERE ID = @ExamID
END
--test
EXEC UpdateExam 
    @ExamID = 1,
    @NumberOfQuestions = 25,
    @StartTime = '2024-01-08',
    @EndTime = '2024-01-08',
    @TotalDegree = 25,
    @Corrective = 0,
    @Normal = 1,
    @Course_ID = 2

EXEC GetExamDetails @ExamID = 1
--Delete Procedure to Remove an Exam:
CREATE PROCEDURE DeleteExam
    @ExamID INT
AS
BEGIN
    DELETE FROM Exam
    WHERE ID = @ExamID
END
--test
EXEC DeleteExam @ExamID = 1
EXEC GetExamDetails @ExamID = 1