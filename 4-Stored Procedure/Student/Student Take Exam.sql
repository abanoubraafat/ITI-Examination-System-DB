--Show Student Course Exams
create or alter proc ShowStudentCourseExams_Proc
		@Student_ID int,
		@Course_ID int
as
begin
	IF @Student_ID <= 0 or @Course_ID <= 0 or @Student_ID is null or @Course_ID is null
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
GO

----------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE TakeAndShowExamOnSpecificTime
    @std_id INT,
    @exam_id INT
AS
BEGIN
	 -- Check if the student and exam exist
	IF NOT EXISTS (SELECT 1 FROM Student WHERE ID = @std_id)
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
GO


---------------------------- Student Answer Exam -----------------------
create or alter proc StudentAnswerExam_Proc
			@Student_ID int,
			@Exam_ID int,
			@Question_ID int,
			@Student_Question_Answer nvarchar(max)
as
begin

	 -- Check if the student and exam exist
	  IF NOT EXISTS (SELECT 1 FROM Student WHERE ID = @Student_ID)
    BEGIN
        SELECT 'Student ID does not exist.' AS ResultMessage
        RETURN
    END

    IF NOT EXISTS (SELECT 1 FROM Exam WHERE ID = @exam_id)
    BEGIN
        SELECT 'Exam ID does not exist.' AS ResultMessage
        RETURN
    END
		else if not exists(select * from Question where Questions_ID = @Question_ID)
	begin
		SELECT 'Question does not exist.' AS ResultMessage
		RETURN
	end
	else if not exists (select 1 from ExamQuestion eq where eq.Exam_ID = @Exam_ID and eq.Question_ID = Question_ID )
	begin
		SELECT 'Question does not exist.' AS ResultMessage
		RETURN
	end
	IF NOT EXISTS (SELECT 1 FROM [dbo].[StudentExam] WHERE [Student_ID] = @Student_ID AND [Exam_ID]=@Exam_ID )
    BEGIN
        SELECT 'You can not access in this exam' AS ResultMessage
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
	 IF EXISTS (SELECT 1 FROM StudentExamQuestions WHERE Std_ID = @Student_ID AND Exam_ID = @Exam_ID and Questions_Id = @Question_ID)
    BEGIN
        SELECT 'You have already answered this question' AS ResultMessage
        RETURN
    END
	declare @Question_Type nvarchar(max)
	select @Question_Type = QuestionType from ExamQuestion where Exam_ID = @Exam_ID and Question_ID = @Question_ID
	
	if @Question_Type = 'Text'
	begin
		insert into StudentExamQuestions
		values(@Student_ID, @Exam_ID, 0, @Student_Question_Answer, '','',@Question_ID)
		SELECT 'Answer Submitted!' AS ResultMessage
		RETURN
	end
	else if @Question_Type = 'TF'
	begin
		if @Student_Question_Answer != '0' and @Student_Question_Answer != '1'
		begin
			 SELECT 'Invalid Data in Answer Field' AS ResultMessage
			 RETURN
		end
		else
		begin
			insert into StudentExamQuestions
			values(@Student_ID, @Exam_ID, 0, '', '',@Student_Question_Answer,@Question_ID)
			SELECT 'Answer Submitted!' AS ResultMessage
			RETURN
		end
	end
	else
	begin
	if LEN(@Student_Question_Answer) > 1
		begin
			 SELECT 'Invalid Data in Answer Field' AS ResultMessage
			 RETURN
		end
	else
	begin
		insert into StudentExamQuestions
		values(@Student_ID, @Exam_ID, 0, '', @Student_Question_Answer,'',@Question_ID)
		SELECT 'Answer Submitted!' AS ResultMessage
		RETURN
	end
	end
end
GO









