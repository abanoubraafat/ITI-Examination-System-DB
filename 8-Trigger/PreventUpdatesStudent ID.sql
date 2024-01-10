-- Trigger to prevent updates to Student ID in Student table if related records exist in StudentCourse table
CREATE OR ALTER TRIGGER Trg_PreventStudentIDUpdate
ON Student
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN StudentCourse sc ON i.ID = sc.Std_ID
    )
    BEGIN
        RAISERROR ('Cannot update Student ID as related records exist in StudentCourse table', 16, 1);
    END
    ELSE
    BEGIN
        UPDATE s
        SET s.FName = i.FName, s.LName = i.LName, s.GraduationYear = i.GraduationYear, s.Email = i.Email, s.[Password] = i.[Password]
        FROM Student s
        INNER JOIN inserted i ON s.ID = i.ID;
    END
END;

UPDATE Student
SET 
    FName = 'John',
    LName = 'Doe'
WHERE 
    ID = 1