--Instructor creates an exam with random questions auto selected from the question pool (related to his course)
--1-Generating the exam and inserting the questions to it.
create or alter proc GenerateRandomQuestionsCourseExam_Proc 
	@Instructor_ID int,
	@Course_ID int,
	@MCQ_No int,
	@TF_No int,
	@TextQ_No int,
    @StartTime DATETIME,      
    @EndTime DATETIME,
    @TotalDegree int,
    @Corrective BIT,
    @Normal BIT
as
begin
	IF @Instructor_ID <= 0 or @Course_ID <= 0 or @MCQ_No <= 0 or @TF_No <= 0 or @TextQ_No <= 0 or @TotalDegree < 0 or @Instructor_ID is null or @Course_ID is null or @MCQ_No is null or @TF_No is null or @TextQ_No is null or @TotalDegree is null or @Normal is null or @Corrective is null
		BEGIN
			SELECT 'Invalid input.' AS ResultMessage
			RETURN
		END
	ELSE IF @StartTime < GETDATE() or @EndTime < GETDATE()
		BEGIN
			SELECT 'Date is not incorrect.' AS ResultMessage
			RETURN
    END
	ELSE IF  @EndTime < @StartTime 
		BEGIN
			SELECT 'Date is not incorrect.' AS ResultMessage
			RETURN
    END
	ELSE IF @Corrective = 1 and @Normal = 1
		BEGIN
			SELECT 'Exam must be corrective or normal not both.' AS ResultMessage
			RETURN
    END
	else if not exists(select * from Course where ID = @Course_ID)
		begin
			SELECT 'Course does not exist.' AS ResultMessage
			RETURN
		end
		else if not exists(select * from Instructor where ID = @Instructor_ID)
		begin
			SELECT 'Instructor does not exist.' AS ResultMessage
			RETURN
		end
	else if (select distinct i.ID
			from Instructor i inner join InstructorCourse ic
			on i.ID = ic.Instructor_ID
			inner join Course c
			on ic.Course_ID = c.ID
			where c.ID = @Course_ID)
			!= @Instructor_ID
		--checking if this course is teached by that instructor (if exists)
		begin
			SELECT 'course id or instructor id or both are wrong' AS ResultMessage
			Return;
		end
		else if (select count(*) from Question where Course_Id = @Course_ID) < (@MCQ_No + @TF_No + @TextQ_No)
		begin
			SELECT 'Not Enough Questions in question pool.' AS ResultMessage
			RETURN
		end
			declare @NewExam_ID int 
			SELECT TOP 1 @NewExam_ID = ID + 1 FROM Exam ORDER BY ID DESC --get the last exam id and increments it by 1 as the new exam id
			--select @NewExam_ID
			 INSERT INTO Exam (ID,NumberOfQuestions, StartTime, EndTime, TotalDegree, Corrective, Normal)
				VALUES (@NewExam_ID ,@TextQ_No + @MCQ_No + @TF_No, @StartTime, @EndTime, @TotalDegree, @Corrective, @Normal)
				INSERT INTO CourseExam VALUES(@Course_ID, @NewExam_ID)
			--declare @Count int
			--set @Count = @TextQ_No
			while @TextQ_No > 0
			begin
				set @TextQ_No = @TextQ_No -1
				insert into ExamQuestion (Exam_ID, Question_ID, QuestionType)
				select top 1 @NewExam_ID, Questions_ID, 'Text' from Question t1
				where t1.Course_Id = @Course_ID and
					NOT EXISTS( SELECT 1
								FROM ExamQuestion t2
								WHERE t2.Exam_ID = @NewExam_ID
									  AND t2.Question_ID = t1.Questions_ID) --preventing duplicate exam_question insert
				ORDER BY NEWID();
			end
			while @MCQ_No > 0 
			begin
				set @MCQ_No = @MCQ_No -1
				insert into ExamQuestion (Exam_ID, Question_ID, QuestionType) 
				select top 1 @NewExam_ID, Questions_ID, 'MCQ' from Question t1
				where t1.Course_Id = @Course_ID and
					NOT EXISTS( SELECT 1
								FROM ExamQuestion t2
								WHERE t2.Exam_ID = @NewExam_ID
									  AND t2.Question_ID = t1.Questions_ID)
				ORDER BY NEWID()
			end
			while @TF_No > 0
			begin
				set @TF_No = @TF_No -1
				insert into ExamQuestion (Exam_ID, Question_ID, QuestionType)
				select top 1 @NewExam_ID, Questions_ID, 'TF' from Question t1
				where t1.Course_Id = @Course_ID and
					NOT EXISTS( SELECT 1
								FROM ExamQuestion t2
								WHERE t2.Exam_ID = @NewExam_ID
									  AND t2.Question_ID = t1.Questions_ID)
				ORDER BY NEWID()
			end
			insert into StudentExam(Exam_ID, Student_ID) 
			select ce.Exam_ID ,sc.Std_ID from StudentCourse sc
			inner join CourseExam ce
			on ce.Course_ID = sc.Course_ID
			where sc.Course_ID = @Course_ID and ce.Exam_ID = @NewExam_ID
			SELECT cast(@NewExam_ID as varchar(max)) + ' is the Exam number you can use to specify each Question Grade' AS ResultMessage 
