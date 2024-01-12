------------ create table 1  student-------------------------------
CREATE TABLE Student 
(
    ID INT PRIMARY KEY ,
    FName NVARCHAR(15) NOT NULL,
    LName NVARCHAR(15) NOT NULL,
    GraduationYear CHAR(4) NOT NULL,
    Email NVARCHAR(50) NOT NULL,
    [Password] NVARCHAR(25) NOT NULL,
    CONSTRAINT Stu_CheckEmailcheck CHECK (Email LIKE '%@gmail.com' OR Email LIKE '%@yahoo.com'),
    CONSTRAINT Stu_CheckPassword 
        CHECK ( 
            [Password] LIKE '%[A-Z]%' AND 
            [Password] LIKE '%[a-z]%' AND 
            [Password] LIKE '%[0-9]%' AND 
            LEN([Password]) >= 8 AND 
            LEN([Password]) <= 25
        )
);


---------------------create table 2  Instractor--------------------------------
CREATE TABLE Instructor 
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    FName NVARCHAR(15) NOT NULL,
    LName NVARCHAR(15) NOT NULL,
    Email NVARCHAR(50) NOT NULL,
    [Password] NVARCHAR(25) NOT NULL,
    CONSTRAINT Ins_CheckEmailcheck CHECK (Email LIKE '%@gmail.com' OR Email LIKE '%@yahoo.com'),
    CONSTRAINT Ins_CheckPassword 
        CHECK ( 
            [Password] LIKE '%[A-Z]%' AND 
            [Password] LIKE '%[a-z]%' AND 
            [Password] LIKE '%[0-9]%' AND 
            LEN([Password]) >= 8 AND 
            LEN([Password]) <= 25
        )
);


---------------------create table 3  TrainnigMannger--------------------------------
CREATE TABLE TrainingManager 
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    FName NVARCHAR(15) NOT NULL,
    LName NVARCHAR(15) NOT NULL,
    Email NVARCHAR(50) NOT NULL,
    [Password] NVARCHAR(50) NOT NULL,
    CONSTRAINT trainMag_CheckEmailcheck CHECK (Email LIKE '%@gmail.com' OR Email LIKE '%@yahoo.com'),
    CONSTRAINT trainMag_CheckPassword 
        CHECK ( 
            [Password] LIKE '%[A-Z]%' AND 
            [Password] LIKE '%[a-z]%' AND 
            [Password] LIKE '%[0-9]%' AND 
            LEN([Password]) >= 8 AND 
            LEN([Password]) <= 25
        )
);


----------------create table 4 Course-----------------------------------

CREATE TABLE Course 
(
    ID INT PRIMARY KEY ,
    [Name] NVARCHAR(50) NOT NULL,
    MinDegree INT NOT NULL,
    MaxDegree INT NOT NULL,
    [Description] NVARCHAR(MAX)
);

----------------create table 5 branch-----------------------------------

CREATE TABLE Branch 
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(50)
    -- TrainningManger_ID INT,
    -- CONSTRAINT trainningmanger_branch_fk FOREIGN KEY (TrainningManger_ID)
    -- REFERENCES TrainingManager (ID)
);


-------------------- create table 6  intake --------------------

CREATE TABLE Intake 
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(50)
);


-------------------- create table 7 track --------------------
CREATE TABLE Track 
(
    ID INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(50)
    -- InsManger_ID INT,
    -- CONSTRAINT Instructor_manage_track_fk FOREIGN KEY (InsManger_ID)
    -- REFERENCES Instructor (ID)
);


-------------------- create table 8 exam --------------------

CREATE TABLE Exam
(
    ID INT PRIMARY KEY ,
    NumberOfQuestions INT NOT NULL,
    StartTime DATETIME,
    EndTime DATETIME,
    TotalTime AS DATEDIFF(MINUTE, StartTime, EndTime),
    TotalDegree INT,
    Corrective BIT NOT NULL,
    Normal BIT NOT NULL,
);

--IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Exam' AND COLUMN_NAME = 'TotalTime')
--BEGIN
--    ALTER TABLE Exam
--    DROP COLUMN TotalTime;
--END

