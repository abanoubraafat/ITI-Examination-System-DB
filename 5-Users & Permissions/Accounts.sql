-- Admin Account --
CREATE LOGIN itiadmin
WITH PASSWORD = 'itiadmin' ,
DEFAULT_DATABASE = [ITIExaminationSystem]
GO

Use ITIExaminationSystem
CREATE USER itiadmin 
FOR LOGIN itiadmin
GO

--Training Manager Account--

CREATE LOGIN manager
WITH PASSWORD = 'manager' ,
DEFAULT_DATABASE = [ITIExaminationSystem]
GO

Use ITIExaminationSystem
CREATE USER manager 
FOR LOGIN manager
GO
-----------------------------------------------------------
--Instructor Account--
CREATE LOGIN instructor
WITH PASSWORD = 'instructor' ,
DEFAULT_DATABASE = [ITIExaminationSystem]
GO

Use ITIExaminationSystem
CREATE USER instructor 
FOR LOGIN instructor
GO

--------------------------------------------------------------
--Student Account--
CREATE LOGIN student
WITH PASSWORD = 'student' ,
DEFAULT_DATABASE = [ITIExaminationSystem]
GO

Use ITIExaminationSystem
CREATE USER student 
FOR LOGIN student
GO