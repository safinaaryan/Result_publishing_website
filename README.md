**🎓 Campus Connect: Student Examination & Results Portal**
Welcome to Campus Connect! This is a full-stack, web-based examination and results portal designed to make tracking academic performance simple and efficient. Whether you are a teacher inputting grades or a student eagerly checking your annual report, this system provides a secure, seamless, and user-friendly experience.

🌟 What is this project?
At its core, Campus Connect is a complete grading ecosystem. I built this to solve the classic problem of result management in educational institutions. It features a dual-portal system:

**The Student Portal: **Allows students to securely log in and view their academic performance, including total marks, percentages, pass/fail status, and overall letter grades.

**The Teacher Portal:** Gives educators a secure environment to input, update, and manage student marks dynamically.

✨ Key Features
👨‍🎓 For Students:

**Secure Access:** Students log in using their unique Student ID and secure password validation.

**Comprehensive Results Dashboard:** Automatically calculates total marks, percentage, and assigns an overall grade (From A+ to F).

Visual Progress: Beautiful, dynamic UI elements (like animated progress bars) that make reading a report card visually appealing.

👨‍🏫 For Teachers:

Dedicated Educator Login: A separate, secure gateway for teachers to manage academic data.

Smart Data Entry: Teachers can easily submit marks for specific subjects and exam years.

On-the-Fly Record Creation: If a teacher inputs marks for a student or subject that isn't in the database yet, the system is smart enough to auto-generate those records on the fly!

🛠️ Under the Hood (System Highlights):

Real-time Validation: Live password matching and form validation on the frontend before data even hits the server.

Smooth Navigation: Single-page-application (SPA) style transitions between login screens and dashboards using pure CSS and JavaScript animations.

Secure Database Handling: Built with robust PHP and MySQL, utilizing prepared statements to prevent SQL injection and ensure data integrity.

💻 Tech Stack
Frontend: HTML5, CSS3 (Custom variables, modern typography with Google Fonts), Vanilla JavaScript.

Backend: PHP (Procedural with MySQLi).

Database: MySQL (Relational database with tables for Students, Teachers, Subjects, and Exam Results).

🚀 How to Run Locally
Clone this repository to your local machine.

Set up a local server environment (like XAMPP, WAMP, or MAMP).

Move the project folder into your server's root directory (e.g., htdocs for XAMPP).

Open your MySQL manager (like phpMyAdmin) and import the database.sql file to instantly set up the database and sample data.

Make sure your database credentials in config.php match your local setup (default is usually root with no password).

Open your browser and navigate to http://localhost/your-folder-name/index.html.
