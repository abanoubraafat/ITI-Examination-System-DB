--------------------------(1) show instructors courses --------------------------
create OR ALTER view show_instrucrors_courseS_view  
as
(
select I.FName'Instructor Name', C.Name 'Corse Name'  ,C.[description]
from instructor I,instructorcourse IC ,course C
where  I.ID=IC.instructor_ID AND C.ID=IC.Course_ID
)
Go
--------------------------(2) show Manager Info --------------------------

create or alter view show_TrainingManagerInfo_view 
as 
(
select TR.FName+' '+TR.LName as' Training Manager Name',B.Name as'Branch Name',I.Name AS'Intake Name'
from TrainingManager TR,Branch B,Intake I ,TrainngManagerManage TM
WHERE   TM.Trainng_mannger_ID=TR.ID AND TM.Branch_ID=B.ID AND TM.Intake_ID=I.ID 
)
GO
--------------------------(3) show Student Info --------------------------
create OR ALTER view show_Student_view
as
select FName+' '+LName as'	Student Name',GraduationYear,Email
from Student
Go
--------------------------(4) show Instructor Info --------------------------
create OR ALTER view show_Istructor_view
as
select  FName+' '+LName as'	Instructor Name',Email
from Instructor
GO
--------------------------(5) show All Courses  --------------------------
create OR ALTER view show_Cources_view
as
select Name, MinDegree,MaxDegree,Description
from Course
GO
--------------------------(6) show All Training Managers with Email  --------------------------
create OR ALTER view show_TrainingManager_view
as
select  FName+' '+LName as'	TrainingManager Name',Email
from TrainingManager
GO