end

GO

--2- Displaying the auto generated exam questions to assign a degree to each of them
create or alter proc ShowExamQuestions_Proc
		@Instructor_ID int,
		@Exam_ID int
as
begin
IF @Instructor_ID <= 0 or @Exam_ID <= 0 or @Instructor_ID is null or @Exam_ID is null
		BEGIN
			SELECT 'Invalid input.' AS ResultMessage
			RETURN
		END
	else if not exists(select * from Exam where ID = @Exam_ID)
		begin
			SELECT 'Exam does not exist.' AS ResultMessage
			RETURN
		end
		else if not exists(select * from Instructor where ID = @Instructor_ID)
		begin
			SELECT 'Instructor does not exist.' AS ResultMessage
			RETURN
		end
		else if not exists
		(select ce.Exam_ID from CourseExam ce inner join InstructorCourse ic
		on ce.Course_ID = ic.Course_ID
		where ce.Exam_ID = @Exam_ID and ic.Instructor_ID = @Instructor_ID) 
		begin
			SELECT 'Exam not found' AS ResultMessage
			RETURN
		end
		else if not exists 
		(select  1 FROM ExamQuestion eq
			INNER JOIN Question q ON eq.Question_ID = q.Questions_ID
			WHERE eq.Exam_ID = @Exam_ID
		)
		begin
			SELECT 'No Question were found for that Exam' AS ResultMessage
			RETURN
		end
		 CREATE TABLE #tmpExamQuestions(
            Question_ID int not null,
			QuestionType char(4) not null,
			QuestionGrade int,
			QuestionBody nvarchar(max),
			CorrectAnswer nvarchar(max)
        )
		declare @Question_Type char(4)
        DECLARE @Question_ID INT
        DECLARE @QuestionGrade INT
        DECLARE @QuestionText NVARCHAR(MAX)
        DECLARE @QuestionChoose NVARCHAR(max)
        DECLARE @QuestionTF NVARCHAR(max)
        DECLARE @correctTextAnswer NVARCHAR(MAX)
        DECLARE @correctChooseAnswer NVARCHAR(max)
        DECLARE @correctTrueFalseAnswer BIT

   DECLARE examCursor CURSOR FOR 
	SELECT
		eq.Question_ID AS 'Question No',
		eq.QuestionType AS 'Question Type',
		eq.QuestionGrade AS 'Question Grade',
		q.Choose_An_Answer_Question AS 'Choose_An_Answer_Question',
		q.Correct_Answer_Choose_Question AS 'Correct_Answer_Choose_Question',
		q.Text_Questions AS 'Text_Questions',
		q.Correct_Answer_Text_Questions AS 'Correct_Answer_Text_Questions',
		q.True_or_False_Questions AS 'True_or_False_Questions',
		q.Correct_Answer_True_or_False AS 'Correct_Answer_True_or_False'
	FROM ExamQuestion eq
	INNER JOIN Question q ON eq.Question_ID = q.Questions_ID
	WHERE eq.Exam_ID = @Exam_ID;


        OPEN examCursor
        FETCH NEXT FROM examCursor INTO @Question_ID, @Question_Type, @QuestionGrade, @QuestionChoose,
            @correctChooseAnswer, @QuestionText, @correctTextAnswer, @QuestionTF, @correctTrueFalseAnswer

        WHILE @@FETCH_STATUS = 0
        BEGIN
			IF @Question_Type = 'Text'
			begin
				INSERT INTO #tmpExamQuestions (Question_ID, QuestionType, QuestionGrade, QuestionBody, CorrectAnswer)
				VALUES (@Question_ID, @Question_Type, @QuestionGrade, @QuestionText, @correctTextAnswer);
			end
			else if @Question_Type = 'TF'
			begin
			insert into #tmpExamQuestions(Question_ID, QuestionType, QuestionGrade, QuestionBody, CorrectAnswer)
			values(@Question_ID, @Question_Type, @QuestionGrade, @QuestionTF, CASE WHEN @correctTrueFalseAnswer = 1 THEN 'True' ELSE 'False' END)
			end
			else
			begin
				insert into #tmpExamQuestions(Question_ID, QuestionType, QuestionGrade, QuestionBody, CorrectAnswer)
				values(@Question_ID, @Question_Type, @QuestionGrade,@QuestionChoose, @correctChooseAnswer)
			end

           FETCH NEXT FROM examCursor INTO @Question_ID, @Question_Type, @QuestionGrade, @QuestionChoose,
            @correctChooseAnswer, @QuestionText, @correctTextAnswer, @QuestionTF, @correctTrueFalseAnswer
	     END

        CLOSE examCursor
        DEALLOCATE examCursor
		select Question_ID 'Question No',
			QuestionType 'Question Type',
			CASE WHEN QuestionGrade is null THEN 0 ELSE QuestionGrade END as 'Question Grade',
			QuestionBody 'Question Body',
			CorrectAnswer 'Correct Answer' from #tmpExamQuestions
