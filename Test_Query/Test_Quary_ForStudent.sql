------------------------(1)Get Total Degree For Student-----------------
select * from StudentExamQuestions
EXEC CorrectExamForStudent @std_id = 1, @exam_id = 1
EXEC GetTotalDegreeForStudentExam @student_id = 1, @exam_id = 1

--------------------------(2) Show Student Course Exams--------------------------
exec ShowStudentCourseExams_Proc  @Student_ID = 2, @Course_ID = 2

--------------------------(3) Take And Show Exam On Specific Time--------------------------
EXEC TakeAndShowExamOnSpecificTime @std_id = 1, @exam_id = 4;

--------------------------(4) Student Answer Exam--------------------------
exec StudentAnswerExam_Proc
			@Student_ID = 1,
			@Exam_ID = 5,
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
--------------------------(7) Show Exam Results for a student --------------------------

SELECT * FROM ExamResultsView WHERE Std_ID = 1 AND Exam_ID = 5;

--------------------------(7) Show track branch intake --------------------------
select * from track_branch_intack_view
--------------------------(8) Show All Branches --------------------------
select * from   show_Branch_view
--------------------------(9) Show All Tracks --------------------------
select * from  show_Track_view 
--------------------------(10) Show All Intakes --------------------------
select * from  show_Intake_view 
--------------------------(11) Show Course in this Track --------------------------
EXEC show_TrackCourses_proc 'Full stack web developer using MEARN'
