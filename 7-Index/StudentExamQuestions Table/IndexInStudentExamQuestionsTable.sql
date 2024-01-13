-- Index StudentExamQuestions table
CREATE INDEX IX_StudentExamQuestions_Std_ID_Exam_ID ON StudentExamQuestions (Std_ID, Exam_ID);

Select Std_ID,Exam_ID from StudentExamQuestions
GO
------------
CREATE INDEX IX_Questions_Result
ON StudentExamQuestions (Questions_result ASC);

select Questions_result from StudentExamQuestions
