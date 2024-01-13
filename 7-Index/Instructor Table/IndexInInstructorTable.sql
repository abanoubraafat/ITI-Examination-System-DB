----index in Instructor table
CREATE INDEX IX_Instructor_Email ON Instructor (Email ASC);
Select Email from Instructor
GO
------------------------
CREATE INDEX IX_Instructor_FullName ON Instructor (FName ASC);

select FName from Instructor
