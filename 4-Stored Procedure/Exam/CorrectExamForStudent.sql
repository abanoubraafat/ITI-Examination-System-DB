CREATE OR ALTER PROCEDURE CorrectExamForStudent 
    @std_id INT, 
    @exam_id INT
AS
BEGIN
    -- Data validation: Check if @std_id and @exam_id are greater than zero
   	IF @std_id <= 0 OR @exam_id <= 0
    BEGIN
        SELECT 'Invalid input. Student ID and Exam ID must be greater than zero.' AS ResultMessage
        RETURN
    END

    -- Data validation: Check if @std_id exists in the Student table
    IF NOT EXISTS (SELECT 1 FROM Student WHERE ID = @std_id)
    BEGIN
        SELECT 'Student ID does not exist in the database.' AS ResultMessage
        RETURN
    END

    -- Data validation: Check if @exam_id exists in the Exam table
    ELSE IF NOT EXISTS (SELECT 1 FROM Exam WHERE ID = @exam_id)
    BEGIN
        SELECT 'Exam ID does not exist in the database.' AS ResultMessage
        RETURN
    END
    ELSE
    BEGIN
        -- Create a temporary table to hold student exam results
        CREATE TABLE #tmpExamResults(
            [Std_ID] [int] NOT NULL,
            [Exam_ID] [int] NOT NULL,
            [Questions_result] [int] NULL,
            [Std_Answer_Text_Question] [nvarchar](max) NULL,
            [Std_Answer_Choose_Question] [nvarchar](1) NULL,
            [Std_Answer_True_or_False] [bit] NULL,
            [Questions_Id] [int] NOT NULL
        )

        -- Insert student exam results into the temporary table
        INSERT INTO #tmpExamResults 
        SELECT * FROM StudentExamQuestions WHERE Std_ID = @std_id AND Exam_ID = @exam_id

        -- Loop over each row in the temporary table
        DECLARE @questionId INT
        DECLARE @textAnswer NVARCHAR(MAX)
        DECLARE @chooseAnswer NVARCHAR(1)
        DECLARE @trueFalseAnswer BIT
        DECLARE @correctTextAnswer NVARCHAR(MAX)
        DECLARE @correctChooseAnswer NVARCHAR(1)
        DECLARE @correctTrueFalseAnswer BIT
        DECLARE @questionsResult INT = 0

        DECLARE examCursor CURSOR FOR 
        SELECT tr.Questions_Id, tr.Std_Answer_Text_Question, tr.Std_Answer_Choose_Question, 
            tr.Std_Answer_True_or_False, q.Correct_Answer_Text_Questions, 
            q.Correct_Answer_Choose_Question, q.Correct_Answer_True_or_False, tr.Questions_result
        FROM #tmpExamResults tr
        INNER JOIN Question q ON tr.Questions_Id = q.Questions_ID

        OPEN examCursor
        FETCH NEXT FROM examCursor INTO @questionId, @textAnswer, @chooseAnswer, @trueFalseAnswer,
            @correctTextAnswer, @correctChooseAnswer, @correctTrueFalseAnswer, @questionsResult

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Fetch question grade from ExamQuestion table
            DECLARE @questionGrade INT
            SELECT @questionGrade = QuestionGrade
            FROM ExamQuestion
            WHERE Exam_ID = @exam_id AND Question_ID = @questionId

            -- Your logic for calculating the score goes here
            -- Example: Accumulate scores for each question and add the question grade
            IF @textAnswer IS NOT NULL AND (@textAnswer LIKE '%' + @correctTextAnswer + '%' OR @textAnswer LIKE '%[^a-zA-Z]'+ @correctTextAnswer + '[^a-zA-Z]%')
                SET @questionsResult = @questionsResult + @questionGrade
            ELSE IF @chooseAnswer IS NOT NULL AND @chooseAnswer = @correctChooseAnswer
                SET @questionsResult = @questionsResult +  @questionGrade
            ELSE IF @trueFalseAnswer IS NOT NULL AND @trueFalseAnswer = @correctTrueFalseAnswer
                SET @questionsResult = @questionsResult + @questionGrade
            ELSE
                SET @questionsResult = 0 -- Set the question grade if none of the conditions match

            -- Update the question result
            UPDATE StudentExamQuestions SET Questions_result = @questionsResult 
            WHERE Std_ID = @std_id AND Exam_ID = @exam_id AND Questions_Id = @questionId

            FETCH NEXT FROM examCursor INTO @questionId, @textAnswer, @chooseAnswer, @trueFalseAnswer,
                @correctTextAnswer, @correctChooseAnswer, @correctTrueFalseAnswer, @questionsResult
        END

        CLOSE examCursor
        DEALLOCATE examCursor
        -- Drop the temporary table
        DROP TABLE #tmpExamResults
	END
END

--0
--10
--10
--0