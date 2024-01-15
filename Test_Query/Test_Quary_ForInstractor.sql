----------------- Test For Instractor------------------------
----------------------(1) Add And Update And Delete And Get info for Exam -------------

EXEC GetExamDetails @ExamID = 1

-- Update Exam
EXEC UpdateExam 
    @ExamID = 15,
    @NumberOfQuestions = 25,
    @StartTime = '2024-01-15',
    @EndTime = '2024-01-15',
    @TotalDegree = 25,
    @Corrective = 0,
    @Normal = 1,
    @Course_ID = 2

EXEC GetExamDetails @ExamID = 1

---Delete 
--test
EXEC DeleteExam @ExamID = 15
EXEC GetExamDetails  @ExamID = 1

---------------------------------(2)Correct Exam For Student --------------
EXEC CorrectExamForStudent @std_id = 1, @exam_id = 1

select * from StudentExamQuestions
where Std_ID=1 and Exam_ID=5

---------------------------------(3)Get all Exam with  Exam course_id--------------
--test
EXEC GetExamsByCourse  @CourseID = 1

-----------------------------(4)Getting Exam Details along with Course Information:--------------
--test
EXEC GetExamDetailsWithCourseInfo @ExamID = 1

-----------------------------(5)Assign Exam To Student:--------------
exec AssignExamToStudent
			@Instructor_ID = 1,
			@Exam_ID = 5,
			@Student_ID = 1

-----------------------------(6)Delete Exam To Student:--------------

exec DeleteAssignedStudentExam 
			@Instructor_ID = 1,
			@Exam_ID = 5,
			@Student_ID = 1
select * from StudentExam

-----------------------------(7)Create Exam Manual Question Student:--------------
--test

exec SetManualQuestionsCourseExam_Proc 
	 @Instructor_ID = 1,
	 @Course_ID = 2,
     @StartTime = '2024-1-15 14:30:00',
	 @EndTime = '2024-1-15 18:00:00',
     @Corrective = 0,
     @Normal = 1

select * from Exam
-----------------------------(8)Show QuestionPool For InstructorCourse:--------------
   --test
 exec ShowQuestionPoolForInstructorCourse @Instructor_ID = 1, @Course_ID = 2

 -----------------------------(9)Add Question To Exam Manually:--------------

exec AddQuestionToExamManually_Proc
				@Instructor_ID = 1,
				@Exam_ID = 5,
				@Question_ID = 2,
				@Question_Type = 'TF',
				@Question_Grade = 10
   select * from ExamQuestion where Exam_ID = 2
   --delete from ExamQuestion
   select * from CourseExam
-----------------------------(10)Add Question To Exam Random :--------------
   --test
select * from StudentExam where Exam_ID = 40
 select * from ExamQuestion
 delete from ExamQuestion
exec GenerateRandomQuestionsCourseExam_Proc 
	@Instructor_ID = 1,
	@Course_ID = 2,
	@MCQ_No = 2,
	@TF_No = 2,
	@TextQ_No = 2,
    @StartTime = '2024-1-15 14:30:00',
	@EndTime = '2024-1-15 15:00:00',
    @TotalDegree = 0,
    @Corrective = 0,
    @Normal = 1

   select * from ExamQuestion
   select * from Exam where ID = 19

   -----------------------------(11)Show Question To Exam  :--------------
--test
exec ShowExamQuestions_Proc @Instructor_ID = 1, @Exam_ID = 14

   -----------------------------(12)Add Grade To Question :--------------
select * from ExamQuestion where Exam_ID = 14
exec AddGradeToQuestion_Proc
				@Instructor_ID = 1,
				@Exam_ID = 16,
				@Question_ID = 5,
				@Question_Grade = 12
select * from Exam where ID = 14
 -----------------------------(13)Edit Grade To Question :--------------
select * from ExamQuestion
exec EditGradeOfQuestion_Proc
				@Instructor_ID = 1,
				@Exam_ID = 16,
				@Question_ID = 5,
				@Question_Grade = 13

select * from Exam where ID = 18

 -----------------------------(14)Delete Question  :--------------
exec DeleteQuestion_Proc @Instructor_ID = 1, @Exam_ID = 14, @Question_ID = 5

 -----------------------------(15)Remove Exam  from course  :--------------
exec DeleteCourseExam_Proc 
	@Instructor_ID = 1 ,
	@Course_ID = 3 ,
	@Exam_ID = 14
select * from Exam
--------------------------(16) Show Course TEACH by Instractor_ID--------------------------

Exec instrucrorscourses_PROC  1
--------------------------(17) Show Instructors Courses--------------------------

select * from show_instrucrors_courses_view  
