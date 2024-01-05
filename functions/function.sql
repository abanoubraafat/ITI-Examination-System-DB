create function GetStudentDetails_fn ()
returns table
as 
return
(
select S.FName+''+S.LName as'	FullName',C.Name as'CourseName',T.Name as'TrackName',B.Name as'BranchName',I.Name'IntakeName'



from Student S,StudentRegisteration R,Track T,Branch B,Intake I ,Course C,StudentCourse SC
where S.ID=R.Std_ID AND T.ID=R.Track_ID AND B.ID=R.Branch_ID AND I.ID=R.Intake_ID
AND C.ID=SC.Course_ID
)
select * from dbo.GetStudentDetails_fn()
-------------------------------------------------------------------------------
create function GetInsractorDetails_fn ()
returns table
as 
return
(
select INS.FName+''+INS.LName as'fullname',C.Name as'coursename',T.Name as'trackname',B.Name as'branchname',I.Name AS'intakename'
from Instructor INS,Course C ,InstructorCourse IC,InstructorBelong IB,Track T,Branch B,Intake I
WHERE I.ID=IC.Instructor_ID AND C.ID=IC.Course_ID AND IB.Ins_ID=I.ID AND IB.Branch_ID=B.ID
AND IB.Intake_ID=I.ID AND IB.Intake_ID=T.ID
)
select * from GetInsractorDetails_fn ()