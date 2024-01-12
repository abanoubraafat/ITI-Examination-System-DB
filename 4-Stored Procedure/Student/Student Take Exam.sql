--Show Student Course Exams
create or alter proc ShowStudentCourseExams_Proc
		@Username varchar(10),
		@Password varchar(10),	
		@Student_ID int,
		@Course_ID int
as
begin
	IF not(@Username = 'student' and @Password = 'student')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
	 ELSE IF @Student_ID <= 0 or @Course_ID <= 0 or @Student_ID is null or @Course_ID is null
		BEGIN
			SELECT 'Invalid input.' AS ResultMessage
			RETURN
		END
	else if not exists(select * from Student where ID = @Student_ID)
		begin
			SELECT 'Student does not exist.' AS ResultMessage
			RETURN
		end
		else if not exists(select * from Course where ID = @Course_ID)
		begin
			SELECT 'Course does not exist.' AS ResultMessage
			RETURN
		end
		else if not exists
		(select 1 from Student s inner join StudentCourse sc
		on s.ID = sc.Std_ID 
		inner join Course c
		on c.ID = sc.Course_ID
		where sc.Course_ID = @Course_ID and sc.Std_ID = @Student_ID
		)
		begin
			SELECT 'Course not found' AS ResultMessage
			RETURN
		end
		select e.ID 'Exam No', e.NumberOfQuestions 'Number of Questions' , e.StartTime 'Start Time', e.EndTime 'End Time'
		from CourseExam ce 
		inner join Exam e
		on ce.Exam_ID = e.ID 
		where ce.Course_ID = @Course_ID 
end
exec ShowStudentCourseExams_Proc 'student','student', 2,2
----------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE TakeAndShowExamOnSpecificTime
	@Username varchar(10),
	@Password varchar(10),
    @std_id INT,
    @exam_id INT
