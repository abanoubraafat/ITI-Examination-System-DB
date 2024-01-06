--for only one exam
CREATE PROCEDURE CalculateStudentExamGradeAndStatus_proc
    @StudentID INT,
    @ExamID INT
AS
BEGIN
    DECLARE @TotalQuestions INT
    DECLARE @TotalMarks INT
    DECLARE @StudentMarks INT
    DECLARE @MinDegree INT

    -- Get the total marks for the exam and minimum degree required
    SELECT @TotalMarks = E.TotalDegree,
           @MinDegree = C.MinDegree
    FROM Exam E
    INNER JOIN Course C ON E.Course_ID = C.ID
    WHERE E.ID = @ExamID;

    -- Get the total number of questions in the exam
    SELECT @TotalQuestions = COUNT(*)
    FROM QuestionExam QE
    WHERE QE.Exam_ID = @ExamID;

    -- Calculate the marks obtained by the student
    SELECT @StudentMarks = COUNT(*) 
    FROM StudentExam SE
    INNER JOIN QuestionExam QE ON SE.Exam_ID = QE.Exam_ID
	INNER JOIN Question Q ON QE.Question_ID=Q.ID
    WHERE SE.Std_ID = @StudentID
    AND SE.Exam_ID = @ExamID
	AND SE.Answer= Q.CorrectAnswer
    --AND SE.Answer = QE.CorrectAnswer; 

    -- Calculate the grade or percentage
    DECLARE @Grade DECIMAL(5, 2)
    SET @Grade = @StudentMarks;

    ---- Update the StudentExam table with the grade
    UPDATE StudentExam
    SET Grade = @Grade
    WHERE Std_ID = @StudentID
    AND Exam_ID = @ExamID;

    -- Check if the grade meets the minimum degree required
    --DECLARE @StudentStatus NVARCHAR(50)
    IF @Grade >= @MinDegree
    BEGIN
        --SET @StudentStatus = 'success'
        PRINT 'Congratulations! You have passed the exam' 
    END
    ELSE
    BEGIN
        --SET @StudentStatus = 'fail'
        PRINT 'Sorry! You have failed the exam' 
    END

    -- Update the student's status in the Student table
    --UPDATE Student
    --SET StudentStatus = @StudentStatus
    --WHERE ID = @StudentID;
END;

EXEC CalculateStudentExamGradeAndStatus_proc 1,1
EXEC CalculateStudentExamGradeAndStatus_proc 2,2
-----------------------------------------

-----------------------------test---------------------------------------------- 
CREATE PROCEDURE CalculateStudentGradeForExam
    @ExamID INT,
    @StudentID INT
