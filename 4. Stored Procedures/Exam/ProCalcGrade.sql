drop PROCEDURE CalculateStudentExamGradeAndStatus_proc
CREATE PROCEDURE CalculateStudentExamGradeAndStatus_proc
    @StudentID INT,
    @ExamID INT
AS
BEGIN
    DECLARE @TotalQuestions INT
    DECLARE @TotalMarks INT
    DECLARE @StudentMarks INT
    DECLARE @MinDegree INT

    -- Get the total marks for the exam and minimum degree required
    SELECT @TotalMarks = E.TotalDegree,
           @MinDegree = C.MinDegree
    FROM Exam E
    INNER JOIN Course C ON E.Course_ID = C.ID
    WHERE E.ID = @ExamID;

    -- Get the total number of questions in the exam
    SELECT @TotalQuestions = COUNT(*)
    FROM QuestionExam QE
    WHERE QE.Exam_ID = @ExamID;

    -- Calculate the marks obtained by the student
    SELECT @StudentMarks = COUNT(*) 
    FROM StudentExam SE
    INNER JOIN QuestionExam QE ON SE.Exam_ID = QE.Exam_ID
	INNER JOIN Question Q ON QE.Question_ID=Q.ID
    WHERE SE.Std_ID = @StudentID
    AND SE.Exam_ID = @ExamID
	AND SE.Answer= Q.CorrectAnswer
    --AND SE.Answer = QE.CorrectAnswer; 

    -- Calculate the grade or percentage
    DECLARE @Grade DECIMAL(5, 2)
    SET @Grade = @StudentMarks;

    ---- Update the StudentExam table with the grade
    UPDATE StudentExam
    SET Grade = @Grade
    WHERE Std_ID = @StudentID
    AND Exam_ID = @ExamID;

    -- Check if the grade meets the minimum degree required
    DECLARE @StudentStatus NVARCHAR(50)
    IF @Grade >= @MinDegree
    BEGIN
        --SET @StudentStatus = 'success'
        PRINT 'Congratulations! You have passed the exam' 
    END
    ELSE
    BEGIN
        --SET @StudentStatus = 'fail'
        PRINT 'Sorry! You have failed the exam' 
    END

    -- Update the student's status in the Student table
    --UPDATE Student
    --SET StudentStatus = @StudentStatus
    --WHERE ID = @StudentID;
END;

EXEC CalculateStudentExamGradeAndStatus_proc 1,1
delete from StudentExam where Std_ID = 1

EXEC CalculateStudentExamGradeAndStatus_proc 2,9
-------------
INSERT INTO StudentExam(Std_ID,Exam_ID ,Answer)
VALUES 
       (2,2,'MERN')
INSERT INTO StudentExam(Std_ID,Exam_ID ,Answer)
VALUES 
       (1,1,'T')

select CorrectAnswer
from Question
select Grade
from StudentExam

delete from StudentExam
where Std_ID=2
delete from StudentExam
where Std_ID=1


INSERT INTO Exam  (NumberOfQuestions ,StartTime,EndTime,TotalDegree,Corrective,Normal,Course_ID)
VALUES 
       
	    (50,'2024-1-10 15:30:00','2024-1-10 16:00:00',90,0,1,4)
--INSERT INTO QuestionExam
--VALUES 
--(3,8)
--       (4,9)

INSERT INTO StudentExam(Std_ID,Exam_ID ,Answer)
VALUES 
       (2,9,'.Net')








-----------
-- Insert data into Course table
INSERT INTO Course ([Name], MinDegree, MaxDegree, [Description])
VALUES ('Math', 50, 100, 'Mathematics Course'),
       ('Science', 40, 90, 'Science Course'),
       ('History', 60, 95, 'History Course');

-- Insert data into Student table
INSERT INTO Student (FName, LName, GraduationYear, Email, [Password])
VALUES ('John', 'Doe', '2025', 'john.doe@gmail.com', 'VC6812'),
       ('Alice', 'Smith', '2024', 'alice.smith@yahoo.com', 'VC6812');

-- Insert data into Question table
INSERT INTO Question ([Type], QuestionText, CorrectAnswer, True, False, Choise_1, Choise_2, Choise_3, Choise_4)
VALUES ('Multiple choice', 'What is 2 + 2?', '4', 1, 0, '3', '4', '5', '6'),
       ('True & False', 'Is the sun hot?', 'T', 1, 0, 'T', 'F', NULL, NULL);
delete from Question
where Type='Multiple choice'
delete from Question
where Type='True & False'
-- Insert data into Exam table
INSERT INTO Exam (NumberOfQuestions, StartTime, EndTime, TotalDegree, Corrective, Normal, Course_ID)
VALUES (2, '2024-01-01', '2024-01-02', 100, 1, 0, 1),
       (1, '2024-01-05', '2024-01-06', 80, 0, 1, 2);

-- Insert data into QuestionExam table
INSERT INTO QuestionExam (Question_ID, Exam_ID)
VALUES (5, 1),
       (6, 4);
delete from QuestionExam 
where Question_ID=6
-- Insert data into StudentExam table
INSERT INTO StudentExam (Std_ID, Exam_ID, Grade, Answer)
VALUES (1, 1, NULL, '4'),
       (2, 2, NULL, 'T')

-- Insert data into Question table
INSERT INTO Question ([Type], QuestionText, CorrectAnswer, True, False, Choise_1, Choise_2, Choise_3, Choise_4)
VALUES ('Multiple choice', 'What is 2 + 2?', '4', 1, 0, '3', '4', '5', '6'),
       ('True & False', 'Is the sun hot?', 'T', 1, 0, 1, 0, NULL, NULL);


EXEC CalculateStudentExamGradeAndStatus_proc @StudentID = 1, @ExamID = 1;
------------------



CREATE PROCEDURE CalculateStudentGrade
    @StudentID INT,
    @ExamID INT
AS
BEGIN
    DECLARE @TotalGrade INT
    DECLARE @MinDegree INT
    
    -- Calculate the total grade for the student's answers
    SELECT @TotalGrade = SUM(CASE 
                                WHEN SQ.CorrectAnswer = SE.Answer THEN SQ.QuestionDegree 
                                ELSE 0 
                             END)
    FROM StudentExam SE
    INNER JOIN QuestionExam QE ON SE.Exam_ID = QE.Exam_ID
    INNER JOIN Question SQ ON QE.Question_ID = SQ.ID
    WHERE SE.Std_ID = @StudentID AND SE.Exam_ID = @ExamID
    
    -- Fetch the minimum degree required for the exam
    SELECT @MinDegree = MinDegree
    FROM Course C
    INNER JOIN Exam E ON C.ID = E.Course_ID
    WHERE E.ID = @ExamID
    
    -- Check if total grade is greater than or equal to mindegree
    IF @TotalGrade >= @MinDegree
    BEGIN
        PRINT 'Success'
    END
    ELSE
    BEGIN
        PRINT 'Fail'
    END
END;

