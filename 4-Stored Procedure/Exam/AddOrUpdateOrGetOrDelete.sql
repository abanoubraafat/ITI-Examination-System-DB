
--Read Procedure to Get Exam Details:
CREATE OR ALTER PROCEDURE GetExamDetails
	@Username varchar(10),
	@Password varchar(10),
    @ExamID INT
AS
BEGIN
	IF not((@Username = 'instructor' and @Password = 'instructor') or (@Username = 'manager' and @Password = 'manager'))
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    SELECT *
    FROM Exam
    WHERE ID = @ExamID
END
GO

--Update Procedure to Modify Exam Details:
CREATE OR ALTER PROCEDURE UpdateExam
	@Username varchar(10),
	@Password varchar(10),
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
	IF not((@Username = 'instructor' and @Password = 'instructor') or (@Username = 'manager' and @Password = 'manager'))
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
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
	@Username varchar(10),
	@Password varchar(10),
    @ExamID INT
AS
BEGIN
	IF not((@Username = 'instructor' and @Password = 'instructor') or (@Username = 'manager' and @Password = 'manager'))
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    DELETE FROM Exam
    WHERE ID = @ExamID
END
Go