AS
BEGIN
    DECLARE @TotalGrade INT = 0
    DECLARE @MinDegree INT

    -- Get the minimum degree for the course related to the exam
    SELECT @MinDegree = MinDegree
    FROM Course
    WHERE ID = (SELECT Course_ID FROM Exam WHERE ID = @ExamID)

    -- Calculate the student's grade for the exam
    DECLARE @CorrectAnswers INT = 0

    -- Fetch student's answers for the specified exam
    SELECT Q.ID AS QuestionID, Q.CorrectAnswer AS CorrectAnswer, SE.Answer AS StudentAnswer
    INTO #StudentAnswers
    FROM Question Q
    LEFT JOIN StudentExam SE ON Q.ID = SE.Question_ID AND SE.Exam_ID = @ExamID AND SE.Std_ID = @StudentID

    -- Calculate grade for each question
    DECLARE @QuestionID INT, @CorrectAnswer NVARCHAR(300), @StudentAnswer NVARCHAR(30)
    DECLARE answerCursor CURSOR FOR
    SELECT QuestionID, CorrectAnswer, StudentAnswer
    FROM #StudentAnswers

    OPEN answerCursor
    FETCH NEXT FROM answerCursor INTO @QuestionID, @CorrectAnswer, @StudentAnswer

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @CorrectAnswer = @StudentAnswer
            SET @CorrectAnswers = @CorrectAnswers + 1
        
        FETCH NEXT FROM answerCursor INTO @QuestionID, @CorrectAnswer, @StudentAnswer
    END

    CLOSE answerCursor
    DEALLOCATE answerCursor

    -- Calculate the student's total grade
    SET @TotalGrade = @CorrectAnswers * 100 / (SELECT COUNT(*) FROM #StudentAnswers)

    -- Update the student's grade in the StudentExam table
    UPDATE StudentExam
    SET Grade = @TotalGrade
    WHERE Exam_ID = @ExamID AND Std_ID = @StudentID

    -- Determine pass or fail status
    IF @TotalGrade >= @MinDegree
        PRINT 'Success'
    ELSE
        PRINT 'Fail'

    -- Drop temporary table
    DROP TABLE IF EXISTS #StudentAnswers
END
--------
CREATE OR ALTER PROCEDURE CalculateStudentExamGradeAndStatusTest_proc
    @StudentID INT,
    @ExamID INT
AS
BEGIN
    -- Create a temporary table to hold student's answers and grades for each question in the exam
    CREATE TABLE #TempStudentExam (
        QuestionID INT,
        StudentAnswer NVARCHAR(300),
        QuestionGrade INT
    )

    -- Insert student's answers for the exam into the temporary table
    INSERT INTO #TempStudentExam (QuestionID, StudentAnswer)
    SELECT QE.Question_ID, SE.Answer
    FROM StudentExam SE
    INNER JOIN QuestionExam QE ON SE.Exam_ID = QE.Exam_ID
    WHERE SE.Std_ID = @StudentID AND SE.Exam_ID = @ExamID;

    -- Calculate and assign grades based on correctness for each question
    UPDATE TSE
    SET QuestionGrade = 
        CASE 
            WHEN Q.[Type] = 'Multiple Choice' AND TSE.StudentAnswer = Q.CorrectAnswer THEN 10
            WHEN Q.[Type] = 'True/False' AND TSE.StudentAnswer = CASE WHEN Q.[True] = 1 THEN 'True' ELSE 'False' END THEN 10
            WHEN Q.[Type] = 'Text' AND CHARINDEX(Q.CorrectAnswer, TSE.StudentAnswer) > 0 THEN 20
            ELSE 0
        END
    FROM #TempStudentExam TSE
    INNER JOIN QuestionExam QE ON TSE.QuestionID = QE.Question_ID AND TSE.Exam_ID = QE.Exam_ID
    INNER JOIN Question Q ON QE.Question_ID = Q.ID;

    -- Update the StudentExam table with the grades for each question
    UPDATE SE
    SET Grade = TSE.QuestionGrade
    FROM StudentExam SE
    INNER JOIN #TempStudentExam TSE ON SE.Exam_ID = @ExamID AND SE.Std_ID = @StudentID
    WHERE SE.Exam_ID = TSE.QuestionID;

    -- Drop the temporary table
    DROP TABLE #TempStudentExam
END;



---------------------------
CREATE OR ALTER PROCEDURE CorrectExamForStudent
    @std_id INT,
    @exam_id INT
AS
BEGIN
    -- Create a temp table to hold the student exam results
    CREATE TABLE #tmpExamResults(
        [Std_ID] [int] NOT NULL,
        [Exam_ID] [int] NOT NULL,
        [Questions_result] [int] NULL,
        --[Std_Answer_Text_Question] [nvarchar](max) NOT NULL,
        [Std_Answer_Choose_Question] [nvarchar](1) NOT NULL,
        [Std_Answer_True_or_False] [bit] NOT NULL,
        [Questions_Id] [int] NOT NULL
    )

    -- Insert student exam results into temp table
    INSERT INTO #tmpExamResults 
    SELECT * FROM StudentExam WHERE Std_ID = @std_id AND Exam_ID = @exam_id

    -- Loop over each row in the temp table
    DECLARE @questionId INT
    DECLARE @textAnswer NVARCHAR(MAX)
    DECLARE @chooseAnswer NVARCHAR(1)
    DECLARE @trueFalseAnswer BIT
    DECLARE @correctTextAnswer NVARCHAR(MAX)
    DECLARE @correctChooseAnswer NVARCHAR(1)
    DECLARE @correctTrueFalseAnswer BIT
    DECLARE @questionsResult INT

    DECLARE examCursor CURSOR FOR 
    SELECT tr.Questions_Id, tr.Answer, q.CorrectAnswer, q.True, q.False, q.ID
    FROM #tmpExamResults tr
    INNER JOIN QuestionExam qe ON tr.Questions_Id = qe.Question_ID
    INNER JOIN Question q ON qe.Question_ID = q.ID

    OPEN examCursor
    FETCH NEXT FROM examCursor INTO @questionId, @textAnswer, @correctTextAnswer, @correctChooseAnswer, @correctTrueFalseAnswer, @questionsResult

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Check if the student's answer matches the model answer for each question
		DECLARE @student_mark INT = 0;
		
		--IF (@textAnswer LIKE '%' + @correctTextAnswer + '%' 
		--OR @textAnswer LIKE '%[^a-zA-Z]'+ @correctTextAnswer + '[^a-zA-Z]%') -- Use Regex
		--	SET @student_mark = @student_mark + 10
		
		IF (@chooseAnswer = @correctChooseAnswer)
			SET @student_mark = @student_mark + 10

		IF (@trueFalseAnswer = @correctTrueFalseAnswer)
			SET @student_mark = @student_mark + 10

        -- Update the question result by increasing it by student's mark
        SET @questionsResult = @student_mark
        UPDATE StudentExam SET Grade = @questionsResult 
        WHERE Std_ID = @std_id AND Exam_ID = @exam_id AND Question_ID = @questionId

        FETCH NEXT FROM examCursor INTO @questionId, @textAnswer, @chooseAnswer, @trueFalseAnswer,
            @correctTextAnswer, @correctChooseAnswer, @correctTrueFalseAnswer, @questionsResult
    END

    CLOSE examCursor
    DEALLOCATE examCursor

    -- Drop the temp table
    DROP TABLE #tmpExamResults

	  -- Calculate total marks for the exam and update student status if required
    DECLARE @TotalMarks INT
    SELECT @TotalMarks = SUM(Grade)
    FROM StudentExam
    WHERE Std_ID = @StudentID AND Exam_ID = @ExamID;

	-- Get the minimum degree required for the exam
    DECLARE @MinDegree INT
    SELECT @MinDegree = MinDegree
    FROM Course C
    INNER JOIN Exam E ON C.ID = E.Course_ID
    WHERE E.ID = @ExamID;

    -- Update student status based on total marks
    IF @TotalMarks >= @MinDegree
        PRINT 'Congratulations! You have passed the exam';
    ELSE
        PRINT 'Sorry! You have failed the exam';
