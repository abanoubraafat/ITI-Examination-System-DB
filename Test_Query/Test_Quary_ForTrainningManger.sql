-------------------Trainning manger--------------------------
--------(1)Add and Update And delete for Branch-----------------

--Add
select * from  Branch
exec AddOneOrMoreBranche  @BranchNames = 'Sohag';
select * from  Branch
--Update
select * from Branch
EXEC UpdateBranchNames
    @OldBranchName = 'cairo',
    @NewBranchName = 'miniya';
select * from Branch
EXEC UpdateBranchNames
    @OldBranchName = 'cairo',
    @NewBranchName = 'miniya';
--Delete
select * from Branch
EXEC DeleteBranch @BranchID = 4;
select * from Branch


-------(2) Add and Update And delete for Course -----------------


--ADD
select * from Course
EXEC AddCourse
 	@ID=5,
    @CourseName = 'js',
    @MinDegree = 25,
    @MaxDegree = 70,
    @Description = 'third course in front End';
select * from Course
EXEC AddCourse
 	@ID=7,
    @CourseName = 'jj',
    @MinDegree = 25,
    @MaxDegree = 70,
    @Description = 'second course in front End';
select * from Course
	EXEC AddCourse
 	@ID=7,
    @CourseName = 'css',
    @MinDegree = 25,
    @MaxDegree = 70,
    @Description = 'second course in front End';
--Update
SELECT * FROM Course
EXEC UpdateCourse
    @OldID = 2,
	@NEWID=3,
    @NewCourseName = 'HTML',
    @MinDegree = 10,
    @MaxDegree = 90,
    @Description = 'THE FIRST COURSE IN FRONT END';
SELECT * FROM Course
--Delete
Select * from Course
EXEC DeleteCourse @CourseID= 6;

-------(3) Add and Update And delete for Instractor -----------------

--Add
SELECT * FROM Instructor
EXEC AddInstructor
    @FName = 'mostafa',
    @LName = 'abdella',
    @Email = 'mostafaabdella88@gmail.com',
    @Password = 'Pass123t';
SELECT * FROM Instructor
EXEC AddInstructor
    @FName = 'mostafa',
    @LName = 'abdella',
    @Email = 'mostafaabdella88@gmail.com',
    @Password = 'Pass123y';

	------with incorrect pass or email---------
EXEC AddInstructor
    @FName = 'mostafa',
    @LName = 'abdella',
    @Email = 'mostafaabdella88',
    @Password = 'Pass123';

-- Update
SELECT * FROM Instructor
EXEC UpdateInstructor
    @InstructorID = 1, 
    @FName = 'abounob',
    @LName = 'bebo',
    @Email = 'bebo88@gmail.com',
    @Password = 'Pass1234';
SELECT * FROM Instructor
EXEC UpdateInstructor
    @InstructorID = 8 , 
    @FName = 'abounob',
    @LName = 'bebo',
    @Email = 'bebo88@gmail.com',
    @Password = 'Pass1234';

--Delete
SELECT * FROM Instructor
EXEC DeleteInstructorByID  @InstructorID = 6;

-------(4) Add and Update And delete for Intake -----------------
--Add
exec AddIntake @IntakeName  = '44';
exec AddIntake @IntakeName  = '66';
select * from Intake
--Update
select * from Intake
EXEC UpdateIntakeNames
    @OldIntakeName = '44',
    @NewIntakeName = '77';
select * from Intake
EXEC UpdateIntakeNames
    @OldIntakeName = '44',
    @NewIntakeName = '66';
--Delete 
select * from Intake
EXEC DeleteIntake  @IntakeID = '6';

---------------(5)Add and Update And delete for Question -----------------
--Add
SELECT * FROM Question
EXEC AddQuestion
	@Questions_ID=7,
    @Text_Questions ='what is the first course in Fornt End',
    @Correct_Answer_Text_Questions ='html',
    @True_or_False_Questions  ='js is 3 course',
    @Correct_Answer_True_or_False =1,
    @Choose_An_Answer_Question ='a or b',
    @Correct_Answer_Choose_Question ='a',
    @Course_Id  =4
SELECT * FROM Question
--Update
SELECT * FROM Question
EXEC UpdateQuestion
	@Questions_ID=6,
    @Text_Questions ='what is the first course in Fornt End',
    @Correct_Answer_Text_Questions ='html',
    @True_or_False_Questions  ='js is 3 course',
    @Correct_Answer_True_or_False =1,
    @Choose_An_Answer_Question ='a or b',
    @Correct_Answer_Choose_Question ='a',
    @Course_Id  =4
