--Instructor Procedures--
-- Create Exam With random questions from each type, make Exam (For his coLurse only) by selecting number of questions of each type, the system selects the questions random

--Instructor creates an exam with random questions auto selected from the question pool (related to his course)
--1-Generating the exam and inserting the questions to it.
create or alter proc GenerateRandomQuestionsCourseExam_Proc 
	@Instructor_ID int,
	@Course_ID int,
	@MCQ_No int,
	@TF_No int,
	@TextQ_No int,
    @StartTime DATE,      
    @EndTime DATE,
    @TotalDegree int,
    @Corrective BIT,
    @Normal BIT
as
begin
	 IF @Instructor_ID <= 0 or @Course_ID <= 0 or @MCQ_No <= 0 or @TF_No <= 0 or @TextQ_No <= 0 or @TotalDegree < 0 
		BEGIN
			SELECT 'Invalid input.' AS ResultMessage
			RETURN
		END
	ELSE IF @StartTime < GETDATE() or @EndTime < GETDATE()
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
			SELECT cast(@NewExam_ID as varchar(max)) + ' is the Exam number you can use to specify each Question Grade' AS ResultMessage 
end
--test
 select * from ExamQuestion
 delete from ExamQuestion
exec GenerateRandomQuestionsCourseExam_Proc 
	2,
	2,
	2,
	2,
	2,
    '2024-1-11 14:30:00','2024-1-11 15:00:00',
   0,
   0,
   1
   select * from ExamQuestion
   select * from Exam where ID = 19
--2- Displaying the auto generated exam questions to assign a degree to each of them
create or alter proc ShowExamQuestions_Proc
		@Instructor_ID int,
		@Exam_ID int
as
begin
IF @Instructor_ID <= 0 or @Exam_ID <= 0
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
			QuestionGrade 'Question Grade',
			QuestionBody 'Question Body',
			CorrectAnswer 'Correct Answer' from #tmpExamQuestions
end
exec ShowExamQuestions_Proc 2,19
--3-Assign grade for each question of the exam
create or alter proc AddGradeToQuestion_Proc
				@Instructor_ID int,
				@Exam_ID int,
				@Question_ID int,
				@Question_Grade int
as
begin
	IF @Instructor_ID <= 0 or @Exam_ID <= 0 or @Question_ID <= 0 or @Question_Grade <= 0
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
		else if not exists(select * from Question where Questions_ID = @Question_ID)
		begin
			SELECT 'Question does not exist.' AS ResultMessage
			RETURN
		end
		else if not exists
		(select q.Questions_ID from Question q inner join InstructorCourse ic
		on q.Course_Id = ic.Course_ID
		where q.Questions_ID = @Question_ID and ic.Instructor_ID = @Instructor_ID) 
		--= @Question_ID
		begin
			SELECT 'Question in question pool does not belong to that course.' AS ResultMessage
			RETURN
		end
		else if (select QuestionGrade from ExamQuestion where Question_ID = @Question_ID) != 0
			or (select QuestionGrade from ExamQuestion where Question_ID = @Question_ID) != Null
		begin
			SELECT 'Question in question pool already have a grade' AS ResultMessage
			RETURN
		end
		else if (select distinct i.ID
				from Instructor i inner join InstructorCourse ic
				on i.ID = ic.Instructor_ID
				inner join Course c
				on ic.Course_ID = c.ID
				inner join CourseExam ce
				on ce.Course_ID = c.ID
				where ce.Exam_ID = @Exam_ID)
				!= @Instructor_ID
	--checking if the course(which the exam belongs to) is teached by that instructor (if exists)
		begin
			SELECT 'exam id or instructor id or both are wrong' AS ResultMessage
			Return
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
select * from ExamQuestion where Exam_ID = 19
exec AddGradeToQuestion_Proc
				2,
				19,
				3,
				10
select * from Exam where ID = 19
--------------------------------------------------------------------------------------------
--Instructor select questions for the exam manually
--1- give the exam specs
create or alter proc SetManualQuestionsCourseExam_Proc 
	@Instructor_ID int,
	@Course_ID int,
    @StartTime DATE,
    @EndTime DATE,
    @Corrective BIT,
    @Normal BIT
