--------------------------(1) Show Course TEACH by Instractor_ID--------------------------
create OR ALTER PROCEDURE  instrucrorscourses_PROC( @ins_id INT)
as
BEGIN
IF NOT exists(Select ID From Instructor Where ID=@ins_id)
Select 'Instructor ID You have entered not exists' 
ELSE IF NOT exists(Select Course_ID From InstructorCourse Where Course_ID=@ins_id)
Select ' Course ID not exists'
ELSE
select  I.FName AS'Instructor Name', C.Name AS'Corse Name'  
from instructor I,instructorcourse IC ,course C
where  I.ID=IC.instructor_ID AND C.ID=IC.Course_ID
 AND I.ID= @ins_id                          

END
GO
