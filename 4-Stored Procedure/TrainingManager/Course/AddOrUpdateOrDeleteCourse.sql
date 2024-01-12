-------------------------AddCourse -------------------

CREATE OR ALTER PROCEDURE AddCourse
	@Username varchar(10),
	@Password varchar(10),		
	@ID INT,
    @CourseName nvarchar(50),
    @MinDegree int,
    @MaxDegree int,
    @Description nvarchar(max)
AS
BEGIN
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    ELSE IF NOT EXISTS (SELECT 1 FROM Course WHERE [Name] = @CourseName)
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
--test
select * from Course
EXEC AddCourse
 'manager', 'manager', 
	@ID=6,
    @CourseName = 'js',
    @MinDegree = 25,
    @MaxDegree = 70,
    @Description = 'third course in front End';
select * from Course
EXEC AddCourse
 'manager', 'manager', 
 	@ID=7,
    @CourseName = 'css',
    @MinDegree = 25,
    @MaxDegree = 70,
    @Description = 'second course in front End';
select * from Course
	EXEC AddCourse
 'manager', 'manager', 
 	@ID=7,
    @CourseName = 'css',
    @MinDegree = 25,
    @MaxDegree = 70,
    @Description = 'second course in front End';

-------------------------UpdateCourse -------------------

CREATE OR ALTER PROCEDURE UpdateCourse
	@Username varchar(10),
	@Password varchar(10),		
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
--test
SELECT * FROM Course
EXEC UpdateCourse
    @OldID = 2,
	@NEWID=3,
    @NewCourseName = 'HTML',
    @MinDegree = 10,
    @MaxDegree = 90,
    @Description = 'THE FIRST COURSE IN FRONT END';
SELECT * FROM Course

----------------------------Delete Course-------------

CREATE OR ALTER PROCEDURE DeleteCourse
	@Username varchar(10),
	@Password varchar(10),		
    @CourseID nvarchar(50)
AS
BEGIN
	IF not (@Username = 'manager' and @Password = 'manager')
	begin
		SELECT 'Access Denied' AS ResultMessage
		RETURN
	end
    ELSE IF EXISTS (SELECT 1 FROM Course WHERE ID= @CourseID)
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
--test
Select * from Course
EXEC DeleteCourse 'manager', 'manager',  @CourseID= 6;