AS
BEGIN
    IF not(@Username = 'student' and @Password = 'student')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
	 -- Check if the student and exam exist
	 ELSE IF NOT EXISTS (SELECT 1 FROM Student WHERE ID = @std_id)
    BEGIN
        SELECT 'Student ID does not exist.' AS ResultMessage
        RETURN
    END

    IF NOT EXISTS (SELECT 1 FROM Exam WHERE ID = @exam_id)
    BEGIN
        SELECT 'Exam ID does not exist.' AS ResultMessage
        RETURN
    END
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[StudentExam] WHERE [Student_ID] = @std_id AND [Exam_ID]=@exam_id )
    BEGIN
        SELECT 'You are not access in this exam' AS ResultMessage
        RETURN
    END
    -- Check if the exam is currently available
    DECLARE @currentDateTime DATETIME = GETDATE()
    DECLARE @examStartTime DATETIME
    DECLARE @examEndTime DATETIME

    SELECT @examStartTime = StartTime, @examEndTime = EndTime
    FROM Exam
    WHERE ID = @exam_id

    IF @currentDateTime < @examStartTime
    BEGIN
        SELECT 'The exam has not started yet. Please wait for the scheduled start time.' AS ResultMessage
        RETURN
    END

    IF @currentDateTime > @examEndTime
    BEGIN
        SELECT 'The exam has already ended. You cannot take the exam now.' AS ResultMessage
        RETURN
    END

    -- Check if the student has already taken the exam
    IF EXISTS (SELECT 1 FROM StudentExamQuestions WHERE Std_ID = @std_id AND Exam_ID = @exam_id)
    BEGIN
        SELECT 'You have already taken this exam.' AS ResultMessage
        RETURN
    END

    -- Insert logic for allowing the student to take the exam
    -- For example, insert the questions for the exam into the StudentExamQuestions table

    -- Inserting a record for each question in the exam
    --INSERT INTO StudentExamQuestions (Std_ID, Exam_ID, Questions_Id, Std_Answer_Text_Question, Std_Answer_Choose_Question, Std_Answer_True_or_False)
    --SELECT @std_id, @exam_id, Questions_ID, NULL, NULL, NULL
    --FROM ExamQuestion
    --WHERE Exam_ID = @exam_id

		--	INSERT INTO StudentExamQuestions (Std_ID, Exam_ID, Questions_Id, Std_Answer_Text_Question, Std_Answer_Choose_Question, Std_Answer_True_or_False)
		--SELECT @std_id, @exam_id, eq.Question_ID, NULL, NULL, NULL
		--FROM ExamQuestion eq
		--WHERE eq.Exam_ID = @exam_id;
    SELECT 'You can now take the exam.' AS ResultMessage
 CREATE TABLE #tmpExamQuestions(
            Question_ID int not null,
			QuestionType char(4) not null,
			QuestionGrade int,
			QuestionBody nvarchar(max),
			
        )
		declare @Question_Type char(4)
        DECLARE @Question_ID INT
        DECLARE @QuestionGrade INT
        DECLARE @QuestionText NVARCHAR(MAX)
        DECLARE @QuestionChoose NVARCHAR(max)
        DECLARE @QuestionTF NVARCHAR(max)
       

   DECLARE examCursor CURSOR FOR 
	SELECT
		eq.Question_ID AS 'Question No',
		eq.QuestionType AS 'Question Type',
		eq.QuestionGrade AS 'Question Grade',
		q.Choose_An_Answer_Question AS 'Choose_An_Answer_Question',
		
		q.Text_Questions AS 'Text_Questions',
		
		q.True_or_False_Questions AS 'True_or_False_Questions'
		
	FROM ExamQuestion eq
	INNER JOIN Question q ON eq.Question_ID = q.Questions_ID
	WHERE eq.Exam_ID = @Exam_ID;


        OPEN examCursor
        FETCH NEXT FROM examCursor INTO @Question_ID, @Question_Type, @QuestionGrade, @QuestionChoose,
            @QuestionText, @QuestionTF

        WHILE @@FETCH_STATUS = 0
        BEGIN
			IF @Question_Type = 'Text'
			begin
				INSERT INTO #tmpExamQuestions (Question_ID, QuestionType, QuestionGrade, QuestionBody)
				VALUES (@Question_ID, @Question_Type, @QuestionGrade, @QuestionText);
			end
			else if @Question_Type = 'TF'
			begin
			insert into #tmpExamQuestions(Question_ID, QuestionType, QuestionGrade, QuestionBody)
			values(@Question_ID, @Question_Type, @QuestionGrade, @QuestionTF)
			end
			else
			begin
				insert into #tmpExamQuestions(Question_ID, QuestionType, QuestionGrade, QuestionBody)
				values(@Question_ID, @Question_Type, @QuestionGrade,@QuestionChoose)
			end

           FETCH NEXT FROM examCursor INTO @Question_ID, @Question_Type, @QuestionGrade, @QuestionChoose,
             @QuestionText, @QuestionTF
	     END

        CLOSE examCursor
        DEALLOCATE examCursor
		select Question_ID 'Question No',
			QuestionType 'Question Type',
			CASE WHEN QuestionGrade is null THEN 0 ELSE QuestionGrade END as 'Question Grade',
			QuestionBody 'Question Body'
			from #tmpExamQuestions


END
EXEC TakeAndShowExamOnSpecificTime 'student','student', @std_id = 1, @exam_id = 6;




