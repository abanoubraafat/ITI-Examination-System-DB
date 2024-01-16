# ITI-Examination-System-DB
This is our implementation for a project simulating the Information Technology Institute (ITI) Examination System Database using (Microsoft sql server).
The project consists of different entities
(exam, instructor creating the exam, student, course, branch, intake, track, question pool ….etc) that we tried to map with the most effective way to serve our goal.
<ul>
  <li>The institution has many branches each has one or more managers and a number of intakes over the year each has some tracks taught in it.</li>
  <li>Our main focus in this project was how the instructor creates an exam for his courses whether by providing the system by the number of questions/grades he want for the exam to have then the system choose that number of questions(MCQ, T/F and text) specific to his course randomly from a question pool that contains all courses’ questions, or he can specify/add manually what questions should the exam have from the pool.</li>
  <li>Then we focused on how the student can insert his answers of that specific exam. And finally on how the student answer for that exam is graded and finding whether he passed the test or not.</li>
  <li>Training manager also can administrate the branch he manage, its trackes and intakes by different capabilities.</li>
</ul>
We used many sql server objects that helped us through our implementation such as : procedures, views, triggers, indexes. (We made as many validations as we could for every user input for each procedure we created). We also applied the concept of file groups to our database, we also created a full back to our database objects and data that happens twice a day and we created 4 accounts with different levels of accessibility and permissions on our database objects to add more security to our database.
