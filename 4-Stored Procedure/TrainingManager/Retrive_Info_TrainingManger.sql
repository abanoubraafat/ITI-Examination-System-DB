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