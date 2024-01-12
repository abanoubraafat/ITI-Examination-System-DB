CREATE OR ALTER PROCEDURE studentcourses_proc (@Username varchar(10), @Password varchar(10), @std_id int )
AS
BEGIN
IF not (@Username = 'student' and @Password = 'student')
begin
SELECT 'Access Denied' AS ResultMessage
RETURN
end
ELSE IF NOT exists(Select ID From Student Where ID=@std_id)
Select 'Student ID You have entered not exists' 
ELSE IF NOT exists(Select Std_ID From StudentCourse Where Std_ID=@std_id)
Select 'Courses not exist'
ELSE
select S.FName AS 'Student Name' ,C.Name AS 'Corse Name'
from Student S 
join StudentCourse SC on S.ID=SC.Std_ID
join course C on C.ID=SC.Course_ID
WHERE S.ID=@std_id


END
--test
EXEC studentcourses_proc 'student', 'student', 2
----------------------------------------------------------------------
create OR ALTER PROCEDURE  instrucrorscourses_PROC(@Username varchar(10), @Password varchar(10), @ins_id INT)
as
BEGIN
IF not(@Username = 'instructor' and @Password = 'instructor') 
begin
SELECT 'Access Denied' AS ResultMessage
RETURN
end
ELSE IF NOT exists(Select ID From Instructor Where ID=@ins_id)
Select 'Instructor ID You have entered not exists' 
ELSE IF NOT exists(Select Course_ID From InstructorCourse Where Course_ID=@ins_id)
Select ' Course ID not exists'
ELSE
select  I.FName AS'Instructor Name', C.Name AS'Corse Name'  
from instructor I,instructorcourse IC ,course C
where  I.ID=IC.instructor_ID AND C.ID=IC.Course_ID
 AND I.ID= @ins_id                          

END
--test
Exec instrucrorscourses_PROC 'instructor','instructor', 1
------------------------------------------------------------------
create OR ALTER PROCEDURE ManagerTrackBranchIntake_proc (@Username varchar(10), @Password varchar(10),@TM_id INT)
as

BEGIN
IF not(@Username = 'manager' and @Password = 'manager')
begin
SELECT 'Access Denied' AS ResultMessage
RETURN
end
ELSE IF NOT exists(Select ID From TrainingManager Where ID=@TM_id)
Select 'Training Manager ID You have entered not exists' 
ELSE IF NOT exists(Select Intake_ID From TrainngManagerManage Where Intake_ID=@TM_id)
Select ' Intake ID not exists' 
ELSE IF NOT exists(Select Branch_ID From TrainngManagerManage Where Branch_ID=@TM_id)
Select ' Branch ID not exists'
ELSE IF NOT exists(Select Track_ID From TrainngManagerManage Where Track_ID=@TM_id)
Select ' Track ID not exists'
else
select   FName+' '+LName as'TrainingManager Name' , T.Name as'Track Name',B.Name as'Branch Name',I.Name AS'Intake Name'
from  TrainingManager TM,Track T,Branch B,Intake I,TrainngManagerManage TR
WHERE  TM.ID=TR.Trainng_mannger_ID AND TR.Branch_ID=B.ID AND TR.Intake_ID=I.ID AND TR.Track_ID=T.ID
AND TM.ID=@TM_id
END
--test
EXEC ManagerTrackBranchIntake_proc 'manager','manager', 1
-------------------------------------------------------------------------
create OR ALTER PROCEDURE show_BranchTrack_proc (@Username varchar(10), @Password varchar(10),@branch_name nvarchar(15))
as

BEGIN
IF not(@Username = 'manager' and @Password = 'manager')
begin
SELECT 'Access Denied' AS ResultMessage
RETURN
end
IF NOT exists(Select Name From Branch Where Name=@branch_name)
Select ' Branch Name not exists' 
else
select B.Name AS'Branch Name',T.Name AS'Track Name'
from Branch B,Track T,StudentRegisteration S
WHERE  S.Branch_ID=B.ID  AND S.Track_ID=T.ID
AND B.Name=@branch_name
END
--test
EXEC show_BranchTrack_proc 'manager','manager', 'asyut' 
----------------------------------------------------------------
create OR ALTER PROCEDURE show_BranchIntake_proc (@Username varchar(10), @Password varchar(10),@branch_name nvarchar(15))
as

BEGIN
IF not(@Username = 'manager' and @Password = 'manager')
begin
SELECT 'Access Denied' AS ResultMessage
RETURN
end
ELSE IF NOT exists(Select Name From Branch Where Name=@branch_name)
Select ' Branch Name not exists'  
else
select B.Name AS'Branch Name',I.Name AS'Intake Name'
from Branch B,Intake I,StudentRegisteration S
WHERE  S.Branch_ID=B.ID  AND S.Track_ID=I.ID
AND B.Name=@branch_name
END
--test
EXEC show_BranchIntake_proc 'manager','manager', 'minia' 
----------------------------------------------------------------
create OR ALTER PROCEDURE show_TrackCourses_proc (@Username varchar(10), @Password varchar(10),@track_name nvarchar(50))
as

BEGIN
IF not((@Username = 'manager' and @Password = 'manager') or (@Username = 'instructor' and @Password = 'instructor') or (@Username = 'student' and @Password = 'student'))
begin
SELECT 'Access Denied' AS ResultMessage
RETURN
end
ELSE IF NOT exists(Select Name From Track Where Name=@track_name)
Select ' Track Name not exists'  
-- else IF NOT exists(Select Name From Course Where Name=@track_name)
--Select '  Course not exists in Track'  
else
select T.Name AS'Track Name',C.Name AS'Course Name'
from Track T,StudentRegisteration S,Course C
WHERE  S.Track_ID=T.ID  AND S.Std_ID=C.ID
AND T.Name=@track_name
END
--test
EXEC show_TrackCourses_proc 'manager','manager', 'Full stack web developer using .NET'
------------------------------------------------------------------------------
--create OR ALTER PROCEDURE StdCourseInfoByStudentID_proC(@StudentID INT )

--AS
--begin

--    SELECT
--         S.FName+' '+S.LName AS'Student Name',
--        C.Name AS 'Course Name',
--        E.TotalDegree,
--		E.Corrective,
--		E.Normal
        
--    FROM    Student S,Exam E,Course C,StudentExamQuestions SQ,CourseExam CE
--     WHERE  S.ID=SQ.Std_ID AND E.ID=SQ.Exam_ID AND C.ID=CE.Course_ID AND E.ID=CE.Exam_ID         
--    AND  S.ID = @StudentID
--END
----TEST
--EXEC StdCourseInfoByStudentID_proc 1


-------------------------------------------------------------------------
    