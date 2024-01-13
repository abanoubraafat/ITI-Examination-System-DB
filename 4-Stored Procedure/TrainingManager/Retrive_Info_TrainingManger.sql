--------------------------(1) Show Info by TrainingManger_ID--------------------------
create OR ALTER PROCEDURE ManagerTrackBranchIntake_proc (@TM_id INT)
as
BEGIN
 IF NOT exists(Select ID From TrainingManager Where ID=@TM_id)
Select 'Training Manager ID You have entered not exists' 
else
select   FName+' '+LName as'TrainingManager Name' , T.Name as'Track Name',B.Name as'Branch Name',I.Name AS'Intake Name'
from  TrainingManager TM,Track T,Branch B,Intake I,TrainngManagerManage TR
WHERE  TM.ID=TR.Trainng_mannger_ID AND TR.Branch_ID=B.ID AND TR.Intake_ID=I.ID AND TR.Track_ID=T.ID
AND TM.ID=@TM_id
END
Go

--------------------------(2) Show Intake In this Branch --------------------------
create OR ALTER PROCEDURE show_BranchIntake_proc (@branch_name nvarchar(15))
as
BEGIN
IF NOT exists(Select Name From Branch Where Name=@branch_name)
Select ' Branch Name not exists'  
else
select B.Name AS'Branch Name',I.Name AS'Intake Name'
from Branch B,Intake I,StudentRegisteration S
WHERE  S.Branch_ID=B.ID  AND S.Track_ID=I.ID
AND B.Name=@branch_name
END
Go 
--------------------------(3) Show Intakes, tracks In this Branch --------------------------
create or alter proc ShowBranch_IntakesAndTracks_Proc @Branch_Name nvarchar(max)
as
begin
if not exists(select 1 from Branch where [Name] = @Branch_Name)
begin
	Select ' Branch does not exists'  as ResultMessage
	Return
end
	else if not exists(
	select top 1 i.[Name] 'Intakes', t.[Name] 'Tracks' from Branch b
	inner join InstructorBelong ib
	on ib.Branch_ID = b.ID
	inner join Intake i 
	on i.ID = ib.Intake_ID
	inner join Track t
	on ib.Track_ID = t.ID
	where b.[Name] =@Branch_Name)
	begin
		Select ' No Trackes or Intakes Available'  as ResultMessage
		Return
	end
	else
		select distinct i.[Name] 'Intakes', t.[Name] 'Tracks' from Branch b
		inner join InstructorBelong ib
		on ib.Branch_ID = b.ID
		inner join Intake i 
		on i.ID = ib.Intake_ID
		inner join Track t
		on ib.Track_ID = t.ID
		where b.[Name] =@Branch_Name
end
GO
--------------------------(4) Show Branch Students --------------------------
create or alter proc ShowBranchStudents_Proc @Branch_Name nvarchar(max)
as begin
if not exists(select 1 from Branch where [Name] = @Branch_Name)
begin
	Select ' Branch does not exists'  as ResultMessage
	Return
end	
else if not exists 
(select 1 from Branch b inner join StudentRegisteration 
sr on b.ID = sr.Branch_ID
where b.[Name] = @Branch_Name)
begin
	Select ' No Students were found'  as ResultMessage
	Return
end
else
begin
	select distinct s.FName + ' ' + s.LName 'Students Names' from Branch b inner join StudentRegisteration 
	sr on b.ID = sr.Branch_ID
	inner join Student s
	on sr.Std_ID = s.ID
	where b.[Name] = @Branch_Name
end
end
GO
--------------------------(5) Show Branch Instructors --------------------------
create or alter proc ShowBranchInstructors_Proc @Branch_Name nvarchar(max)
as begin
if not exists(select 1 from Branch where [Name] = @Branch_Name)
begin
	Select ' Branch does not exists'  as ResultMessage
	Return
end	
else if not exists 
(select 1 from Branch b inner join InstructorBelong ib 
 on b.ID = ib.Branch_ID
where b.[Name] = @Branch_Name)
begin
	Select ' No Instructors were found'  as ResultMessage
	Return
end
else
begin
	select distinct i.FName + ' ' + i.LName 'Instructors Names' from Branch b inner join InstructorBelong ib 
	 on b.ID = ib.Branch_ID
	inner join Instructor i
	on ib.Ins_ID = i.ID
	where b.[Name] = @Branch_Name
end
end
GO
--------------------------(6) Show Track Students --------------------------
create or alter proc ShowTrackStudents_Proc @Track_Name nvarchar(max)
as begin
if not exists(select 1 from Track where [Name] = @Track_Name)
begin
	Select ' Track does not exists'  as ResultMessage
	Return
end	
else if not exists 
(select 1 from Track t inner join StudentRegisteration 
sr on t.ID = sr.Track_ID
where t.[Name] = @Track_Name)
begin
	Select ' No Students were found'  as ResultMessage
	Return
end
else
begin
	select s.FName + ' ' + s.LName 'Students Names' from Track t inner join StudentRegisteration 
	sr on t.ID = sr.Track_ID
	inner join Student s
	on sr.Std_ID = s.ID
	where t.[Name] = @Track_Name
end
end
GO
--------------------------(7) Show Track Instructors --------------------------
create or alter proc ShowTrackInstrucors_Proc @Track_Name nvarchar(max)
as begin
if not exists(select 1 from Track where [Name] = @Track_Name)
begin
	Select ' Track does not exists'  as ResultMessage
	Return
