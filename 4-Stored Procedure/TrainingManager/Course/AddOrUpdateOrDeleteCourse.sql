-------------------------AddCourse -------------------

CREATE OR ALTER PROCEDURE AddCourse
	@ID INT,
    @CourseName nvarchar(50),
    @MinDegree int,
    @MaxDegree int,
    @Description nvarchar(max)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Course WHERE [Name] = @CourseName)
    BEGIN
        INSERT INTO Course (ID,[Name], MinDegree, MaxDegree, [Description])
        VALUES (@ID,  @CourseName, @MinDegree, @MaxDegree, @Description);

        SELECT 'Course added successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'The course ' + @CourseName + ' is already exist in the database' AS ResultMessage;
    END
END;
Go

-------------------------UpdateCourse -------------------

CREATE OR ALTER PROCEDURE UpdateCourse	
	@OldID INT,
	@NEWID INT,
    @NewCourseName nvarchar(50),
    @MinDegree int,
    @MaxDegree int,
    @Description nvarchar(max)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Course WHERE [ID] = @OldID)
    BEGIN
        UPDATE Course
        SET  ID=@OldID,
			[Name] = @NewCourseName,
            MinDegree = @MinDegree,
            MaxDegree = @MaxDegree,
            [Description] = @Description
        WHERE [ID] = @OldID;

        SELECT 'Course updated successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Course not found IN DATA BASE' AS ResultMessage;
    END
END;
Go


----------------------------Delete Course-------------

CREATE OR ALTER PROCEDURE DeleteCourse	
    @CourseID nvarchar(50)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Course WHERE ID= @CourseID)
    BEGIN
        DELETE FROM Course
        WHERE ID = @CourseID;

        SELECT 'Course deleted successfully.' AS ResultMessage;
    END
    ELSE
    BEGIN
        SELECT 'Course not found iN data base' AS ResultMessage;
    END
END;
Go