as
begin
	 IF @Instructor_ID <= 0 or @Course_ID <= 0
		BEGIN
			SELECT 'Invalid input.' AS ResultMessage
			RETURN
		END
	ELSE IF @StartTime < GETDATE() or @EndTime < GETDATE()
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
		begin 
			SELECT 'course id or instructor id or both are wrong' AS ResultMessage
			Return
		end
		--checking if this course is teached by that instructor (if exists)
			declare @NewExam_ID int 
			SELECT TOP 1 @NewExam_ID = ID + 1 FROM Exam ORDER BY ID DESC --get the last exam id and increments it by 1 as the new exam id
			--select @NewExam_ID
			 INSERT INTO Exam (ID,NumberOfQuestions, StartTime, EndTime, TotalDegree, Corrective, Normal)
				VALUES (@NewExam_ID ,0, @StartTime, @EndTime, 0, @Corrective, @Normal)
				INSERT INTO CourseExam VALUES(@Course_ID, @NewExam_ID)
			SELECT cast(@NewExam_ID as varchar(max)) + ' is the Exam number you can add questions with.' AS ResultMessage 
end
--test
select * from ExamQuestion
 delete from ExamQuestion
exec SetManualQuestionsCourseExam_Proc 
	2,
	2,
    '2024-1-11 14:30:00','2024-1-11 15:00:00',
   0,
   1
   select * from ExamQuestion

--2- show questions available for that exam (that belongs to a specific course)
create or alter proc ShowQuestionPoolForInstructorCourse
			@Instructor_ID int,
			@Course_ID int
as
begin
	 IF @Instructor_ID <= 0 or @Course_ID <= 0 
		BEGIN
			SELECT 'Invalid input.' AS ResultMessage
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
	if (select distinct i.ID
		from Instructor i inner join InstructorCourse ic
		on i.ID = ic.Instructor_ID
		inner join Course c
		on ic.Course_ID = c.ID
		where c.ID = @Course_ID)
		!= @Instructor_ID
		begin
			SELECT 'course id or instructor id or both are wrong' AS ResultMessage
			RETURN
		end
			select Questions_ID 'Question No', Text_Questions 'Text Question with that no', Correct_Answer_Text_Questions 'Text Question Answer', True_or_False_Questions 'True or false Question with that no', 
			CASE WHEN Correct_Answer_True_or_False = 1 THEN 'True' ELSE 'False' END as 'True or false answer'
			, Choose_An_Answer_Question 'MCQ Question with that no', Correct_Answer_Choose_Question 'MCQ Answer'
			from Question where Course_Id = @Course_ID
end
--test
 exec ShowQuestionPoolForInstructorCourse 2,2
--3- add questions to the pre created exam in step 1 from pool displayed in step 2 
------------------------------------------
 create or alter proc AddQuestionToExamManually_Proc
				@Instructor_ID int,
				@Exam_ID int,
				@Question_ID int,
				@Question_Type char(4),
				@Question_Grade int
