--Not Added yet
--retrieve some info, add update files in Stored Procedures/Exam 
--Views

--Training Manager Permissions--
--Procedures--
grant execute on object :: [dbo].[AddCourse] to manager
grant execute on object :: [dbo].[UpdateCourse] to manager
grant execute on object :: [dbo].[DeleteCourse] to manager
grant execute on object :: [dbo].[AddInstructor] to manager 
grant execute on object :: [dbo].[UpdateInstructor] to manager 
grant execute on object :: [dbo].[DeleteInstructorByID] to manager 
grant execute on object :: [dbo].[AddQuestion] to manager
grant execute on object :: [dbo].[UpdateQuestion] to manager
grant execute on object :: [dbo].[DeleteQuestion] to manager
grant execute on object :: [dbo].[AddStudent] to manager
grant execute on object :: [dbo].[UpdateStudent] to manager
grant execute on object :: [dbo].[DeleteStudent] to manager
grant execute on object :: [dbo].[AddStudentRegistration] to manager
grant execute on object :: [dbo].[UpdateStudentRegistration] to manager
grant execute on object :: [dbo].[DeleteStudentRegistration]  to manager
grant execute on object :: [dbo].[AddInstructorCourse] to manager
grant execute on object :: [dbo].[UpdateInstructorCourse] to manager
grant execute on object :: [dbo].[DeleteInstructorCourse] to manager
grant execute on object :: [dbo].[AddInstructorBelong] to manager
grant execute on object :: [dbo].[UpdateInstractorBelong] to manager
grant execute on object :: [dbo].[DeleteInstructorBelong] to manager
grant execute on object :: [dbo].[GetAllExams] to manager
grant execute on object :: [dbo].[GetExamsByDateRange] to manager
grant execute on object :: [dbo].[GetExamsWithCourseInfo] to manager
grant execute on object :: [dbo].[ManagerTrackBranchIntake_proc] to manager
grant execute on object :: [dbo].[show_BranchTrack_proc] to manager
grant execute on object :: [dbo].[show_BranchIntake_proc] to manager
grant execute on object :: [dbo].[ShowBranch_IntakesAndTracks_Proc] to manager
grant execute on object :: [dbo].[ShowBranchStudents_Proc] to manager
grant execute on object :: [dbo].[ShowBranchInstructors_Proc] to manager
grant execute on object :: [dbo].[ShowTrackStudents_Proc] to manager
grant execute on object :: [dbo].[ShowTrackInstrucors_Proc] to manager
grant execute on object :: [dbo].[ShowStudentsInSpecificBranchIntakeTrack_Proc] to manager
grant execute on object :: [dbo].[ShowInstructorsInSpecificBranchIntakeTrack_Proc] to manager

grant execute on object :: [dbo].[AddTracks] to manager
grant execute on object :: [dbo].[UpdateTrackNames] to manager
grant execute on object :: [dbo].[DeleteTrack] to manager
grant execute on object :: [dbo].[AddIntake] to manager
grant execute on object :: [dbo].[UpdateIntakeNames] to manager
grant execute on object :: [dbo].[DeleteIntake] to manager
grant execute on object :: [dbo].[AddOneOrMoreBranche] to manager
grant execute on object :: [dbo].[UpdateBranchNames] to manager
grant execute on object :: [dbo].[DeleteBranch] to manager
--Views--

grant select on object :: [dbo].[ExamResultsView] to manager
--grant select on object :: [dbo].[GetStudentDetails_view] to manager
--grant select on object :: [dbo].[GetInsractorDetails_view] to manager
grant select on object :: [dbo].[track_branch_intack_view] to manager, student
grant select on object :: [dbo].[show_instrucrors_courseS_view] to manager
grant select on object :: [dbo].[show_TrainingManagerInfo_view] to manager
grant select on object :: [dbo].[show_StudentAnswerQuestion_view] to manager
grant select on object :: [dbo].[show_Student_view] to manager
grant select on object :: [dbo].[show_Istructor_view] to manager
grant select on object :: [dbo].[show_Cources_view] to manager
grant select on object :: [dbo].[show_Exam_view] to manager
grant select on object :: [dbo].[show_Question_view] to manager
grant select on object :: [dbo].[show_StudentExamQuestions_view] to manager
grant select on object :: [dbo].[show_TrainingManager_view] to manager
grant select on object :: [dbo].[show_Track_view] to manager, student
grant select on object :: [dbo].[show_Branch_view] to manager, student
grant select on object :: [dbo].[show_Intake_view] to manager, student



--------------------------------------------------------------------------------------
--Instructor Permissions--
--Procedures--
grant execute on object :: [dbo].[GenerateRandomQuestionsCourseExam_Proc] to instructor --tested
grant execute on object :: [dbo].[ShowExamQuestions_Proc] to instructor
grant execute on object :: [dbo].[AddGradeToQuestion_Proc] to instructor
grant execute on object :: [dbo].[SetManualQuestionsCourseExam_Proc] to instructor
grant execute on object :: [dbo].[ShowQuestionPoolForInstructorCourse] to instructor
grant execute on object :: [dbo].[AddQuestionToExamManually_Proc] to instructor
grant execute on object :: [dbo].[EditGradeOfQuestion_Proc] to instructor
grant execute on object :: [dbo].[DeleteQuestion_Proc] to instructor
grant execute on object :: [dbo].[AssignExamToStudent] to instructor
grant execute on object :: [dbo].[DeleteAssignedStudentExam] to instructor
grant execute on object :: [dbo].[DeleteCourseExam_Proc] to instructor
grant execute on object :: [dbo].[CorrectExamForStudent] to instructor
grant execute on object :: [dbo].[GetTotalDegreeForStudentExam] to instructor, student
grant execute on object :: [dbo].[UpdateExam] to instructor
grant execute on object :: [dbo].[DeleteExam] to instructor
grant execute on object :: [dbo].[instrucrorscourses_PROC] to instructor
grant execute on object :: [dbo].[GetExamsByCourse] to instructor
grant execute on object :: [dbo].[GetExamDetailsWithCourseInfo] to instructor
grant execute on object :: [dbo].[GetDetailedExamInfo] to instructor

--Views-- 

---------------------------------------------------------------------------------------

--Student Permissions--
--Procedures--
grant exec on object :: [dbo].[ShowStudentCourseExams_Proc] to student
grant exec on object :: [dbo].[studentcourses_proc] to student
grant exec on object :: [dbo].[TakeAndShowExamOnSpecificTime] to student
--Views--
