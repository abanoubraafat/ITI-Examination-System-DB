------------ create table 1  student-------------------------------
create table Student 
(
	ID int primary key identity(1,1) ,
	FName nvarchar(15) not null,
	LName nvarchar(15) not null,
	GraduationYear char(4) not null,
	Email nvarchar(50) not null,
	[Password] nvarchar(50) not null,
		constraint Stu_CheckEmailcheck check ( Email LIKE '%@gmail.com' OR Email LIKE '%@yahoo.com'),
		constraint Stu_CheckPassword check ( Password LIKE '%[A-Z]%' AND  Password LIKE '%[a-z]%' AND  Password LIKE '%[0-9]%' )
)
---------------------create table 2  Instractor--------------------------------
create table Instructor
(
	ID int primary key identity(1,1) ,
	FName nvarchar(15) not null,
	LName nvarchar(15) not null,
	Email nvarchar(50) not null,
	[Password] nvarchar(50) not null,
		constraint Ins_CheckEmailcheck check ( Email LIKE '%@gmail.com' OR Email LIKE '%@yahoo.com'),
		constraint Ins_CheckPassword check ( Password LIKE '%[A-Z]%' AND  Password LIKE '%[a-z]%' AND  Password LIKE '%[0-9]%' )
)

----------------create table 3 Courses-----------------------------------
create table TrainingManager
(
	ID int primary key identity(1,1) ,
	FName nvarchar(15) not null,
	LName nvarchar(15) not null,
	Email nvarchar(50) not null,
	[Password] nvarchar(50) not null,
	constraint trainMag_CheckEmailcheck check ( Email LIKE '%@gmail.com' OR Email LIKE '%@yahoo.com'),
	constraint trainMang_CheckPassword check ( Password LIKE '%[A-Z]%' AND  Password LIKE '%[a-z]%' AND  Password LIKE '%[0-9]%' )
)
----------------create table 4 Course-----------------------------------
create table  Course 
(
	ID int primary key identity(1,1),
	[Name] nvarchar(50) NOT NULL ,
	MinDegree int not null,
	MaxDegree int not null,
	[Description] nvarchar(max),
)

-------------------- create table 5 branch --------------------
create table  Branch 
(
	ID int primary key identity(1,1),
	[Name] nvarchar(50),
	--TrainningManger_ID int,
	--Constraint trainningmanger_branch_fk Foreign Key (TrainningManger_ID)
 --   References TrainingManager (ID)
)
-------------------- create table 6  intake --------------------
create table  Intake 
(
	ID int primary key identity(1,1),
	[Name] nvarchar(50)
)

-------------------- create table 7 track --------------------

create table Track 
(
	ID int primary key identity(1,1),
	[Name] nvarchar(50),
	--InsManger_ID int,
	--Constraint Instructor_manage_track_fk Foreign Key (InsManger_ID)
    --References Instructor (ID)
)
-------------------- create table 8 exam --------------------
--********
Create Table Exam
(
	ID int primary key identity(1,1) , 
	NumberOfQuestions int Not Null,
	StartTime date ,
	EndTime date,
	TotalTime AS datediff(minute, StartTime, EndTime),
	TotalDegree Int,
	Corrective bit Not Null,
	Normal bit Not Null,
	Course_ID int,
	Constraint Exam_Courses_FK Foreign Key (Course_ID)
    References Course (ID)
)
-------------------- create table 9 Question --------------------
Create Table Question
(
	ID int primary key identity(1,1), 
	[Type] nvarchar(15),
	QuestionText nvarchar(max) Not Null,
	CorrectAnswer nvarchar(300) Not Null,
	Ture bit not null,
	False bit not null,
	Choise_1 nvarchar(30), 
	Choise_2 nvarchar(30), 
	Choise_3 nvarchar(30), 
	Choise_4 nvarchar(30), 
)
-------------------- create table 10 student_Exam --------------------
Create Table StudentExam
(
	Std_ID int,
	Exam_ID int,
	Grade int,
	Answer nvarchar(30),

Constraint StudentExam_PK Primary Key (Std_ID,Exam_ID),
Constraint Student_Exam_Student_FK Foreign Key (Std_ID)
References Student(ID),
Constraint Student_Exam_Exam_FK Foreign Key (Exam_ID)
References Exam (ID)
)

