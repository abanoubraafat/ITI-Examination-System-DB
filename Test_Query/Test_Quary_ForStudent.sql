------------------------(1)Get Total Degree For Student-----------------
select * from StudentExamQuestions
EXEC CorrectExamForStudent 1, 5
EXEC GetTotalDegreeForStudentExam 1, 5

--------------------------(2) Show Student Course Exams--------------------------
exec ShowStudentCourseExams_Proc  2,2

--------------------------(3) Take And Show Exam On Specific Time--------------------------
EXEC TakeAndShowExamOnSpecificTime @std_id = 1, @exam_id = 6;

--------------------------(4) Student Answer Exam--------------------------
exec StudentAnswerExam_Proc
			@Student_ID = 2,
			@Exam_ID = 6,
			@Question_ID = 1,
			@Student_Question_Answer = 'c'
exec StudentAnswerExam_Proc
			@Student_ID = 2,
			@Exam_ID = 46,
			@Question_ID = 5,
			@Student_Question_Answer = '0'
exec StudentAnswerExam_Proc
			@Student_ID = 2,
			@Exam_ID = 38,
			@Question_ID = 3,
			@Student_Question_Answer = 'a'

--------------------------(5) Show Course by Student_ID--------------------------
--test
EXEC studentcourses_proc  2

--------------------------(6) Show Tracks in this Branch --------------------------
EXEC show_BranchTrack_proc  'asyut' 