end	
else if not exists 
(select 1 from Track t inner join InstructorBelong ib 
 on t.ID = ib.Track_ID
where t.[Name] = @Track_Name)
begin
	Select ' No Instructors were found'  as ResultMessage
	Return
end
else
begin
	select i.FName + ' ' + i.LName 'Instructors Names' from Track t inner join InstructorBelong ib 
	 on t.ID = ib.Track_ID
	inner join Instructor i
	on ib.Ins_ID = i.ID
	where t.[Name] = @Track_Name
end
end

GO
--------------------------(8) Show Students in specific Branch Intake Track --------------------------
create or alter proc ShowStudentsInSpecificBranchIntakeTrack_Proc @Branch_Name nvarchar(max), @Intake_Name nvarchar(max), @Track_Name nvarchar(max)
as begin
if not exists(select 1 from Branch where [Name] = @Branch_Name)
begin
	Select ' Branch does not exists'  as ResultMessage
	Return
end	
else if not exists(select 1 from Track where [Name] = @Track_Name)
begin
	Select ' Track does not exists'  as ResultMessage
	Return
end	
else if not exists(select 1 from Intake where [Name] = @Intake_Name)
begin
	Select ' Intake does not exists'  as ResultMessage
	Return
end
else if not exists 
(select 1 from Branch b inner join StudentRegisteration 
sr on b.ID = sr.Branch_ID
inner join Intake i on sr.Intake_ID = i.ID
inner join Track t on sr.Track_ID = t.ID
where b.[Name] = @Branch_Name and t.[Name] = @Track_Name and i.[Name] = @Intake_Name)
begin
	Select ' No Students were found'  as ResultMessage
	Return
end
else
begin
	select s.FName + ' ' + s.LName 'Students Names' from Branch b inner join StudentRegisteration 
	sr on b.ID = sr.Branch_ID
	inner join Intake i on sr.Intake_ID = i.ID
	inner join Track t on sr.Track_ID = t.ID
	inner join Student s on sr.Std_ID = s.ID
	where b.[Name] = @Branch_Name and t.[Name] = @Track_Name and i.[Name] = @Intake_Name
end
end
GO
--------------------------(9)  Show Instructors in specific Branch Intake Track --------------------------
create or alter proc ShowInstructorsInSpecificBranchIntakeTrack_Proc @Branch_Name nvarchar(max), @Intake_Name nvarchar(max), @Track_Name nvarchar(max)
as begin
if not exists(select 1 from Branch where [Name] = @Branch_Name)
begin
	Select ' Branch does not exists'  as ResultMessage
	Return
end	
else if not exists(select 1 from Track where [Name] = @Track_Name)
begin
	Select ' Track does not exists'  as ResultMessage
	Return
end	
else if not exists(select 1 from Intake where [Name] = @Intake_Name)
begin
	Select ' Intake does not exists'  as ResultMessage
	Return
end
else if not exists 
(select 1 from Branch b inner join InstructorBelong 
ib on b.ID = ib.Branch_ID
inner join Intake i on ib.Intake_ID = i.ID
inner join Track t on ib.Track_ID = t.ID
where b.[Name] = @Branch_Name and t.[Name] = @Track_Name and i.[Name] = @Intake_Name)
begin
	Select ' No Instructors were found'  as ResultMessage
	Return
end
else
begin
	select inst.FName + ' ' + inst.LName 'Instructors Names' from Branch b inner join InstructorBelong 
	ib on b.ID = ib.Branch_ID
	inner join Intake i on ib.Intake_ID = i.ID
	inner join Track t on ib.Track_ID = t.ID
	inner join Instructor inst on inst.ID = ib.Ins_ID
	where b.[Name] = @Branch_Name and t.[Name] = @Track_Name and i.[Name] = @Intake_Name
end
end
GO
--------------------------(10) CourseTrackBranchIntake By Exam_ID  --------------------------
CREATE OR ALTER PROCEDURE CourseTrackBranchIntake_proC (@examID INT)
AS
BEGIN
    IF NOT EXISTS (SELECT ID FROM Exam WHERE ID = @examID)
    BEGIN
        SELECT 'Exam ID you have entered does not exist'
    END
    ELSE
    BEGIN
        SELECT C.Name AS 'Course Name', T.Name AS 'Track Name', B.Name AS 'Branch Name', I.Name AS 'Intake Name'
        FROM Course C
        INNER JOIN CourseExam CE ON C.ID = CE.Course_ID
        INNER JOIN Exam E ON E.ID = CE.Exam_ID
        INNER JOIN InstructorCourse IC ON C.ID = IC.Course_ID
        INNER JOIN Instructor INS ON IC.Instructor_ID = INS.ID
        INNER JOIN InstructorBelong IB ON INS.ID = IB.Ins_ID
        INNER JOIN Track T ON IB.Track_ID = T.ID
        INNER JOIN Intake I ON IB.Intake_ID = I.ID
        INNER JOIN Branch B ON IB.Branch_ID = B.ID
        WHERE E.ID = @examID
    END
END
GO
------------------------------------(11)Show All Exams---------------------
create OR ALTER view show_Exam_view
as
select NumberOfQuestions,StartTime,EndTime,TotalTime,Corrective,Normal
from Exam 

GO
------------------------------------(12)Show All Question---------------------
create OR ALTER view show_Question_view
as
select Text_Questions,Correct_Answer_Text_Questions,True_or_False_Questions,Correct_Answer_True_or_False,Choose_An_Answer_Question,Correct_Answer_Choose_Question
from Question
GO






