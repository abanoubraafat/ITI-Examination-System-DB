----------------------- Add_Instractor_Course ------------------------
CREATE OR ALTER PROCEDURE AddInstructorCourse	
    @Instructor_ID INT,
    @Course_ID INT
AS
BEGIN
    -- Check if Instructor_ID exists in Instructor table
    IF NOT EXISTS (SELECT 1 FROM Instructor WHERE ID = @Instructor_ID)
    BEGIN
        SELECT 'Instructor not found In DB' AS ResultMessage;
        RETURN;
    END

    -- Check if Course_ID exists in Course table
    IF NOT EXISTS (SELECT 1 FROM Course WHERE ID = @Course_ID)
    BEGIN
        SELECT 'Course not found In DB' AS ResultMessage;
        RETURN;
    END

    -- Check if the combination of Instructor_ID, Course_ID already exists in InstructorCourse table
    IF EXISTS (SELECT 1 FROM InstructorCourse WHERE Instructor_ID = @Instructor_ID AND Course_ID = @Course_ID)
    BEGIN
        SELECT 'Instructor is already assigned to this course.' AS ResultMessage;
        RETURN;
    END

    -- If all checks pass, insert the record into InstructorCourse table
    INSERT INTO InstructorCourse (Instructor_ID, Course_ID)
    VALUES (@Instructor_ID, @Course_ID);

    SELECT 'Instructor assigned to course successfully.' AS ResultMessage;
END

GO 

----------------------- Update_Instractor_Course ------------------------
CREATE OR ALTER PROCEDURE UpdateInstructorCourse	
    @Instructor_ID INT,
    @Old_Course_ID INT,
    @New_Course_ID INT
AS
BEGIN
    -- Check if Instructor_ID exists in InstructorCourse table
    IF NOT EXISTS (SELECT 1 FROM InstructorCourse WHERE Instructor_ID = @Instructor_ID)
    BEGIN
        SELECT 'Instructor does not teach any course' AS ResultMessage;
        RETURN;
    END

    -- Check if Old_Course_ID exists in InstructorCourse table
    IF NOT EXISTS (SELECT 1 FROM InstructorCourse WHERE Course_ID = @Old_Course_ID)
    BEGIN
        SELECT 'The specified course is not associated with any instructor.' AS ResultMessage;
        RETURN;
    END

    -- Check if Instructor_ID and Old_Course_ID exist together
    IF NOT EXISTS (SELECT 1 FROM InstructorCourse WHERE Instructor_ID = @Instructor_ID AND Course_ID = @Old_Course_ID)
    BEGIN
        SELECT 'Instructor does not teach this course.' AS ResultMessage;
        RETURN;
    END

    -- Check if New_Course_ID exists in Course table
    IF NOT EXISTS (SELECT 1 FROM Course WHERE ID = @New_Course_ID)
    BEGIN
        SELECT 'This course is not found in the database.' AS ResultMessage;
        RETURN;
    END

    -- Check if the combination of Instructor_ID, New_Course_ID already exists in InstructorCourse table
    IF EXISTS (SELECT 1 FROM InstructorCourse WHERE Instructor_ID = @Instructor_ID AND Course_ID = @New_Course_ID)
    BEGIN
        SELECT 'Instructor already teaches this course.' AS ResultMessage;
        RETURN;
    END

    -- If all checks pass, update the record if it exists, otherwise insert a new record
    IF EXISTS (SELECT 1 FROM InstructorCourse WHERE Instructor_ID = @Instructor_ID AND Course_ID = @Old_Course_ID)
    BEGIN
        -- Perform the UPDATE operation
        UPDATE InstructorCourse
        SET Course_ID = @New_Course_ID
        WHERE Instructor_ID = @Instructor_ID AND Course_ID = @Old_Course_ID;

        SELECT 'Instructor course updated successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        -- If the record does not exist, perform an INSERT operation
        INSERT INTO InstructorCourse (Instructor_ID, Course_ID)
        VALUES (@Instructor_ID, @New_Course_ID);

        SELECT 'Instructor assigned to new course successfully.' AS ResultMessage;
    END
END

GO


-------------------------------DELETE_Instractor_Course-----------------------
CREATE OR ALTER PROCEDURE DeleteInstructorCourse	
    @Instructor_ID INT,
    @Course_ID INT
AS
BEGIN
    -- Check if Instructor_ID exists in InstructorCourse table
    IF NOT EXISTS (SELECT 1 FROM InstructorCourse WHERE Instructor_ID = @Instructor_ID)
    BEGIN
        SELECT 'Instructor does not teach any course' AS ResultMessage;
        RETURN;
    END

    -- Check if Course_ID exists in Course table
    IF NOT EXISTS (SELECT 1 FROM InstructorCourse WHERE Course_ID = @Course_ID)
    BEGIN
        SELECT 'The specified course is not associated with any instructor.' AS ResultMessage;
        RETURN;
    END

    -- Check if the combination of Instructor_ID, Course_ID exists in InstructorCourse table
    IF NOT EXISTS (SELECT 1 FROM InstructorCourse WHERE Instructor_ID = @Instructor_ID AND Course_ID = @Course_ID)
    BEGIN
        SELECT 'Instructor does not teach this course.' AS ResultMessage;
        RETURN;
    END

    -- If all checks pass, perform the DELETE operation
    DELETE FROM InstructorCourse
    WHERE Instructor_ID = @Instructor_ID AND Course_ID = @Course_ID;

    SELECT 'Instructor course deleted successfully.' AS ResultMessage;
END
GO
