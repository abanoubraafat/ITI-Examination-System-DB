------------ insert table 1  student-------------------------------

INSERT INTO Student (ID,FName,LName,GraduationYear,Email,[Password])
VALUES(1,'Mostafa','Abdullah','2020','Mostafa@gmail.com','AZ3456SS'),
      (2,'Abanoub','Raafat','2021','Abanoub@gmail.com','ZX5744SS'),
      (3,'Gehad','Mohamed','2022','Gehad@yahoo.com','VC6812SS'),
	  (4,'Mai','Bahaa','2022','Mai@yahoo.com','VC6812SS'),
	  (5,'ahmed','Mohamed','2022','ahmed@yahoo.com','7889asA2SS'),
	  (6,'mostafa','ali','2022','mostafa@yahoo.com','VC6812SS')
	  go

---------------------insert table 2  Instractor--------------------------------


INSERT INTO Instructor (FName,LName,Email,[Password])

VALUES ('Sara','Mohamed','Sara@gmail.com','AS0569SS'),
       ('Mrihan','Mohamed','mrihan@gmail.com','NB9876SS'),
       ('Ahmed','mohamed','ahmed@yahoo.com','FG5325SS'),
	   ('ali','ali','ali@yahoo.com','FG5325SS'),
	   ('loay','hatem','loay@yahoo.com','FG5325SS')
go
----------------insert table 3 TrainingManager -----------------------------------

INSERT INTO TrainingManager (FName,LName,Email,[Password])

VALUES ('Ahmed','Othman','Ahmed@gmail.com','abc00SSS'),
       ('Mohamed','Tony','Mohamed@gmail.com','456ASSSS'),
       ('Mohamed','Ahmed','Ahmed@yahoo.com','ERD123SS')
go
----------------create table 4 Course-----------------------------------

INSERT INTO Course ([ID],[Name],MinDegree,MaxDegree,[Description])

VALUES (1,'HTML','30','60','Learn about web page structure'),
       (2,'CSS','30','60','Learn about web page Style'),
       (3,'Javascript','30', '60','Learn about web page interactive' ),
       (4,'OOP','30','60','programming paradigm')
	go
-------------------- insert table 5 branch --------------------


INSERT INTO Branch ([Name])
VALUES ('Minia'),('Asyut'),
       ('Alexanderia'),('Cairo')
	   go




-------------------- insert table 6  intake --------------------

INSERT INTO Intake ([Name])
VALUES ('intake 41'),('intake 42'),
       ('intake 43'),('intake 44')
go
--------------------  insert table 7 track --------------------

	INSERT INTO Track ([Name])
VALUES ('Full stack web developer using .NET'),
       ('Full stack web developer using MEARN'),
       ('Full stack web developer using PHP'),
       ('Full stack web developer using Python')
	   go
-------------------- insert table 8 exam --------------------


INSERT INTO Exam(ID,NumberOfQuestions ,StartTime,EndTime,TotalDegree,Corrective,Normal)
VALUES (1,10,'2024-1-7 14:30:00','2024-1-7 15:00:00',60,0,1),
      (2,10,'2024-1-8 10:00:00','2024-1-8 11:00:00',60,0,1),
      (3,10,'2024-1-9 11:30:00','2024-1-9 12:00:00',60,0,1),
      (4,10,'2024-1-10 15:30:00','2024-1-10 16:00:00',60,0,1)
	  go
-------------------- insert table 9 Question --------------------
INSERT [dbo].[Question] (Questions_ID, [Text_Questions], [Correct_Answer_Text_Questions], [True_or_False_Questions], [Correct_Answer_True_or_False], [Choose_An_Answer_Question], [Correct_Answer_Choose_Question], [Course_Id])values
 (1, N'Describe Database.', N'Collection of tables.', N'Is C# purly OOP?', 0, N'The first true object oriented language is: a) C++. b) SmallTalk. c) C#.', N'b', 1),
 (2, N'What is a Primary key?', N'Unique key and not null constraint.', N'A relation might have multiple foreign keys?', 1, N'The first true object oriented language is: a) C++. b) SmallTalk. c) C#.', N'b', 2),
 (3, N'What is an aliac command ?', N'It is refered in where clause to identify table or column.', N'A relation might have multiple foreign keys?', 1, N'Which of the following is not an SQL command: a) forget. b) select. c) where', N'a', 3),
 (4, N'What is SQL?', N'SQL stands for Structured Query Language.', N'Is alter a DDL command?', 1, N'The primary key can be: a) null. b) not null. c) both null and not null.', N'b', 1),
 (5, N'What is a join?', N'It is a keyword to query data from more tables.', N'Each column can have more than one data type?', 0, N'The primary key can be: a) null. b) not null. c) both null and not null.', N'b', 2),
 (6, N'What is a DB query?', N'It is a code that is written to get information back from the DB.', N'The condition in a where clause can refer to only one value?', 0, N'What is a table joined with itself called: a) Join. b) Outer Join. c) self-join.', N'c', 4)
 go
 --select * from Question
 -------------------- insert table 10 student_Exam --------------------


INSERT INTO StudentExamQuestions([Std_ID] ,[Exam_ID] ,[Questions_result],[Std_Answer_Text_Question] ,[Std_Answer_Choose_Question] ,[Std_Answer_True_or_False] ,[Questions_Id] )values
 ( 1,1, 0, N'collection of table', N'b', 0, 1),
  (1, 1, 0, N'Unique key and not null constraint', N'b',1 , 2),
  (1, 1, 0, N'It is refered in where clause to identify table or column', N'a', 1, 3),
  (1, 1, 0, N'SQL stands for Structured Query Language', N'b', 1, 4)
 
 go
-------------------- insert table 11 student_Courses --------------------

INSERT INTO StudentCourse(Std_ID,Course_ID)
VALUES (1,1),(2,2)

go
-------------------- insert table 12 InstructorCourse--------------------

INSERT INTO InstructorCourse(Instructor_ID,Course_ID)
VALUES (1,1),(2,3)
go
---------------------- insert table 13 student_registration--------------

INSERT INTO StudentRegisteration (Std_ID ,Intake_ID ,Track_ID,Branch_ID)
VALUES (1,1,1,1),(2,2,2,2),(3,3,3,3)
go
---------------------- insert table 14 Instractor_Belong--------------

INSERT INTO InstructorBelong(Ins_ID ,Intake_ID ,Track_ID,Branch_ID)
VALUES (1,1,1,1),(2,2,2,2),(3,3,3,3)
go
---------------------- insert table 15 TrainngManagerManage--------------


INSERT INTO TrainngManagerManage (Trainng_mannger_ID ,Intake_ID ,Track_ID,Branch_ID)
VALUES (1,1,1,1),(2,2,2,2),(3,3,3,3)
go
---------------------- insert table 16  CourseExam--------------

INSERT INTO CourseExam(Course_ID,Exam_ID)
VALUES(1,1),(1,2),(1,3),(1,4)
go