END;

-------------------------------------------------
CREATE OR ALTER PROCEDURE CorrectExamForStudent
    @std_id INT,
    @exam_id INT
AS
BEGIN
    -- Create a temp table to hold the student exam results
    CREATE TABLE #tmpExamResults(
        [Std_ID] [int] NOT NULL,
        [Exam_ID] [int] NOT NULL,
        [Question_ID] [int] NOT NULL,
        [Grade] [int] NULL
    )

    -- Insert student exam results into temp table
    INSERT INTO #tmpExamResults 
    SELECT SE.Std_ID, SE.Exam_ID, QE.Question_ID, 0
    FROM StudentExam SE
    INNER JOIN QuestionExam QE ON SE.Exam_ID = QE.Exam_ID
    WHERE SE.Std_ID = @std_id AND SE.Exam_ID = @exam_id;

    -- Loop over each row in the temp table
    DECLARE @questionId INT
    DECLARE @correctAnswer NVARCHAR(300)
    DECLARE @studentAnswer NVARCHAR(300)
    DECLARE @questionGrade INT

    DECLARE examCursor CURSOR FOR 
    SELECT tr.Question_ID, q.CorrectAnswer
    FROM #tmpExamResults tr
    INNER JOIN QuestionExam qe ON tr.Question_ID = qe.Question_ID
    INNER JOIN Question q ON qe.Question_ID = q.ID

    OPEN examCursor
    FETCH NEXT FROM examCursor INTO @questionId, @correctAnswer

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get student's answer for the question
        SELECT @studentAnswer = Answer
        FROM StudentExam
        WHERE Std_ID = @std_id AND Exam_ID = @exam_id AND Question_ID = @questionId;

        -- Check if the student's answer matches the model answer for each question
        IF @studentAnswer = @correctAnswer
            SET @questionGrade = 10
        ELSE
            SET @questionGrade = 0
        -- Update the question result by setting it to the student's mark
        UPDATE #tmpExamResults 
        SET Grade = @questionGrade 
        WHERE Std_ID = @std_id AND Exam_ID = @exam_id AND Question_ID = @questionId;

        FETCH NEXT FROM examCursor INTO @questionId, @correctAnswer
    END

    CLOSE examCursor
    DEALLOCATE examCursor

    -- Calculate total marks for the exam
    DECLARE @TotalMarks INT
    SELECT @TotalMarks = SUM(Grade)
    FROM #tmpExamResults
    WHERE Std_ID = @std_id AND Exam_ID = @exam_id;

    -- Get the minimum degree required for the exam
    DECLARE @MinDegree INT
    SELECT @MinDegree = MinDegree
    FROM Course C
    INNER JOIN Exam E ON C.ID = E.Course_ID
    WHERE E.ID = @exam_id;

    -- Update student status based on total marks
    IF @TotalMarks >= @MinDegree
        PRINT 'Congratulations! You have passed the exam';
    ELSE
        PRINT 'Sorry! You have failed the exam';

    -- Drop the temp table
    DROP TABLE #tmpExamResults
END;