-------------------- create table 11 student_Courses --------------------
Create Table StudentCourse
(
	Std_ID int,
	Course_ID int,


Constraint StudentCourses_PK Primary Key (Std_ID,Course_ID),
Constraint Student_Courses_Student_FK Foreign Key (Std_ID)
References Student(ID),
Constraint Student_Courses_Courses_FK Foreign Key (Course_ID)
References Course (ID)
)
-------------------- create table 12 student_Courses --------------------
Create Table StudentTrack
(
	Std_ID int,
	Track_ID int,


Constraint StudentTrack_PK Primary Key (Std_ID,Track_ID),
Constraint Student_Track_Student_FK Foreign Key (Std_ID)
References Student(ID),
Constraint Student_Track_Track_FK Foreign Key (Track_ID)
References Track (ID)
)
-------------------- create table 13 Question_Exam --------------------
Create Table QuestionExam
(
	Question_ID int,
	Exam_ID int,


Constraint Question_Exam_PK Primary Key (Question_ID ,Exam_ID ),
Constraint Question_Exam_Question_FK Foreign Key (Question_ID)
References  Question(ID),
Constraint Question_Exam_Exam_FK Foreign Key (Exam_ID)
References Exam (ID)
)
-------------------- create table 14 InstructorCourse--------------------
Create Table InstructorCourse
(
	Instructor_ID int,
	Course_ID int,
	Constraint Instructor_Courses_PK Primary Key (Instructor_ID,Course_ID),
	Constraint Instructor_Courses_Inestractor_FK Foreign Key (Instructor_ID)
	References  Instructor(ID),
	Constraint Instructor_Courses_Courses_FK Foreign Key (Course_ID )
	References Course(ID)
)

---------------------- create table 15 student_registration--------------
Create Table StudentRegisteration
(
	Std_ID int,
	Intake_ID int,
	Track_ID int,
	Branch_ID int,


Constraint Student_registeration_PK Primary Key (Std_ID,Intake_ID,Track_ID ,Branch_ID ),
Constraint Student_registeration_Std_FK Foreign Key (Std_ID)
References  Student(ID),
Constraint Student_registeration_Track_FK Foreign Key (Track_ID )
References Track(ID),
Constraint Student_registeration_Intake_FK Foreign Key (Intake_ID)
References  Intake(ID),
Constraint Student_registeration_Branch_ID_FK Foreign Key (Branch_ID)
References Branch(ID)
)
---------------------- create table 16 Instractor_Belong--------------
Create Table InstructorBelong
(
	Ins_ID int,
	Intake_ID int,
	Track_ID int,
	Branch_ID int,


Constraint Instractor_Belong_PK Primary Key (Ins_ID,Intake_ID,Track_ID ,Branch_ID ),
Constraint Instractor_Belong_Ins_FK Foreign Key (Ins_ID)
References  Instructor(ID),
Constraint Instractor_Belong_Track_FK Foreign Key (Track_ID )
References Track(ID),
Constraint Instractor_Belong_Intake_FK Foreign Key (Intake_ID)
References  Intake(ID),
Constraint Instractor_Belong_Branch_ID_FK Foreign Key (Branch_ID)
References Branch(ID)
)
---------------------- create table 17 _Belong--------------
Create Table TrainngManagerManage
(
	Trainng_mannger_ID int,
	Intake_ID int,
	Track_ID int,
	Branch_ID int,


Constraint Trainng_mannger_mange_PK Primary Key (Trainng_mannger_ID,Intake_ID,Track_ID ,Branch_ID ),
Constraint Trainng_mannger_mange_traMng_ID_FK Foreign Key (Trainng_mannger_ID)
References  TrainingManager(ID),
Constraint Trainng_mannger_mange_Track_FK Foreign Key (Track_ID )
References Track(ID),
Constraint Trainng_mannger_mange_Intake_FK Foreign Key (Intake_ID)
References  Intake(ID),
Constraint Trainng_mannger_mange_Branch_ID_FK Foreign Key (Branch_ID)
References Branch(ID)
)
---------------------- create table 14 Intake_Branch --------------------
--Create Table IntakeBranch
--(
--	Branch_ID int,
--	Intake_ID int,
	


--Constraint Branch_Intake_PK Primary Key (Branch_ID ,Intake_ID),
--Constraint Branch_Intake_Branch_FK Foreign Key (Branch_ID)
--References Branch(id) ,
--Constraint Branch_Intake_Inake_FK Foreign Key (Intake_ID)
--References Intake(id)
--)
-------------------- create table 15 Intake_Branch --------------------
--Create Table IntakeTrack
--(
--	Intake_ID int,
--	Track_ID int,
--	Constraint Intake_Track_PK Primary Key (Intake_ID,Track_ID ),
--	Constraint Intake_Track_Intake_FK Foreign Key (Intake_ID)
--	References  Intake(id),
--	Constraint Intake_Track_Track_FK Foreign Key (Track_ID )
--	References Track(id)
--)
