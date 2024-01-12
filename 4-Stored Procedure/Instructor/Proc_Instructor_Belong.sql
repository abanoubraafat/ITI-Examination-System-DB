CREATE OR ALTER PROCEDURE AddInstructorBelong
    @Ins_ID INT,
    @Intake_ID INT,
    @Track_ID INT,
    @Branch_ID INT
AS
BEGIN
    -- Check if Ins_ID exists in Instructor table
    IF NOT EXISTS (SELECT 1 FROM Instructor WHERE ID = @Ins_ID)
    BEGIN
        SELECT 'Instructor not found in DB' AS ResultMessage;
        RETURN;
    END

    -- Check if the combination of Ins_ID, Intake_ID, Track_ID, Branch_ID already exists in InstructorBelong table
    IF EXISTS (SELECT 1 FROM InstructorBelong WHERE Ins_ID = @Ins_ID )
    BEGIN
        SELECT 'Instructor already assigned in this table.' AS ResultMessage;
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
    INSERT INTO InstructorBelong (Ins_ID, Intake_ID, Track_ID, Branch_ID)
    VALUES (@Ins_ID, @Intake_ID, @Track_ID, @Branch_ID);
	BEGIN
    SELECT 'Instructor assignment added successfully.' AS ResultMessage;
	        RETURN;
    END
	END
	GO


-------------------------------------Update_Instractor_Branch_Intake_Track------------------------------------------
CREATE OR ALTER PROCEDURE UpdateInstractorBelong
    @Ins_ID INT,
    @NewIntake_ID INT,
    @NewTrack_ID INT,
    @NewBranch_ID INT
AS
BEGIN	
    -- Check if  Ins_ID  exists in InstructorBelongtable
    IF NOT EXISTS (SELECT 1 FROM InstructorBelong WHERE Ins_ID = @Ins_ID)
    BEGIN
        SELECT 'Instractor not found in DB' AS ResultMessage;
        RETURN;
    END

    -- Perform the UPDATE operation
    UPDATE InstructorBelong
    SET Intake_ID = @NewIntake_ID,
        Track_ID = @NewTrack_ID,
        Branch_ID = @NewBranch_ID
    WHERE Ins_ID = @Ins_ID;

    SELECT 'Instractor Info updated successfully.' AS ResultMessage;
END

Go

-------------------------------------Delete_Instractor_Branch_Intake_Track------------------------------
CREATE OR ALTER PROCEDURE DeleteInstructorBelong
    @Ins_ID INT
AS
BEGIN
    -- Check if Std_ID exists in InstructorBelong table
    IF NOT EXISTS (SELECT 1 FROM InstructorBelong WHERE Ins_ID = @Ins_ID)
    BEGIN
        SELECT 'Instractor not found in InstructorBelong' AS ResultMessage;
        RETURN;
    END

    -- Perform the DELETE operation
    DELETE FROM InstructorBelong
    WHERE Ins_ID = @Ins_ID;

    SELECT 'Instructor Belong deleted successfully.' AS ResultMessage;
END
GO


