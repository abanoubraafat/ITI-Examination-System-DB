-- Index for frequently used columns in StudentCourse table
CREATE INDEX IX_StudentCourse_Std_ID_Course_ID ON StudentCourse (Std_ID DESC, Course_ID DESC);

Select Std_ID, Course_ID From StudentCourse