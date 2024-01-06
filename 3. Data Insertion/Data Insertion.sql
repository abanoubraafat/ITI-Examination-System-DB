------------ insert table 1  student-------------------------------

INSERT INTO Student (FName,LName,GraduationYear,Email,[Password])
VALUES('Mostafa','Abdullah','2020','Mostafa@gmail.com','AZ3456'),
      ('Abanoub','Raafat','2021','Abanoub@gmail.com','ZX5744'),
      ('Gehad','Mohamed','2022','Gehad@yahoo.com','VC6812')

---------------------insert table 2  Instractor--------------------------------


INSERT INTO Instructor (FName,LName,Email,[Password])

VALUES ('Sara','Mohamed','Sara@gmail.com','AS0569'),
       ('Mrihan','Mohamed','mrihan@gmail.com','NB9876'),
       ('Ahmed','Dirar','Ahmed@yahoo.com','FG5325')


----------------insert table 3 TrainingManager -----------------------------------

INSERT INTO TrainingManager (FName,LName,Email,[Password])

VALUES ('Ahmed','Othman','Ahmed@gmail.com','abc00'),
       ('Mohamed','Tony','Mohamed@gmail.com','456AS'),
       ('Mohamed','Ahmed','Ahmed@yahoo.com','ERD123')

----------------create table 4 Course-----------------------------------

INSERT INTO Course ([Name],MinDegree,MaxDegree,[Description])

VALUES ('HTML','65','100','Learn about web page structure'),
       ('CSS','50','100','Learn about web page Style'),
       ('Javascript','65', '100','Learn about web page interactive' ),
       ('OOP','70','100','programming paradigm')






-------------------- insert table 5 branch --------------------


INSERT INTO Branch ([Name])
VALUES ('Minia'),('Asyut'),
       ('Alexanderia'),('Cairo')





-------------------- insert table 6  intake --------------------

INSERT INTO Intake ([Name])
VALUES ('intake 41'),('intake 42'),
       ('intake 43'),('intake 44')

--------------------  insert table 7 track --------------------

	INSERT INTO Track ([Name])
VALUES ('Full stack web developer using .NET'),
       ('Full stack web developer using MEARN'),
       ('Full stack web developer using PHP'),
       ('Full stack web developer using Python')

-------------------- insert table 8 exam --------------------


INSERT INTO Exam (NumberOfQuestions ,StartTime,EndTime,TotalDegree,Corrective,Normal,Course_ID)
VALUES (20,'2024-1-7 14:30:00','2024-1-7 15:00:00',20,0,1,1),
      (25,'2024-1-8 10:00:00','2024-1-8 11:00:00',25,0,1,2),
      (30,'2024-1-9 11:30:00','2024-1-9 12:00:00',30,0,1,3),
      (35,'2024-1-10 15:30:00','2024-1-10 16:00:00',35,0,1,4)

-------------------- insert table 9 Question --------------------

INSERT INTO Question([Type],QuestionText,CorrectAnswer,True,False,Choise_1,Choise_2,Choise_3,Choise_4)
VALUES ('T/F','Is this Sql server project ?', 'T' , 1 ,0,null,null,null,null),
        ('MCQ','What is our track', '.Net' , 0 ,0,'MERN','.Net','System Admin','Cloud')
		--('Text','text', 'sql is not case sensitive' , 0 ,0,null,null,null,null)

-------------------- insert table 10 student_Exam --------------------

INSERT INTO StudentExam(Std_ID,Exam_ID ,Answer)
VALUES (1,1,'T'),
       (2,2,'MERN')
--	   (3,3,70,'T')
-------------------- insert table 11 student_Courses --------------------

INSERT INTO StudentCourse(Std_ID,Course_ID)
VALUES (1,1),(2,2)

-------------------- insert table 12 student_Courses --------------------

--INSERT INTO StudentTrack(Std_ID,Track_ID)
--VALUES (1,1),(2,2)

-------------------- insert table 13 Question_Exam --------------------

INSERT INTO QuestionExam(Question_ID,Exam_ID)
VALUES (1,1),(2,3)
-------------------- insert table 14 InstructorCourse--------------------

INSERT INTO InstructorCourse(Instructor_ID,Course_ID)
VALUES (1,1),(2,3)

---------------------- insert table 15 student_registration--------------

INSERT INTO StudentRegisteration (Std_ID ,Intake_ID ,Track_ID,Branch_ID)
VALUES (1,1,1,1),(2,2,2,2),(3,3,3,3)
---------------------- insert table 16 Instractor_Belong--------------

INSERT INTO InstructorBelong(Ins_ID ,Intake_ID ,Track_ID,Branch_ID)
VALUES (1,1,1,1),(2,2,2,2),(3,3,3,3)

---------------------- insert table 17 _Belong--------------


INSERT INTO TrainngManagerManage (Trainng_mannger_ID ,Intake_ID ,Track_ID,Branch_ID)
VALUES (1,1,1,1),(2,2,2,2),(3,3,3,3)

---------------------------------------------------------------------------------

