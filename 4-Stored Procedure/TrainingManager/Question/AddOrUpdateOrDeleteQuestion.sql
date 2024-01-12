-----------------------------AddNewquestion--------------------------

CREATE OR ALTER PROC AddQuestion
    @Text_Questions NVARCHAR(MAX) = NULL,
    @Correct_Answer_Text_Questions NVARCHAR(MAX) = NULL,
    @True_or_False_Questions NVARCHAR(MAX) = NULL,
    @Correct_Answer_True_or_False BIT = NULL,
    @Choose_An_Answer_Question NVARCHAR(MAX) = NULL,
    @Correct_Answer_Choose_Question NVARCHAR(1) = NULL,
    @Course_Id INT = NULL,
    @Questions_ID INT OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Check if the ID already exists
        IF NOT EXISTS (SELECT 1 FROM Question WHERE Questions_ID = @Questions_ID)
        BEGIN
            INSERT INTO Question (Questions_ID, Text_Questions, Correct_Answer_Text_Questions, 
                                  True_or_False_Questions, Correct_Answer_True_or_False, 
                                  Choose_An_Answer_Question, Correct_Answer_Choose_Question, 
                                  Course_Id)
            VALUES (@Questions_ID, @Text_Questions, @Correct_Answer_Text_Questions, 
                    @True_or_False_Questions, @Correct_Answer_True_or_False, 
                    @Choose_An_Answer_Question, @Correct_Answer_Choose_Question, 
                    @Course_Id);

            SELECT 'Question added successfully.' AS ResultMessage;
        END
        ELSE
        BEGIN
            SELECT 'Error: Question ID already exists in the database.' AS ResultMessage;
        END;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;

GO


-------------------------Update Question -------------------

CREATE OR ALTER PROC UpdateQuestion
    @Text_Questions NVARCHAR(MAX) = NULL,
    @Correct_Answer_Text_Questions NVARCHAR(MAX) = NULL,
    @True_or_False_Questions NVARCHAR(MAX) = NULL,
    @Correct_Answer_True_or_False BIT = NULL,
    @Choose_An_Answer_Question NVARCHAR(MAX) = NULL,
    @Correct_Answer_Choose_Question NVARCHAR(1) = NULL,
    @Course_Id INT = NULL,
    @Questions_ID INT 
AS
BEGIN
    BEGIN TRY
        -- Check if the ID already exists
        IF EXISTS (SELECT 1 FROM Question WHERE Questions_ID = @Questions_ID)
        BEGIN
            UPDATE Question 
            SET
                Text_Questions = @Text_Questions,
                Correct_Answer_Text_Questions = @Correct_Answer_Text_Questions,
                True_or_False_Questions = @True_or_False_Questions,
                Correct_Answer_True_or_False = @Correct_Answer_True_or_False,
                Choose_An_Answer_Question = @Choose_An_Answer_Question,
                Correct_Answer_Choose_Question = @Correct_Answer_Choose_Question,
                Course_Id = @Course_Id
            WHERE Questions_ID = @Questions_ID;

            SELECT 'Question updated successfully.' AS ResultMessage;
        END
        ELSE
        BEGIN
            SELECT 'Error: Question ID does not exist in the database. Cannot update.' AS ResultMessage;
        END;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;
Go


----------------------------Delete Question-------------

CREATE OR ALTER PROCEDURE DeleteQuestion
    @QuestionID int
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Question WHERE Questions_ID = @QuestionID)
    BEGIN
        DELETE FROM Question
        WHERE Questions_ID = @QuestionID;

        SELECT 'Question deleted successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Question not found IN data base' AS ResultMessage;
    END
END;
Go