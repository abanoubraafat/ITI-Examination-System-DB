


CREATE OR ALTER PROCEDURE GetTotalDegreeForStudentExam
    @student_id INT,
    @exam_id INT
AS
BEGIN
    -- Data validation: Check if @student_id and @exam_id are greater than zero
    IF @student_id <= 0 OR @exam_id <= 0
    BEGIN
        -- Return message for invalid input
        SELECT 'Invalid input. Student ID and Exam ID must be greater than zero.' AS ResultMessage
        RETURN
    END

    -- Data validation: Check if the pair (Std_ID, Exam_ID) exists in StudentExamQuestions table
    IF NOT EXISTS (SELECT 1 FROM StudentExamQuestions WHERE Std_ID = @student_id AND Exam_ID = @exam_id)
    BEGIN
        -- Return message that the pair does not exist in the StudentExamQuestions table
        SELECT 'Student ID and Exam ID pair does not exist in StudentExamQuestions table.' AS ResultMessage
        RETURN
    END

    DECLARE @totalDegree INT

    -- Calculate total degree by summing up question results
    SELECT @totalDegree = ISNULL(SUM(Questions_result), 0)
    FROM StudentExamQuestions
    WHERE Std_ID = @student_id AND Exam_ID = @exam_id

    -- Get the total degree required for passing from the Exam table
    DECLARE @totalDegreeRequired INT
    SELECT @totalDegreeRequired = ISNULL(TotalDegree / 2, 0)
    FROM Exam
    WHERE ID = @exam_id

    -- Check if the student passed or failed
    IF @totalDegree >= @totalDegreeRequired
    BEGIN
        -- Return the total degree along with a success message
        SELECT @totalDegree AS TotalDegree, 'Pass' AS ResultMessage
    END
    ELSE
    BEGIN
        -- Return the total degree along with a failure message
        SELECT @totalDegree AS TotalDegree, 'Fail' AS ResultMessage
    END
END


