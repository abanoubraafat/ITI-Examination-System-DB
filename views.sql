create or alter view  GetStudentDetails_view

as 
(
select S.FName+' '+S.LName as'	Student Name',C.Name as'Course Name',T.Name as'Track Name',B.Name as'Branch Name',I.Name'Intake Name'



from Student S,StudentRegisteration R,Track T,Branch B,Intake I ,Course C,StudentCourse SC
where   S.ID=SC.Std_ID  AND  C.ID=SC.Course_ID AND S.ID=R.Std_ID 
AND T.ID=R.Track_ID AND B.ID=R.Branch_ID AND I.ID=R.Intake_ID
AND B.Name LIKE 'minia'
)
--test
select * from GetStudentDetails_view
-------------------------------------------------------------------------------
create or alter view GetInsractorDetails_view 

as 

(
select INS.FName+' '+INS.LName as'Insructor Name',C.Name as'course Name',T.Name as'Track Name',B.Name as'Branch Name',I.Name AS'Intake Name'
from Instructor INS,Course C ,InstructorCourse IC,InstructorBelong IB,Track T,Branch B,Intake I
WHERE INS.ID=IC.Instructor_ID AND C.ID=IC.Course_ID 
AND IB.Ins_ID=INS.ID
AND IB.Branch_ID=B.ID AND IB.Intake_ID=I.ID AND IB.Track_ID=T.ID
AND INS.FName LIKE 'Sara'
)
--test
select * from GetInsractorDetails_view
-----------------------------------------------------------------------------------
create or alter view track_branch_intack_view
as
(
select T.Name as'Track Name',B.Name as'Branch Name',I.Name AS'Intake Name'
from Track T,Branch B,Intake I,StudentRegisteration R
WHERE R.Branch_ID=B.ID AND R.Intake_ID=I.ID AND R.Track_ID=T.ID
)
--test
select * from track_branch_intack_view
-------------------------------------------------------------------------------------
create OR ALTER view show_instrucrors_courseS_view  
as
(
select I.FName'Instructor Name', C.Name 'Corse Name'  ,C.[description]
from instructor I,instructorcourse IC ,course C
where  I.ID=IC.instructor_ID AND C.ID=IC.Course_ID

)
--test
select * from show_instrucrors_courses_view  
---------------------------------------------------------------------------
create or alter view show_TrainingManagerInfo_view 
as 
(
select TR.FName+' '+TR.LName as' Training Manager Name',B.Name as'Branch Name',I.Name AS'Intake Name'
from TrainingManager TR,Branch B,Intake I ,TrainngManagerManage TM
WHERE   TM.Trainng_mannger_ID=TR.ID AND TM.Branch_ID=B.ID AND TM.Intake_ID=I.ID 
)
--test
select * from show_TrainingManagerInfo_view 
--------------------------------------------------------------------------


create OR ALTER view   show_StudentAnswerQuestion_view 
as
(
SELECT  S.ID'Std_ID', E.ID 'Exam_ID', [Std_Answer_Text_Question] ,[Std_Answer_Choose_Question],[Std_Answer_True_or_False]
      
  FROM StudentExamQuestions ,Student S,Exam E
  where Std_ID=S. ID AND Std_ID= E.ID
  )
--test
  select * from show_StudentAnswerQuestion_view 
----------------------------------------------------------------------------------
create OR ALTER view show_Student_view
as
select FName+' '+LName as'	Student Name',GraduationYear,Email
from Student
--test
select * from  show_Student_view
------------------------------------------------------------------
create OR ALTER view show_Istructor_view
as
select  FName+' '+LName as'	Instructor Name',Email
from Instructor
--test
select * from  show_Istructor_view
-----------------------------------------------------------------------
create OR ALTER view show_Cources_view
as
select Name, MinDegree,MaxDegree,Description
from Course
--test
select * from  show_Cources_view
-------------------------------------------------------------------------
create OR ALTER view show_Exam_view
as
select * from Exam
--test
select * from show_Exam_view
---------------------------------------------------------------------
create OR ALTER view show_Question_view
as
select *from Question
--test
select * from  show_Question_view
--------------------------------------------------------------------
create OR ALTER view show_StudentExamQuestions_view
as
select * from StudentExamQuestions
--test
select * from  Show_StudentExamQuestions_view
---------------------------------------------------------------------
create OR ALTER view show_TrainingManager_view
as
select  FName+' '+LName as'	TrainingManager Name',Email
from TrainingManager
--test
select * from  show_TrainingManager_view
-----------------------------------------------------------------
create OR ALTER view show_Branch_view
as
select Name 
from Branch
--test
select * from   show_Branch_view
-------------------------------------------------------------
create OR ALTER view show_Track_view
as
select  Name
from Track
--test
select * from  show_Track_view 
---------------------------------------------------------------
create OR ALTER view show_Intake_view
as
select Name
from Intake
--test
select * from  show_Intake_view 
-------------------------------------------------------------------