SELECT * FROM Question

--Delete
SELECT * FROM Question
EXEC DeleteQuestion  @QuestionID = 7;

---------------(6)Add and Update And delete for Student -----------------
--ADD
SELECT * from Student
EXEC AddStudent
    @ID=7,
    @FName = 'ali',
    @LName = 'abdella',
    @GraduationYear = '2020',
    @Email = 'ali88@gmail.com',
    @Password = 'Pass123Y';
SELECT * from Student

--------------- Incorrect pass or email------------------ 
EXEC AddStudent
	@ID=8,
    @FName = 'ali',
    @LName = 'abdella',
    @GraduationYear = '2020',
    @Email = 'ali88@gmail',
    @Password = 'Pass123F';

--Update
SELECT * FROM Student
EXEC UpdateStudent
    @StudentID = 7, 
    @FName = 'mostafa',
    @LName = 'abdella',
    @GraduationYear = '2021',
    @Email = 'mostafaabdella88@gmail.com',
    @Password = 'Pass123H';
SELECT * FROM Student
--Delete
SELECT * FROM Student
EXEC DeleteStudent  @StudentID = 7;

---------------(7)Add and Update And delete for track -----------------
--Add
exec AddTracks @TrackNames = 'C#';
select * from Track
--Update 
select * from Track
EXEC UpdateTrackNames
    @OldTrackName = 'C#',
    @NewTrackName = 'c++';
select * from Track
EXEC UpdateTrackNames
    @OldTrackName = '.net',
    @NewTrackName = 'c++';
--Delete 
select * from Track
EXEC DeleteTrack @TrackID = 5;
select * from Track
---------------(8)Get All Exam -----------------
--test
EXEC GetAllExams

---------------(8)Get  Range Date And Time for Exam -----------------
--test
EXEC GetExamsByDateRange @StartDate = '2024-01-01', @EndDate = '2024-01-31'

---------------(9)Get  Exams with Course Information:
--test
EXEC GetExamsWithCourseInfo

---------------(10)Add Instruct for Course:--------------------
SELECT * FROM InstructorCourse
EXEC AddInstructorCourse @Instructor_ID = 2, @Course_ID = 4;

EXEC AddInstructorCourse @Instructor_ID = 2, @Course_ID = 100;
EXEC AddInstructorCourse  @Instructor_ID = 2, @Course_ID = 8;
EXEC AddInstructorCourse  @Instructor_ID = 2, @Course_ID = 4;

----------------------- (11)Update_Instractor_Course ------------------------

select * from InstructorCourse
EXEC UpdateInstructorCourse @Instructor_ID = 1, @Old_Course_ID = 1, @New_Course_ID = 3;

EXEC UpdateInstructorCourse @Instructor_ID = 4, @Old_Course_ID = 1, @New_Course_ID = 3;
EXEC UpdateInstructorCourse  @Instructor_ID = 2, @Old_Course_ID = 4, @New_Course_ID = 1;
EXEC UpdateInstructorCourse  @Instructor_ID = 1, @Old_Course_ID = 1, @New_Course_ID = 3;
----------------------- (12)Delete_Instractor_Course ------------------------
select * from InstructorCourse
EXEC DeleteInstructorCourse @Instructor_ID = 2, @Course_ID = 4;

EXEC DeleteInstructorCourse @Instructor_ID = 4, @Course_ID = 1;
EXEC DeleteInstructorCourse @Instructor_ID = 2, @Course_ID = 5;

-------------------------------------(13)ADD_Instractor_Branch_Intake_Track---------------------------------
select * from InstructorBelong
EXEC AddInstructorBelong @Ins_ID = 4, @Intake_ID = 2, @Track_ID = 1, @Branch_ID = 1;

EXEC AddInstructorBelong @Ins_ID = 7, @Intake_ID = 3, @Track_ID = 4, @Branch_ID = 8;

EXEC AddInstructorBelong @Ins_ID = 4, @Intake_ID = 5, @Track_ID = 1, @Branch_ID = 1;

EXEC AddInstructorBelong @Ins_ID = 4, @Intake_ID = 3, @Track_ID = 8, @Branch_ID = 1;

