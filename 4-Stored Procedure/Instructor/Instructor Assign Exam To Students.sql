
create or alter proc AssignExamToStudent	
			@Instructor_ID int,
			@Exam_ID int,
			@Student_ID int
as
begin
	IF @Instructor_ID <= 0 or @Exam_ID <= 0 or @Student_ID <= 0 or @Instructor_ID is null or @Exam_ID is null or @Student_ID is null
		BEGIN
			SELECT 'Invalid input.' AS ResultMessage
			RETURN
		END
	else if not exists(select 1 from Instructor where ID = @Instructor_ID)
	begin
			SELECT 'Instructor does not exist.' AS ResultMessage
			RETURN
	end
	else if not exists(select 1 from Exam where ID = @Exam_ID)
		begin
			SELECT 'Exam does not exist.' AS ResultMessage
			RETURN
	end
	else if not exists(select 1 from Student where ID = @Student_ID)
		begin
			SELECT 'Student does not exist.' AS ResultMessage
			RETURN
		end
		else if not exists
		(select 1 from CourseExam ce inner join InstructorCourse ic
		on ce.Course_ID = ic.Course_ID
		where ce.Exam_ID = @Exam_ID and ic.Instructor_ID = @Instructor_ID) 
		begin
			SELECT 'Exam not found' AS ResultMessage
			RETURN
		end
		else if not exists
		(select 1 from StudentCourse sc
		inner join InstructorCourse ic
		on sc.Course_ID = ic.Course_ID where ic.Instructor_ID = @Instructor_ID and sc.Std_ID = @Student_ID) 
		begin
			SELECT 'Student not found' AS ResultMessage
			RETURN
		end
		else if exists (select 1 from StudentExam where Student_ID = @Student_ID and Exam_ID = @Exam_ID)
		begin
			SELECT 'Student already added in that exam' AS ResultMessage
			RETURN
		end
		insert into StudentExam(Student_ID, Exam_ID)
		values(@Student_ID, @Exam_ID)
		select 'Student Added to Exam Successfully!' as ResultMessage
end
Go

create or alter proc DeleteAssignedStudentExam	
			@Instructor_ID int,
			@Exam_ID int,
			@Student_ID int
as
begin
	IF @Instructor_ID <= 0 or @Exam_ID <= 0 or @Student_ID <= 0 or  @Instructor_ID is null or @Exam_ID is null or @Student_ID is null
		BEGIN
			SELECT 'Invalid input.' AS ResultMessage
			RETURN
		END
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
	else if not exists(select * from Student where ID = @Student_ID)
		begin
			SELECT 'Student does not exist.' AS ResultMessage
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
		(select sc.Std_ID from StudentCourse sc
		inner join InstructorCourse ic
		on sc.Course_ID = ic.Course_ID where ic.Instructor_ID = @Instructor_ID and sc.Std_ID = @Student_ID) 
		begin
			SELECT 'Student not found' AS ResultMessage
			RETURN
		end
		else if not exists (select 1 from StudentExam where Student_ID = @Student_ID and Exam_ID = @Exam_ID)
		begin
			SELECT 'Student already not in that exam' AS ResultMessage
			RETURN
		end
		delete from StudentExam
		where Student_ID = @Student_ID and Exam_ID = @Exam_ID
		IF NOT EXISTS (SELECT 1 FROM StudentExam WHERE Student_ID = @Student_ID AND Exam_ID = @Exam_ID)
		BEGIN
			SELECT 'Student Deleted from Exam Successfully!' AS ResultMessage
		END
		ELSE
		BEGIN
			SELECT 'Deletion failed for some reason.' AS ResultMessage
		END
end

GO

---
