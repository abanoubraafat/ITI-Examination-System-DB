---------------------------Add_Student_Branch_Intake_Track--------------
CREATE OR ALTER PROCEDURE AddStudentRegistration
    @Std_ID INT,
    @Intake_ID INT,
    @Track_ID INT,
    @Branch_ID INT
AS
BEGIN
    -- Check if Std_ID exists in Student table
    IF NOT EXISTS (SELECT 1 FROM Student WHERE ID = @Std_ID)
    BEGIN
        SELECT 'Student not found.' AS ResultMessage;
        RETURN;
    END

    -- Check if Std_ID exists in StudentRegisteration table
    IF EXISTS (SELECT 1 FROM StudentRegisteration WHERE Std_ID = @Std_ID)
    BEGIN
        SELECT 'Student already registered in this table.' AS ResultMessage;
        RETURN;
    END

    -- Check if Branch_ID exists in Branch table
    IF NOT EXISTS (SELECT 1 FROM Branch WHERE ID = @Branch_ID)
    BEGIN
        SELECT 'Branch not found.' AS ResultMessage;
        RETURN;
    END

    -- Check if Intake_ID exists in Intake table
    IF NOT EXISTS (SELECT 1 FROM Intake WHERE ID = @Intake_ID)
    BEGIN
        SELECT 'Intake not found.' AS ResultMessage;
        RETURN;
    END

    -- Check if Track_ID exists in Track table
    IF NOT EXISTS (SELECT 1 FROM Track WHERE ID = @Track_ID)
    BEGIN
        SELECT 'Track not found.' AS ResultMessage;
        RETURN;
    END
	    -- If all checks pass, insert the record into InstructorBelong table
    INSERT INTO StudentRegisteration(Std_ID, Intake_ID, Track_ID, Branch_ID)
    VALUES (@Std_ID, @Intake_ID, @Track_ID, @Branch_ID);
	BEGIN
    SELECT 'Student added successfully.' AS ResultMessage;
	        RETURN;
    END


END
Go


-------------------------------------Update_Student_Branch_Intake_Track------------------------------------------
CREATE OR ALTER PROCEDURE UpdateStudentRegistration
    @Std_ID INT,
    @NewIntake_ID INT,
    @NewTrack_ID INT,
    @NewBranch_ID INT
AS
BEGIN
    -- Check if Std_ID exists in StudentRegisteration table
   IF NOT EXISTS (SELECT 1 FROM StudentRegisteration WHERE Std_ID = @Std_ID)
    BEGIN
        SELECT 'Student not found in StudentRegisteration.' AS ResultMessage;
        RETURN;
    END

    -- Perform the UPDATE operation
    UPDATE StudentRegisteration
    SET Intake_ID = @NewIntake_ID,
        Track_ID = @NewTrack_ID,
        Branch_ID = @NewBranch_ID
    WHERE Std_ID = @Std_ID;

    SELECT 'Student Info updated successfully.' AS ResultMessage;
END
GO


--------------------------DeleteStudentRegistration----------------------------------
CREATE OR ALTER PROCEDURE DeleteStudentRegistration
    @Std_ID INT
AS
BEGIN
    -- Check if Std_ID exists in StudentRegisteration table
	IF NOT EXISTS (SELECT 1 FROM StudentRegisteration WHERE Std_ID = @Std_ID)
    BEGIN
        SELECT 'Student not found in StudentRegisteration.' AS ResultMessage;
        RETURN;
    END

    -- Perform the DELETE operation
    DELETE FROM StudentRegisteration
    WHERE Std_ID = @Std_ID;

    SELECT 'Student registration deleted successfully.' AS ResultMessage;
END
GO