as
begin
	IF @Instructor_ID <= 0 or @Exam_ID <= 0 or @Question_ID <= 0 or @Question_Grade <= 0
		BEGIN
			SELECT 'Invalid input.' AS ResultMessage
			RETURN
		END
	else if @Question_Type not in ('Text','MCQ','TF')
	begin
			SELECT 'Question Type must be Text, MCQ or TF' AS ResultMessage
			RETURN
	end
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
	else if not exists(select * from Question where Questions_ID = @Question_ID)
	begin
		SELECT 'Question does not exist.' AS ResultMessage
		RETURN
	end
	else if not exists
	(select q.Questions_ID from Question q inner join InstructorCourse ic
	on q.Course_Id = ic.Course_ID
	where q.Questions_ID = @Question_ID and ic.Instructor_ID = @Instructor_ID) 
		--= @Question_ID
	begin
		SELECT 'Question in question pool does not belong to that course.' AS ResultMessage
		RETURN
	end
	else if (select distinct i.ID
	from Instructor i inner join InstructorCourse ic
	on i.ID = ic.Instructor_ID
	inner join Course c
	on ic.Course_ID = c.ID
	inner join CourseExam ce
	on ce.Course_ID = c.ID
	where ce.Exam_ID = @Exam_ID)
	!= @Instructor_ID
	--checking if the course(which the exam belongs to) is teached by that instructor (if exists)
	begin
		SELECT 'exam id or instructor id or both are wrong' AS ResultMessage
		Return
	end
	declare @Course_MaxDegree int
	declare @Exam_TotalDegree int
	select top 1 @Course_MaxDegree= c.MaxDegree from Course c
	inner join CourseExam ce
	on c.ID = ce.Course_ID
	select @Exam_TotalDegree = TotalDegree -- TotalDegree=105
	from Exam
	where ID = @Exam_ID
	if @Exam_TotalDegree = @Course_MaxDegree
	begin
		select 'Course Max Degree = Exam Total Degrees you cannot add more questions'
		RETURN
	end
	else if @Exam_TotalDegree + @Question_Grade > @Course_MaxDegree
		begin
			select 'Question not added! Exam total degrees exceeded course max degrees please re-assign the question with appropriate degree'
			RETURN
		end
	else if exists
		(select * from ExamQuestion where Exam_ID = @Exam_ID and Question_ID = @Question_ID)
		 begin
			SELECT 'This Question is already added in the Exam' AS ResultMessage
			RETURN
		 end
	ELSE
	BEGIN
		insert into ExamQuestion
		values (@Exam_ID, @Question_ID, @Question_Type, @Question_Grade)
		--increase number of questions & total degrees in Exam table after inserting new Question
		update Exam  
		set NumberOfQuestions = NumberOfQuestions +1, TotalDegree = TotalDegree + @Question_Grade
		where ID = @Exam_ID
	END		
end
   select * from Exam where ID = 19
exec AddQuestionToExamManually_Proc
				2,
				18,
				4,
				'TF',
				10
   select * from ExamQuestion where Exam_ID = 19
   --delete from ExamQuestion
   select * from CourseExam
  -- delete from Exam where ID= 16
  --20
--------------------------------------------------------------------------------------------
--Edit Question Grade
create or alter proc EditGradeOfQuestion_Proc
				@Instructor_ID int,
				@Exam_ID int,
				@Question_ID int,
				@Question_Grade int
as
begin
	IF @Instructor_ID <= 0 or @Exam_ID <= 0 or @Question_ID <= 0 or @Question_Grade <= 0
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
		else if not exists(select * from Question where Questions_ID = @Question_ID)
		begin
			SELECT 'Question does not exist.' AS ResultMessage
			RETURN
		end
		else if not exists
		(select q.Questions_ID from Question q inner join InstructorCourse ic
		on q.Course_Id = ic.Course_ID
		where q.Questions_ID = @Question_ID and ic.Instructor_ID = @Instructor_ID) 
		--= @Question_ID
		begin
			SELECT 'Question in question pool does not belong to that course.' AS ResultMessage
			RETURN
		end
		else if not exists(select * from ExamQuestion where Question_ID = @Question_ID and Exam_ID = @Exam_ID)
		begin
			SELECT 'Question does not exist in the exam.' AS ResultMessage
			RETURN
		end
		else if (select QuestionGrade from ExamQuestion where Question_ID = @Question_ID and Exam_ID = @Exam_ID) = 0
			or (select QuestionGrade from ExamQuestion where Question_ID = @Question_ID and Exam_ID = @Exam_ID) is Null
		begin
			SELECT 'Question in question pool does not have a grade add a grade first to the question' AS ResultMessage
			RETURN
		end
		else if (select distinct i.ID
		from Instructor i inner join InstructorCourse ic
		on i.ID = ic.Instructor_ID
		inner join Course c
		on ic.Course_ID = c.ID
		inner join CourseExam ce
		on ce.Course_ID = c.ID
		where ce.Exam_ID = @Exam_ID)
		!= @Instructor_ID
	--checking if the course(which the exam belongs to) is teached by that instructor (if exists)
		begin
			SELECT 'exam id or instructor id or both are wrong' AS ResultMessage
			Return
		end
	declare @Course_MaxDegree int
	declare @Exam_OldTotalDegree int
	select top 1 @Course_MaxDegree= c.MaxDegree from Course c
	inner join CourseExam ce
	on c.ID = ce.Course_ID
	select @Exam_OldTotalDegree = TotalDegree -- TotalDegree
	from Exam
	where ID = @Exam_ID
	declare @Question_Old_Grade int
				select @Question_Old_Grade = QuestionGrade from ExamQuestion
				where Question_ID = @Question_ID and Exam_ID = @Exam_ID
	if @Exam_OldTotalDegree - @Question_Old_Grade + @Question_Grade > @Course_MaxDegree
	begin
		select 'Grade not added! Exam total degrees exceeded course max degrees please re-assign the grade'
		RETURN
	end
				update ExamQuestion 
				set QuestionGrade = @Question_Grade
				where Question_ID = @Question_ID and Exam_ID = @Exam_ID
				--setting total degrees in Exam table
				update Exam  
				set TotalDegree = @Exam_OldTotalDegree - @Question_Old_Grade + @Question_Grade
				where ID = @Exam_ID
				select 'Grade Updated Succefully!' as ResultMessage
