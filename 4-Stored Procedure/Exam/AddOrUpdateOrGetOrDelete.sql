--Create Procedure for Adding an Exam:
--CREATE OR ALTER PROCEDURE AddExam ----NO Course ID IN EXAM TABLE
--	@Username varchar(10),
--	@Password varchar(10),
--    @NumberOfQuestions INT,
--    @StartTime DATE,
--    @EndTime DATE,
--    @TotalDegree INT,
--    @Corrective BIT,
--    @Normal BIT,
--    @Course_ID INT
--AS
--BEGIN
--	IF not((@Username = 'instructor' and @Password = 'instructor') or (@Username = 'manager' and @Password = 'manager'))
--	begin
--		SELECT 'Access Denied' AS ResultMessage
--		RETURN
--	end
--    INSERT INTO Exam (NumberOfQuestions, StartTime, EndTime, TotalDegree, Corrective, Normal, Course_ID)
--    VALUES (@NumberOfQuestions, @StartTime, @EndTime, @TotalDegree, @Corrective, @Normal, @Course_ID)
--END
----test
--EXEC AddExam 
-- 'instructor', 'instructor', 
--    @NumberOfQuestions = 20,
--    @StartTime = '2024-01-07',
--    @EndTime = '2024-01-07',
--    @TotalDegree = 20,
--    @Corrective = 0,
--    @Normal = 1,
--    @Course_ID = 1

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
--test
EXEC GetExamDetails  'instructor', 'instructor',  @ExamID = 1

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
--test
EXEC UpdateExam 
 'instructor', 'instructor', 
    @ExamID = 1,
    @NumberOfQuestions = 25,
    @StartTime = '2024-01-08',
    @EndTime = '2024-01-08',
    @TotalDegree = 25,
    @Corrective = 0,
    @Normal = 1,
    @Course_ID = 2

EXEC GetExamDetails  'instructor', 'instructor',  @ExamID = 1
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
--test
EXEC DeleteExam 'instructor', 'instructor', @ExamID = 1
EXEC GetExamDetails  'instructor', 'instructor',  @ExamID = 1