---- Alter the data type of StartTime and EndTime columns
--ALTER TABLE Exam
----ALTER COLUMN StartTime DATETIME,
--ALTER COLUMN EndTime DATETIME;

---- Recreate the TotalTime column with the new data types
--ALTER TABLE Exam
--ADD TotalTime AS DATEDIFF(MINUTE, StartTime, EndTime);
-------------------- create table 9 Question --------------------

CREATE TABLE Question
(
    [Questions_ID] INT ,
    [Text_Questions] NVARCHAR(MAX) NULL,
    [Correct_Answer_Text_Questions] NVARCHAR(MAX) NULL,
    [True_or_False_Questions] NVARCHAR(MAX) NULL,
    [Correct_Answer_True_or_False] BIT NULL,
    [Choose_An_Answer_Question] NVARCHAR(MAX) NULL,
    [Correct_Answer_Choose_Question] NVARCHAR(1) NULL,
    [Course_Id] INT NULL,
    
    CONSTRAINT Question_PK PRIMARY KEY (Questions_ID),
    CONSTRAINT fk_Course FOREIGN KEY (Course_Id) REFERENCES dbo.Course(ID)
);

-------------------- create table 10 student_Exam_Question --------------------
CREATE TABLE StudentExamQuestions
(
		[Std_ID] [int] NOT NULL,
	[Exam_ID] [int] NOT NULL,
	[Questions_result] [int] NULL,
	[Std_Answer_Text_Question] [nvarchar](max) NOT NULL,
	[Std_Answer_Choose_Question] [nvarchar](1) NOT NULL,
	[Std_Answer_True_or_False] [nvarchar](5)NOT NULL,
	[Questions_Id] [int] NOT NULL,
	
	    CONSTRAINT StudentExam_PK PRIMARY KEY (Std_ID, Exam_ID,Questions_Id),
    CONSTRAINT Student_Exam_Student_FK FOREIGN KEY (Std_ID)
        REFERENCES Student(ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Student_Exam_Exam_FK FOREIGN KEY (Exam_ID)
        REFERENCES Exam(ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT Student_Exam_question_FK FOREIGN KEY (Questions_Id)
        REFERENCES Question(Questions_ID)
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
-------------------- create table 12 InstructorCourse--------------------
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
---------------------- create table 13 student_registration--------------
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

---------------------- create table 14 Instractor_Belong--------------
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

---------------------- create table 15 TrainngManagerManage--------------
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
create table CourseExam
(
   Course_ID int,
   Exam_ID int,
    CONSTRAINT CourseExam_PK PRIMARY KEY (Course_ID ,Exam_ID),
    CONSTRAINT CourseExam_Course_FK FOREIGN KEY (Course_ID)
        REFERENCES Course (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT CourseExam_Exam_FK FOREIGN KEY (Exam_ID)
        REFERENCES Exam (ID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
--------------------------- create table 16 ExamQuestion --------------------

CREATE TABLE ExamQuestion
(
	Exam_ID int,
	Question_ID int,
	QuestionType char(4) check (QuestionType in ('TF','MCQ','Text')),
	QuestionGrade int,
	CONSTRAINT ExamQuestion_PK PRIMARY KEY (Exam_ID, Question_ID),
	CONSTRAINT ExamQuestion_Question_FK FOREIGN KEY (Question_ID)
		REFERENCES Question (Questions_ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT ExamQuestion_Exam_FK FOREIGN KEY (Exam_ID)
		REFERENCES Exam (ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);
--------------------------- create table 17 StudentExam --------------------

create table StudentExam
(
	Student_ID int,
	Exam_ID int,
	CONSTRAINT StudentExamT_PK PRIMARY KEY (Student_ID, Exam_ID),
	CONSTRAINT StudentExam_Student_FK FOREIGN KEY (Student_ID)
		REFERENCES Question (Questions_ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT ExamQuestionT_Exam_FK FOREIGN KEY (Exam_ID)
		REFERENCES Exam (ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);


