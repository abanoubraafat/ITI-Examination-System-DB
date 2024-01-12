-- Creation Of ITI Examination System
-- Database With Specific File Group
-- And Log File
CREATE DATABASE ITIExaminationSystem
ON PRIMARY 
  ( 
    NAME='ITIExaminationSystem_Primary',
    FILENAME=
       'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER2\MSSQL\DATA\ITIExaminationSystem.mdf',
    SIZE=8MB,
    MAXSIZE=20MB,
    FILEGROWTH=5MB
	),

FILEGROUP ITIExaminationSystem_FG
  (
	NAME = 'ITIExaminationSystem_FG1',
    FILENAME =
       'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER2\MSSQL\DATA\ITIExaminationSystem_FG1.ndf',
    SIZE = 1MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB
	),
  ( 
	NAME = 'ITIExaminationSystem_FG2',
    FILENAME =
       'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER2\MSSQL\DATA\ITIExaminationSystem_FG2.ndf',
    SIZE = 1MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB
	)

LOG ON
  ( 
	NAME='ITIExaminationSystem_log',
    FILENAME =
       'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER2\MSSQL\DATA\ITIExaminationSystem_log.ldf',
    SIZE=1MB,
    MAXSIZE=10MB,
    FILEGROWTH=100%
	);
