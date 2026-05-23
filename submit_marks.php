<?php
// ============================================
// submit_marks.php — Direct Database Entry Controller
// ============================================

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Invalid server routing protocol.']);
    exit();
}

// 1. Catch ALL the variables sent from JavaScript
$student_id     = trim($_POST['student_id'] ?? '');
$student_name   = trim($_POST['student_name'] ?? '');
$student_class  = trim($_POST['student_class'] ?? '');
$subject_code   = trim($_POST['subject_code'] ?? '');
$marks_obtained = trim($_POST['marks_obtained'] ?? '');
$grade          = trim($_POST['grade'] ?? '');
$exam_year      = trim($_POST['exam_year'] ?? '');

// 2. Validate everything is filled out
if (empty($student_id) || empty($student_name) || empty($student_class) || empty($subject_code) || $marks_obtained === '' || empty($grade) || empty($exam_year)) {
    echo json_encode(['success' => false, 'message' => 'All fields, including Name and Class, are required.']);
    exit();
}

$conn = getConnection();

// 3. Check if the Student ID exists. If NOT, create it using the real Name and Class!
$check_stu = $conn->prepare("SELECT student_id FROM students WHERE student_id = ?");
$check_stu->bind_param('s', $student_id);
$check_stu->execute();
$res_stu = $check_stu->get_result();

if ($res_stu->num_rows === 0) {
    // Insert the actual name and class instead of the placeholder data
    $ins_stu = $conn->prepare("INSERT INTO students (student_id, full_name, class, section, password) VALUES (?, ?, ?, 'A', 'pass1234')");
    $ins_stu->bind_param('sss', $student_id, $student_name, $student_class);
    $ins_stu->execute();
    $ins_stu->close();
}
$check_stu->close();

// 4. Check if the Subject Code exists. If NOT, create it on the fly.
$check_sub = $conn->prepare("SELECT subject_code FROM subjects WHERE subject_code = ?");
$check_sub->bind_param('s', $subject_code);
$check_sub->execute();
$res_sub = $check_sub->get_result();

if ($res_sub->num_rows === 0) {
    $ins_sub = $conn->prepare("INSERT INTO subjects (subject_code, subject_name, full_marks, pass_marks) VALUES (?, ?, 100, 33)");
    $default_sub_name = "Course " . $subject_code;
    $ins_sub->bind_param('ss', $subject_code, $default_sub_name);
    $ins_sub->execute();
    $ins_sub->close();
}
$check_sub->close();

// 5. Upsert into exam_results (Insert new marks row or Update existing one)
$stmt = $conn->prepare("INSERT INTO exam_results (student_id, subject_code, marks_obtained, grade, exam_year) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE marks_obtained = ?, grade = ?");
$stmt->bind_param('sssssss', $student_id, $subject_code, $marks_obtained, $grade, $exam_year, $marks_obtained, $grade);

if ($stmt->execute()) {
    echo json_encode(['success' => true, 'message' => 'Database successfully committed changes.']);
} else {
    echo json_encode(['success' => false, 'message' => 'Failed to commit changes due to database constraints.']);
}

$stmt->close();
$conn->close();
?>