--Show Student Specific Exam
--create or alter proc ShowStudentExamQuestions_Proc
--		@Student_ID int,
--		@Exam_ID int
--as
--begin
--IF @Student_ID <= 0 or @Exam_ID <= 0 or @Student_ID is null or @Exam_ID is null
--		BEGIN
--			SELECT 'Invalid input.' AS ResultMessage
--			RETURN
--		END
--	else if not exists(select 1 from Exam where ID = @Exam_ID)
--		begin
--			SELECT 'Exam does not exist.' AS ResultMessage
--			RETURN
--		end
--		else if not exists(select 1 from Student where ID = @Student_ID)
--		begin
--			SELECT 'Student does not exist.' AS ResultMessage
--			RETURN
--		end
--		else if not exists
--		(select 1 from StudentCourse sc inner join CourseExam ce
--		on sc.Course_ID = ce.Course_ID
--		where sc.Std_ID = @Student_ID and ce.Exam_ID = @Exam_ID
--		)
--		begin
--			SELECT 'Exam not found' AS ResultMessage
--			RETURN
--		end
--		else if 
--		( 
--		GETDATE() not between (select StartTime from Exam where ID = @Exam_ID) and (select EndTime from Exam where ID = @Exam_ID)
--		)
--		begin
--			SELECT 'Exam either not started or finished, you can not access this exam!' AS ResultMessage
--			RETURN
--		end
--		 CREATE TABLE #tmpExamQuestions(
--            Question_ID int not null,
--			QuestionType char(4) not null,
--			QuestionGrade int,
--			QuestionBody nvarchar(max),
--			CorrectAnswer nvarchar(max)
--        )
--		declare @Question_Type char(4)
--        DECLARE @Question_ID INT
--        DECLARE @QuestionGrade INT
--        DECLARE @QuestionText NVARCHAR(MAX)
--        DECLARE @QuestionChoose NVARCHAR(max)
--        DECLARE @QuestionTF NVARCHAR(max)
--        DECLARE @correctTextAnswer NVARCHAR(MAX)
--        DECLARE @correctChooseAnswer NVARCHAR(max)
--        DECLARE @correctTrueFalseAnswer BIT

--   DECLARE examCursor CURSOR FOR 
--	SELECT
--		eq.Question_ID AS 'Question No',
--		eq.QuestionType AS 'Question Type',
--		eq.QuestionGrade AS 'Question Grade',
--		q.Choose_An_Answer_Question AS 'Choose_An_Answer_Question',
--		q.Correct_Answer_Choose_Question AS 'Correct_Answer_Choose_Question',
--		q.Text_Questions AS 'Text_Questions',
--		q.Correct_Answer_Text_Questions AS 'Correct_Answer_Text_Questions',
--		q.True_or_False_Questions AS 'True_or_False_Questions',
--		q.Correct_Answer_True_or_False AS 'Correct_Answer_True_or_False'
--	FROM ExamQuestion eq
--	INNER JOIN Question q ON eq.Question_ID = q.Questions_ID
--	WHERE eq.Exam_ID = @Exam_ID;


--        OPEN examCursor
--        FETCH NEXT FROM examCursor INTO @Question_ID, @Question_Type, @QuestionGrade, @QuestionChoose,
--            @correctChooseAnswer, @QuestionText, @correctTextAnswer, @QuestionTF, @correctTrueFalseAnswer

--        WHILE @@FETCH_STATUS = 0
--        BEGIN
--			IF @Question_Type = 'Text'
--			begin
--				INSERT INTO #tmpExamQuestions (Question_ID, QuestionType, QuestionGrade, QuestionBody, CorrectAnswer)
--				VALUES (@Question_ID, @Question_Type, @QuestionGrade, @QuestionText, @correctTextAnswer);
--			end
--			else if @Question_Type = 'TF'
--			begin
--			insert into #tmpExamQuestions(Question_ID, QuestionType, QuestionGrade, QuestionBody, CorrectAnswer)
--			values(@Question_ID, @Question_Type, @QuestionGrade, @QuestionTF, CASE WHEN @correctTrueFalseAnswer = 1 THEN 'True' ELSE 'False' END)
--			end
--			else
--			begin
--				insert into #tmpExamQuestions(Question_ID, QuestionType, QuestionGrade, QuestionBody, CorrectAnswer)
--				values(@Question_ID, @Question_Type, @QuestionGrade,@QuestionChoose, @correctChooseAnswer)
--			end

--           FETCH NEXT FROM examCursor INTO @Question_ID, @Question_Type, @QuestionGrade, @QuestionChoose,
--            @correctChooseAnswer, @QuestionText, @correctTextAnswer, @QuestionTF, @correctTrueFalseAnswer
--	     END

--        CLOSE examCursor
--        DEALLOCATE examCursor
--		select Question_ID 'Question No',
--			QuestionType 'Question Type',
--			CASE WHEN QuestionGrade is null THEN 0 ELSE QuestionGrade END as 'Question Grade',
--			QuestionBody 'Question Body',
--			CorrectAnswer 'Correct Answer' from #tmpExamQuestions
--end

--exec ShowStudentExamQuestions_Proc 2, 37