end

GO



--3-Assign grade for each question of the exam
create or alter proc AddGradeToQuestion_Proc
				@Instructor_ID int,
				@Exam_ID int,
				@Question_ID int,
				@Question_Grade int
as
begin
	IF @Instructor_ID <= 0 or @Exam_ID <= 0 or @Question_ID <= 0 or @Question_Grade <= 0 or @Instructor_ID is null or @Exam_ID is null or @Question_ID is null or @Question_Grade is null
		BEGIN
			SELECT 'Invalid input.' AS ResultMessage
			RETURN
		END
	else if not exists(select top 1 * from Exam where ID = @Exam_ID)
		begin
			SELECT 'Exam does not exist.' AS ResultMessage
			RETURN
		end
	else if not exists (select 1 from Instructor where ID = @Instructor_ID)
	begin
		SELECT 'Instructor does not exist.' AS ResultMessage
		RETURN
	end
	else if not exists (select 1 from Question where Questions_ID = @Question_ID)
	begin
		SELECT 'Question does not exist.' AS ResultMessage
		RETURN
	end
	else if not exists
		(select 1 from Question q inner join InstructorCourse ic
		on q.Course_Id = ic.Course_ID
		where q.Questions_ID = @Question_ID and ic.Instructor_ID = @Instructor_ID)
	begin
		SELECT 'Question in question pool does not belong to that course.' AS ResultMessage
		RETURN
	end
	else if exists (select 1 from ExamQuestion where Question_ID = @Question_ID and Exam_ID = @Exam_ID and QuestionGrade IS NOT NULL)
	begin
		SELECT 'Question in question pool already has a grade.' AS ResultMessage
		RETURN
	end
	else if not exists
		(select top 1 i.ID
		from Instructor i inner join InstructorCourse ic
		on i.ID = ic.Instructor_ID
		inner join Course c
		on ic.Course_ID = c.ID
		inner join CourseExam ce
		on ce.Course_ID = c.ID
		where ce.Exam_ID = @Exam_ID and i.ID = @Instructor_ID)
	begin
		SELECT 'Exam ID or Instructor ID or both are wrong.' AS ResultMessage
		RETURN
	end
	declare @Course_MaxDegree int
	declare @Exam_TotalDegree int
	select top 1 @Course_MaxDegree= c.MaxDegree from Course c
	inner join CourseExam ce
	on c.ID = ce.Course_ID
	select @Exam_TotalDegree = TotalDegree -- TotalDegree
	from Exam
	where ID = @Exam_ID
	if @Exam_TotalDegree = @Course_MaxDegree
	begin
		select 'Course Max Degree = Exam Total Degrees you cannot add more grades'
		RETURN
	end
	else if @Exam_TotalDegree + @Question_Grade > @Course_MaxDegree
		begin
			select 'Grade not added! Exam total degrees exceeded course max degrees please re-assign the grade'
			RETURN
		end

				update ExamQuestion 
				set QuestionGrade = @Question_Grade
				where Question_ID = @Question_ID and Exam_ID = @Exam_ID
				--setting total degrees in Exam table
				update Exam  
				set TotalDegree = TotalDegree + @Question_Grade
				where ID = @Exam_ID
				select 'Grade Added!' as ResultMessage
end
GO
