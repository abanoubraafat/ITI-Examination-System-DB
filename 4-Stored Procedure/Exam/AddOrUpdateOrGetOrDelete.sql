
--Read Procedure to Get Exam Details:
CREATE OR ALTER PROCEDURE GetExamDetails
    @ExamID INT
AS
BEGIN
    SELECT *
    FROM Exam
    WHERE ID = @ExamID
END
GO

--Update Procedure to Modify Exam Details:
CREATE OR ALTER PROCEDURE UpdateExam
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
        Normal = @Normal
    WHERE ID = @ExamID
END
Go

--Delete Procedure to Remove an Exam:
CREATE OR ALTER PROCEDURE DeleteExam
    @ExamID INT
AS
BEGIN
    DELETE FROM Exam
    WHERE ID = @ExamID
END
Go
