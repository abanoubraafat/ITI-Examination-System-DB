----------------- Test For Instractor------------------------
----------------------(1) Add And Update And Delete And Get info for Exam -------------

EXEC GetExamDetails @ExamID = 1

-- Update Exam
EXEC UpdateExam 
    @ExamID = 1,
    @NumberOfQuestions = 25,
    @StartTime = '2024-01-08',
    @EndTime = '2024-01-08',
    @TotalDegree = 25,
    @Corrective = 0,
    @Normal = 1,
    @Course_ID = 2

EXEC GetExamDetails @ExamID = 1

---Delete 
--test
EXEC DeleteExam @ExamID = 1
EXEC GetExamDetails  @ExamID = 1

---------------------------------Correct Exam For Student --------------
EXEC CorrectExamForStudent 2,32
select * from StudentExamQuestions
where Std_ID=2 and Exam_ID=32