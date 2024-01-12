--Instructor select questions for the exam manually
--1- give the exam specs
create or alter proc SetManualQuestionsCourseExam_Proc 
	@Instructor_ID int,
	@Course_ID int,
    @StartTime DATETIME,
    @EndTime DATETIME,
    @Corrective BIT,
    @Normal BIT
as
begin
	IF @Instructor_ID <= 0 or @Course_ID <= 0 or @Instructor_ID is null or @Course_ID is null or @Corrective is null or @Normal is null
		BEGIN
			SELECT 'Invalid input.' AS ResultMessage
			RETURN
		END
	ELSE IF @StartTime < GETDATE() or @EndTime < GETDATE() or  @EndTime < @StartTime or @StartTime is null or @EndTime is null
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
			
			insert into StudentExam(Exam_ID, Student_ID) 
			select ce.Exam_ID ,sc.Std_ID from StudentCourse sc
			inner join CourseExam ce
			on ce.Course_ID = sc.Course_ID
			
			where sc.Course_ID = @Course_ID and ce.Exam_ID = @NewExam_ID
			SELECT cast(@NewExam_ID as varchar(max)) + ' is the Exam number you can add questions with.' AS ResultMessage 
end

GO

--2- show questions available for that exam (that belongs to a specific course)
create or alter proc ShowQuestionPoolForInstructorCourse
			@Instructor_ID int,
			@Course_ID int
as
begin
	IF @Instructor_ID <= 0 or @Course_ID <= 0 or @Instructor_ID is null or @Course_ID is null
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
GO

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
	IF @Instructor_ID <= 0 or @Exam_ID <= 0 or @Question_ID <= 0 or @Question_Grade <= 0 or @Instructor_ID <= 0 or @Exam_ID is null or @Question_ID is null or @Question_Grade is null or @Question_Type is null
		BEGIN
			SELECT 'Invalid input.' AS ResultMessage
			RETURN
		END
	else if @Question_Type not in ('Text','MCQ','TF')
	begin
			SELECT 'Question Type must be Text, MCQ or TF' AS ResultMessage
			RETURN
	end
	else if not exists(select 1 from Exam where ID = @Exam_ID)
		begin
			SELECT 'Exam does not exist.' AS ResultMessage
			RETURN
		end
	else if not exists(select 1 from Instructor where ID = @Instructor_ID)
	begin
		SELECT 'Instructor does not exist.' AS ResultMessage
		RETURN
	end
	else if not exists(select 1 from Question where Questions_ID = @Question_ID)
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
		(select 1 from ExamQuestion where Exam_ID = @Exam_ID and Question_ID = @Question_ID)
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
GO
   
  -- delete from Exam where ID= 16
  --20