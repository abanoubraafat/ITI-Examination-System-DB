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
CREATE TABLE Exam
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    NumberOfQuestions INT NOT NULL,
    StartTime DATE,
    EndTime DATE,
    TotalTime AS DATEDIFF(MINUTE, StartTime, EndTime),
    TotalDegree INT,
    Corrective BIT NOT NULL,
    Normal BIT NOT NULL,
    Course_ID INT,
    CONSTRAINT Exam_Courses_FK FOREIGN KEY (Course_ID)
        REFERENCES Course (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
-------------------- create table 9 Question --------------------
Create Table Question
(
	ID int primary key identity(1,1), 
	[Type] nvarchar(15),
	QuestionText nvarchar(max) Not Null,
	CorrectAnswer nvarchar(300) Not Null,
	True bit not null,
	False bit not null,
	Choise_1 nvarchar(30), 
	Choise_2 nvarchar(30), 
	Choise_3 nvarchar(30), 
	Choise_4 nvarchar(30), 
)
-------------------- create table 10 student_Exam --------------------
CREATE TABLE StudentExam
(
    Std_ID INT,
    Exam_ID INT,
    Grade INT,
    Answer NVARCHAR(30),

    CONSTRAINT StudentExam_PK PRIMARY KEY (Std_ID, Exam_ID),
    CONSTRAINT Student_Exam_Student_FK FOREIGN KEY (Std_ID)
        REFERENCES Student(ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Student_Exam_Exam_FK FOREIGN KEY (Exam_ID)
        REFERENCES Exam(ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
-------------------- create table 11 student_Courses --------------------
CREATE TABLE StudentCourse
(
    Std_ID INT,
    Course_ID INT,

    CONSTRAINT StudentCourses_PK PRIMARY KEY (Std_ID, Course_ID),
    CONSTRAINT Student_Courses_Student_FK FOREIGN KEY (Std_ID)
        REFERENCES Student(ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Student_Courses_Courses_FK FOREIGN KEY (Course_ID)
        REFERENCES Course(ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
-------------------- create table 12 Question_Exam --------------------
CREATE TABLE QuestionExam
(
    Question_ID INT,
    Exam_ID INT,
    QuestionGrade INT,

    CONSTRAINT Question_Exam_PK PRIMARY KEY (Question_ID, Exam_ID),
    CONSTRAINT Question_Exam_Question_FK FOREIGN KEY (Question_ID)
        REFERENCES Question(ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Question_Exam_Exam_FK FOREIGN KEY (Exam_ID)
        REFERENCES Exam(ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-------------------- create table 13 InstructorCourse--------------------
CREATE TABLE InstructorCourse
(
    Instructor_ID INT,
    Course_ID INT,

    CONSTRAINT Instructor_Courses_PK PRIMARY KEY (Instructor_ID, Course_ID),
    CONSTRAINT Instructor_Courses_Inestractor_FK FOREIGN KEY (Instructor_ID)
        REFERENCES Instructor(ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Instructor_Courses_Courses_FK FOREIGN KEY (Course_ID)
        REFERENCES Course(ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
---------------------- create table 14 student_registration--------------
CREATE TABLE StudentRegisteration
(
    Std_ID INT,
    Intake_ID INT,
    Track_ID INT,
    Branch_ID INT,

    CONSTRAINT Student_registeration_PK PRIMARY KEY (Std_ID, Intake_ID, Track_ID, Branch_ID),
    CONSTRAINT Student_registeration_Std_FK FOREIGN KEY (Std_ID)
        REFERENCES Student (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Student_registeration_Track_FK FOREIGN KEY (Track_ID)
        REFERENCES Track (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Student_registeration_Intake_FK FOREIGN KEY (Intake_ID)
        REFERENCES Intake (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Student_registeration_Branch_ID_FK FOREIGN KEY (Branch_ID)
        REFERENCES Branch (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

---------------------- create table 15 Instractor_Belong--------------
CREATE TABLE InstructorBelong
(
    Ins_ID INT,
    Intake_ID INT,
    Track_ID INT,
    Branch_ID INT,

    CONSTRAINT Instractor_Belong_PK PRIMARY KEY (Ins_ID, Intake_ID, Track_ID, Branch_ID),
    CONSTRAINT Instractor_Belong_Ins_FK FOREIGN KEY (Ins_ID)
        REFERENCES Instructor (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Instractor_Belong_Track_FK FOREIGN KEY (Track_ID)
        REFERENCES Track (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Instractor_Belong_Intake_FK FOREIGN KEY (Intake_ID)
        REFERENCES Intake (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Instractor_Belong_Branch_ID_FK FOREIGN KEY (Branch_ID)
        REFERENCES Branch (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

---------------------- create table 16 _Belong--------------
CREATE TABLE TrainngManagerManage
(
    Trainng_mannger_ID INT,
    Intake_ID INT,
    Track_ID INT,
    Branch_ID INT,

    CONSTRAINT Trainng_mannger_mange_PK PRIMARY KEY (Trainng_mannger_ID, Intake_ID, Track_ID, Branch_ID),
    CONSTRAINT Trainng_mannger_mange_traMng_ID_FK FOREIGN KEY (Trainng_mannger_ID)
        REFERENCES TrainingManager (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Trainng_mannger_mange_Track_FK FOREIGN KEY (Track_ID)
        REFERENCES Track (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Trainng_mannger_mange_Intake_FK FOREIGN KEY (Intake_ID)
        REFERENCES Intake (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Trainng_mannger_mange_Branch_ID_FK FOREIGN KEY (Branch_ID)
        REFERENCES Branch (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);




