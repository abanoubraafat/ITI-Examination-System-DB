--index in Student table
CREATE INDEX IX_Student_Email ON Student (Email ASC);
select Email from Student
Go
---------------------------
CREATE INDEX IX_Student_FullName ON Student (FName ASC, LName ASC);
select FName,LName from Student
select FName+' '+LName as FullName from Student
GO
-------
CREATE INDEX IX_Student_FullName_Email ON Student (FName ASC, LName ASC) INCLUDE (Email);
SELECT FName, LName, Email FROM Student ;

SELECT FName, LName, Email FROM Student WHERE FName = 'Mai';

