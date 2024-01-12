--Edit Question Grade
create or alter proc EditGradeOfQuestion_Proc
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
GO

------------------------------------------------------------------------
--delete question

create or alter proc DeleteQuestion_Proc
				@Instructor_ID int,
				@Exam_ID int,
				@Question_ID int
as
begin
	IF @Instructor_ID <= 0 or @Exam_ID <= 0 or @Question_ID <= 0 or @Instructor_ID is null or @Exam_ID is null or @Question_ID is null
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

GO
--------------------------------------------------------------------------------------------
--Delete Exam --Alpha
create or alter proc DeleteCourseExam_Proc 
	@Instructor_ID int,
	@Course_ID int,
	@Exam_ID int
as
begin
	IF @Instructor_ID <= 0 or @Course_ID <= 0 or @Exam_ID <= 0 or @Instructor_ID is null or @Course_ID is null or @Exam_ID is null 
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
		else if not exists(select * from Exam where ID = @Exam_ID)
		begin
			SELECT 'Exam does not exist.' AS ResultMessage
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
		else if not exists
		(select ce.Exam_ID from CourseExam ce inner join InstructorCourse ic
		on ce.Course_ID = ic.Course_ID
		where ce.Exam_ID = @Exam_ID and ic.Instructor_ID = @Instructor_ID) 
		begin
			SELECT 'Exam not found' AS ResultMessage
			RETURN
		end
	--else if exists(select top 1 from StudentExam where Exam_ID = @Exam_ID)
	--begin
	--	SELECT 'Exam is already assigned to some students YOU CAN NOT DELETE IT! remove the students first from the exam then delete it' AS ResultMessage
	--	Return
	--end
	delete from Exam where ID = @Exam_ID
end

GO

