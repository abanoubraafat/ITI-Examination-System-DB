--------------------------(1) Show Exam Results --------------------------
CREATE OR ALTER VIEW ExamResultsView
AS
SELECT 
    se.Std_ID,
    se.Exam_ID,
    se.Questions_result,
    se.Std_Answer_Text_Question,
    se.Std_Answer_Choose_Question,
    se.Std_Answer_True_or_False,
    se.Questions_Id,
    eq.QuestionType,
    eq.QuestionGrade,
    q.Correct_Answer_Text_Questions,
    q.Correct_Answer_Choose_Question,
    q.Correct_Answer_True_or_False,
    e.TotalDegree
FROM StudentExamQuestions se
INNER JOIN ExamQuestion eq ON se.Exam_ID = eq.Exam_ID AND se.Questions_Id = eq.Question_ID
INNER JOIN Question q ON se.Questions_Id = q.Questions_ID
INNER JOIN Exam e ON se.Exam_ID = e.ID;
GO
--------------------------(2) Show track branch intake  --------------------------
create or alter view track_branch_intack_view
as
(
select T.Name as'Track Name',B.Name as'Branch Name',I.Name AS'Intake Name'
from Track T,Branch B,Intake I,StudentRegisteration R
WHERE R.Branch_ID=B.ID AND R.Intake_ID=I.ID AND R.Track_ID=T.ID
)
GO

--------------------------(3) Show All Branches  --------------------------
create OR ALTER view show_Branch_view
as
select Name 
from Branch
Go
--------------------------(4) Show All Trackes  --------------------------
create OR ALTER view show_Track_view
as
select  Name
from Track
GO
--------------------------(5) Show All Intakes  --------------------------
create OR ALTER view show_Intake_view
as
select Name
from Intake
GO