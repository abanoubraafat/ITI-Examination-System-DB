--Training Manager Security--

CREATE LOGIN manager
WITH PASSWORD = 'manager' ,
DEFAULT_DATABASE = [ITIExaminationSystem]
GO

Use ITIExaminationSystem
CREATE USER manager 
FOR LOGIN manager
GO
--Training Manager Permissions--
--Procedures--

--Views--

--------------------------------------------------------------------------------------
--Instructor Security--
CREATE LOGIN instructor
WITH PASSWORD = 'instructor' ,
DEFAULT_DATABASE = [ITIExaminationSystem]
GO

Use ITIExaminationSystem
CREATE USER instructor 
FOR LOGIN instructor
GO
--Instructor Permissions--
--Procedures--

--Views--

---------------------------------------------------------------------------------------
--Student Security--
CREATE LOGIN student
WITH PASSWORD = 'student' ,
DEFAULT_DATABASE = [ITIExaminationSystem]
GO

Use ITIExaminationSystem
CREATE USER student 
FOR LOGIN student
GO
--Student Permissions--
--Procedures--

--Views--