EXEC AddInstructorBelong @Ins_ID = 4, @Intake_ID = 3, @Track_ID = 4, @Branch_ID = 8;

-------------------------------------(14)Update_Instractor_Branch_Intake_Track---------------------------------
select * from InstructorBelong
EXEC UpdateInstractorBelong @Ins_ID = 2, @NewIntake_ID = 3, @NewTrack_ID = 3, @NewBranch_ID = 1;

EXEC UpdateInstractorBelong @Ins_ID = 6, @NewIntake_ID = 2, @NewTrack_ID = 3, @NewBranch_ID = 4;


-------------------------------------(15)Delete_Instractor_Branch_Intake_Track-----------------------------
select * from InstructorBelong
EXEC DeleteInstructorBelong @Ins_ID = 4;

EXEC DeleteInstructorBelong @Ins_ID = 5;

---------------------------(16)Add_Student_Branch_Intake_Track--------------
SELECT * FROM StudentRegisteration 
EXEC AddStudentRegistration  @Std_ID = 4, @Intake_ID = 2, @Track_ID = 1, @Branch_ID = 1;

EXEC AddStudentRegistration @Std_ID = 1, @Intake_ID = 1, @Track_ID = 1, @Branch_ID = 1;
EXEC AddStudentRegistration @Std_ID = 7, @Intake_ID = 1, @Track_ID = 2, @Branch_ID = 1;
EXEC AddStudentRegistration @Std_ID = 4, @Intake_ID = 8, @Track_ID = 2, @Branch_ID = 1;
EXEC AddStudentRegistration @Std_ID = 4, @Intake_ID = 1, @Track_ID = 8, @Branch_ID = 1;
EXEC AddStudentRegistration @Std_ID = 4, @Intake_ID = 1, @Track_ID = 2, @Branch_ID = 8;
---------------------------(17)Update_Student_Branch_Intake_Track--------------
select * from StudentRegisteration
EXEC UpdateStudentRegistration @Std_ID = 4, @NewIntake_ID = 2, @NewTrack_ID = 3, @NewBranch_ID = 1;
---------------------------(18)Delete_Student_Branch_Intake_Track--------------
select * from StudentRegisteration
EXEC DeleteStudentRegistration @Std_ID = 4;

--------------------------(19) Show Info by TrainingManger_ID--------------------------
EXEC ManagerTrackBranchIntake_proc  1

-------------------------- (20) Show Intake In this Branch--------------------------
EXEC show_BranchIntake_proc  'asyut' 
--------------------------(21) Show Intakes, tracks In this Branch --------------------------
exec ShowBranch_IntakesAndTracks_Proc 'Minia'
--------------------------(22) Show Branch Students --------------------------
exec ShowBranchStudents_Proc 'Minia'
--------------------------(23) Show Branch Instructors --------------------------
exec ShowBranchInstructors_Proc 'Minia'
--------------------------(24) Show Track Students --------------------------
exec ShowTrackStudents_Proc 'Full stack web developer using Python'
--------------------------(25) Show Track Students --------------------------
exec ShowTrackInstrucors_Proc 'Full stack web developer using MEARN'
--------------------------(26) Show Students in specific Branch Intake Track --------------------------
exec ShowStudentsInSpecificBranchIntakeTrack_Proc @Branch_Name = 'Minia', @Intake_Name = 'intake 41' ,@Track_Name = 'Full stack web developer using .NET'
--------------------------(27)  Show Instructors in specific Branch Intake Track --------------------------
exec ShowInstructorsInSpecificBranchIntakeTrack_Proc @Branch_Name = 'Minia', @Intake_Name = 'intake 41' ,@Track_Name = 'Full stack web developer using .NET'
-------------------------- (28) Show Training Manager Info --------------------------

select * from show_TrainingManagerInfo_view 
-------------------------- (29) Show All Student --------------------------
select * from  show_Student_view
-------------------------- (30) Show All Instructors --------------------------
select * from  show_Istructor_view
-------------------------- (31) Show All Courses --------------------------
select * from  show_Cources_view
-------------------------- (32) Show Training Manager --------------------------
select * from  show_TrainingManager_view
--------------------------(33) CourseTrackBranchIntake By Exam_ID  --------------------------
EXEC CourseTrackBranchIntake_proC 3
------------------------------------(33)Show All Exams---------------------
select * from show_Exam_view
------------------------------------(12)Show All Question---------------------
select * from  show_Question_view