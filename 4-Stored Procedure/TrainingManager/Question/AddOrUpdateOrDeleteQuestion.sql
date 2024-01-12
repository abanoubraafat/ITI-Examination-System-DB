-----------------------------AddNewquestion--------------------------

CREATE OR ALTER PROC AddQuestion
	@Username varchar(10),
	@Password varchar(10),	
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
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
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

--test 
SELECT * FROM Question
EXEC AddQuestion
 'manager', 'manager', 
	@Questions_ID=7,
    @Text_Questions ='what is the first course in Fornt End',
    @Correct_Answer_Text_Questions ='html',
    @True_or_False_Questions  ='js is 3 course',
    @Correct_Answer_True_or_False =1,
    @Choose_An_Answer_Question ='a or b',
    @Correct_Answer_Choose_Question ='a',
    @Course_Id  =4
SELECT * FROM Question
-------------------------Update Question -------------------

CREATE OR ALTER PROC UpdateQuestion
	@Username varchar(10),
	@Password varchar(10),	
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
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
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

--test 
SELECT * FROM Question
EXEC UpdateQuestion
 'manager', 'manager', 
	@Questions_ID=6,
    @Text_Questions ='what is the first course in Fornt End',
    @Correct_Answer_Text_Questions ='html',
    @True_or_False_Questions  ='js is 3 course',
    @Correct_Answer_True_or_False =1,
    @Choose_An_Answer_Question ='a or b',
    @Correct_Answer_Choose_Question ='a',
    @Course_Id  =4
SELECT * FROM Question
----------------------------Delete Question-------------

CREATE OR ALTER PROCEDURE DeleteQuestion
	@Username varchar(10),
	@Password varchar(10),	
    @QuestionID int
AS
BEGIN
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    ELSE IF EXISTS (SELECT 1 FROM Question WHERE Questions_ID = @QuestionID)
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
--test
SELECT * FROM Question
EXEC DeleteQuestion  'manager', 'manager',  @QuestionID = 7;