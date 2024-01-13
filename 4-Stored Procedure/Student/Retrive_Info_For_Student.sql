--------------------------(1) Show Course by Student_ID--------------------------
CREATE OR ALTER PROCEDURE studentcourses_proc ( @std_id int )
AS
BEGIN
 IF NOT exists(Select ID From Student Where ID=@std_id)
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
Go
--------------------------(2) Show Tracks in this Branch --------------------------
create OR ALTER PROCEDURE show_BranchTrack_proc (@branch_name nvarchar(15))
as
BEGIN
IF NOT exists(Select Name From Branch Where Name=@branch_name)
Select ' Branch Name not exists' 
else
select B.Name AS'Branch Name',T.Name AS'Track Name'
from Branch B,Track T,StudentRegisteration S
WHERE  S.Branch_ID=B.ID  AND S.Track_ID=T.ID
AND B.Name=@branch_name
END
GO
--------------------------(3) Show Course in this Track --------------------------
CREATE OR ALTER PROCEDURE show_TrackCourses_proc (@track_name nvarchar(50))
AS
BEGIN
    IF NOT EXISTS (SELECT Name FROM Track WHERE Name = @track_name)
    BEGIN
        SELECT 'Track Name does not exist'
    END
    ELSE
    BEGIN
        SELECT T.Name AS 'Track Name', C.Name AS 'Course Name'
        FROM Track T
        INNER JOIN StudentRegisteration S ON S.Track_ID = T.ID
        INNER JOIN Course C ON S.Std_ID = C.ID
        WHERE T.Name = @track_name
    END
END

