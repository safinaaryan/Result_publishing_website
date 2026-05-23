<?php
// ============================================
// login.php — Login & Result Fetch Handler
// ============================================

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once 'config.php';

// Only accept POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Invalid request method.']);
    exit();
}

// Sanitize inputs
$student_id = trim($_POST['student_id'] ?? '');
$password   = trim($_POST['password']   ?? '');
$confirm_pw = trim($_POST['confirm_password'] ?? '');

// Basic validation
if (empty($student_id) || empty($password) || empty($confirm_pw)) {
    echo json_encode(['success' => false, 'message' => 'All fields are required.']);
    exit();
}

if ($password !== $confirm_pw) {
    echo json_encode(['success' => false, 'message' => 'Passwords do not match. Please re-enter.']);
    exit();
}

if (strlen($student_id) < 3) {
    echo json_encode(['success' => false, 'message' => 'Invalid Student ID format.']);
    exit();
}

// Connect to DB
$conn = getConnection();

// Look up student (use password_verify() if passwords are hashed)
$stmt = $conn->prepare(
    "SELECT student_id, full_name, class, section, password
     FROM students
     WHERE student_id = ?"
);
$stmt->bind_param('s', $student_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(['success' => false, 'message' => 'Student ID not found.']);
    $stmt->close();
    $conn->close();
    exit();
}

$student = $result->fetch_assoc();
$stmt->close();

// Verify password
// In production use: password_verify($password, $student['password'])
if ($password !== $student['password']) {
    echo json_encode(['success' => false, 'message' => 'Incorrect password.']);
    $conn->close();
    exit();
}

// Fetch exam results with subject details
$stmt2 = $conn->prepare(
    "SELECT s.subject_name, s.subject_code, s.full_marks, s.pass_marks,
            r.marks_obtained, r.grade, r.exam_year
     FROM exam_results r
     JOIN subjects s ON r.subject_code = s.subject_code
     WHERE r.student_id = ?
     ORDER BY s.subject_name"
);
$stmt2->bind_param('s', $student_id);
$stmt2->execute();
$res2 = $stmt2->get_result();

$results = [];
$total_obtained = 0;
$total_full     = 0;
$failed         = false;

while ($row = $res2->fetch_assoc()) {
    $results[] = $row;
    $total_obtained += (int)$row['marks_obtained'];
    $total_full     += (int)$row['full_marks'];
    if ((int)$row['marks_obtained'] < (int)$row['pass_marks']) {
        $failed = true;
    }
}
$stmt2->close();
$conn->close();

// Calculate percentage and overall result
$percentage   = $total_full > 0 ? round(($total_obtained / $total_full) * 100, 2) : 0;
$overall_pass = !$failed && count($results) > 0;

// Determine overall grade
if ($percentage >= 80)      $overall_grade = 'A+';
elseif ($percentage >= 70)  $overall_grade = 'A';
elseif ($percentage >= 60)  $overall_grade = 'B+';
elseif ($percentage >= 50)  $overall_grade = 'B';
elseif ($percentage >= 40)  $overall_grade = 'C';
elseif ($percentage >= 33)  $overall_grade = 'D';
else                        $overall_grade = 'F';

echo json_encode([
    'success'       => true,
    'student'       => [
        'id'      => $student['student_id'],
        'name'    => $student['full_name'],
        'class'   => $student['class'],
        'section' => $student['section'],
    ],
    'results'         => $results,
    'total_obtained'  => $total_obtained,
    'total_full'      => $total_full,
    'percentage'      => $percentage,
    'overall_grade'   => $overall_grade,
    'overall_result'  => $overall_pass ? 'PASSED' : 'FAILED',
    'exam_year'       => !empty($results) ? $results[0]['exam_year'] : date('Y'),
]);
?>