end
select * from ExamQuestion
exec EditGradeOfQuestion_Proc
				2,
				18,
				1,
				10
select * from Exam where ID = 18
------------------------------------------------------------------------
--delete question

create or alter proc DeleteQuestion_Proc
				@Instructor_ID int,
				@Exam_ID int,
				@Question_ID int
as
begin
	IF @Instructor_ID <= 0 or @Exam_ID <= 0 or @Question_ID <= 0 
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
		else if not exists(select * from Question where Questions_ID = @Question_ID)
		begin
			SELECT 'Question does not exist.' AS ResultMessage
			RETURN
		end
		else if not exists
		(select q.Questions_ID from Question q inner join InstructorCourse ic
		on q.Course_Id = ic.Course_ID
		where q.Questions_ID = @Question_ID and ic.Instructor_ID = @Instructor_ID) 
		--= @Question_ID
		begin
			SELECT 'Question in question pool does not belong to that course.' AS ResultMessage
			RETURN
		end
		else if (select distinct i.ID
		from Instructor i inner join InstructorCourse ic
		on i.ID = ic.Instructor_ID
		inner join Course c
		on ic.Course_ID = c.ID
		inner join CourseExam ce
		on ce.Course_ID = c.ID
		where ce.Exam_ID = @Exam_ID)
		!= @Instructor_ID
	--checking if the course(which the exam belongs to) is teached by that instructor (if exists)
		begin
			SELECT 'exam id or instructor id or both are wrong' AS ResultMessage
			Return
		end
		else if not exists(select * from ExamQuestion where Question_ID = @Question_ID and Exam_ID = @Exam_ID)
		begin
			SELECT 'Question does not exist in the exam.' AS ResultMessage
			RETURN
		end
	declare @Exam_TotalDegree int
	select @Exam_TotalDegree = TotalDegree -- TotalDegree
	from Exam
	where ID = @Exam_ID
	declare @Deleted_Question_Grade int
				select @Deleted_Question_Grade = QuestionGrade from ExamQuestion
				where Question_ID = @Question_ID and Exam_ID = @Exam_ID
	if @Deleted_Question_Grade != 0 or @Deleted_Question_Grade is not null
	begin
		update Exam  
		set TotalDegree = @Exam_TotalDegree - @Deleted_Question_Grade
		where ID = @Exam_ID
	end --if grade = 0 or null exam total degrees won't be changed, if grade = 0, null or number the question will be delted from exam question anyway
	delete from ExamQuestion where Exam_ID = @Exam_ID and Question_ID = @Question_ID
	select 'Question deleted Succefully!' as ResultMessage
end

exec DeleteQuestion_Proc
				2,
				18,
				3
select * from ExamQuestion
where Exam_ID = 18 and Question_ID = 2
select * from Exam where ID = 18
--------------------------------------------------------------------------------------------
