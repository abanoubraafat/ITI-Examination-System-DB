----Not Added yet
----Branch, Intake, track add/update/delete security
----retrieve some info, add update files in Stored Procedures/Exam 
----Views
---- ⁄«Ì“Ì‰ »—Ê”ÌœÃ— ÌŸÂ— «·«„ Õ«‰ ··ÿ«·»
----Training Manager Security--

--CREATE LOGIN manager
--WITH PASSWORD = 'manager' ,
--DEFAULT_DATABASE = [ITIExaminationSystem]
--GO

--Use ITIExaminationSystem
--CREATE USER manager 
--FOR LOGIN manager
--GO
----Training Manager Permissions--
----Procedures--
----grant execute on object :: [dbo].[GenerateRandomQuestionsCourseExam_Proc] to 
--grant execute on object :: [dbo].[AddCourse] to manager
--grant execute on object :: [dbo].[UpdateCourse] to manager
--grant execute on object :: [dbo].[DeleteCourse] to manager
--grant execute on object :: [dbo].[AddInstructor] to manager 
--grant execute on object :: [dbo].[UpdateInstructor] to manager 
--grant execute on object :: [dbo].[DeleteInstructorByID] to manager 
--grant execute on object :: [dbo].[AddQuestion] to manager
--grant execute on object :: [dbo].[UpdateQuestion] to manager
--grant execute on object :: [dbo].[DeleteQuestion] to manager
--grant execute on object :: [dbo].[AddStudent] to manager
--grant execute on object :: [dbo].[UpdateStudent] to manager
--grant execute on object :: [dbo].[DeleteStudent] to manager
--grant execute on object :: [dbo].[AddStudentRegistration] to manager
--grant execute on object :: [dbo].[UpdateStudentRegistration] to manager
--grant execute on object :: [dbo].[DeleteStudentRegistration]  to manager
--grant execute on object :: [dbo].[AddInstructorCourse] to manager
--grant execute on object :: [dbo].[UpdateInstructorCourse] to manager
--grant execute on object :: [dbo].[DeleteInstructorCourse] to manager
--grant execute on object :: [dbo].[AddInstructorBelong] to manager
--grant execute on object :: [dbo].[UpdateInstractorBelong] to manager
--grant execute on object :: [dbo].[DeleteInstructorBelong] to manager
----Views--

----------------------------------------------------------------------------------------
----Instructor Security--
--CREATE LOGIN instructor
--WITH PASSWORD = 'instructor' ,
--DEFAULT_DATABASE = [ITIExaminationSystem]
--GO

--Use ITIExaminationSystem
--CREATE USER instructor 
--FOR LOGIN instructor
--GO
----Instructor Permissions--
----Procedures--
--grant execute on object :: [dbo].[GenerateRandomQuestionsCourseExam_Proc] to instructor --tested
--grant execute on object :: [dbo].[ShowExamQuestions_Proc] to instructor
--grant execute on object :: [dbo].[AddGradeToQuestion_Proc] to instructor
--grant execute on object :: [dbo].[SetManualQuestionsCourseExam_Proc] to instructor
--grant execute on object :: [dbo].[ShowQuestionPoolForInstructorCourse] to instructor
--grant execute on object :: [dbo].[AddQuestionToExamManually_Proc] to instructor
--grant execute on object :: [dbo].[EditGradeOfQuestion_Proc] to instructor
--grant execute on object :: [dbo].[DeleteQuestion_Proc] to instructor
--grant execute on object :: [dbo].[AssignExamToStudent] to instructor
--grant execute on object :: [dbo].[DeleteAssignedStudentExam] to instructor
--grant execute on object :: [dbo].[DeleteCourseExam_Proc] to instructor
--grant execute on object :: [dbo].[CorrectExamForStudent] to instructor
--grant execute on object :: [dbo].[GetTotalDegreeForStudentExam] to instructor


----Views--

-----------------------------------------------------------------------------------------
----Student Security--
--CREATE LOGIN student
--WITH PASSWORD = 'student' ,
--DEFAULT_DATABASE = [ITIExaminationSystem]
--GO

--Use ITIExaminationSystem
--CREATE USER student 
--FOR LOGIN student
--GO
----Student Permissions--
----Procedures--

----Views--
