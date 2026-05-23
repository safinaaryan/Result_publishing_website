<?php
// ============================================
// teacher_login.php — Teacher Authentication Handler
// ============================================

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Invalid request method.']);
    exit();
}

$teacher_id = trim($_POST['teacher_id'] ?? '');
$password   = trim($_POST['password']   ?? '');
$confirm_pw = trim($_POST['confirm_password'] ?? '');

if (empty($teacher_id) || empty($password) || empty($confirm_pw)) {
    echo json_encode(['success' => false, 'message' => 'All validation input fields are required.']);
    exit();
}

if ($password !== $confirm_pw) {
    echo json_encode(['success' => false, 'message' => 'Your typed configuration passwords do not match.']);
    exit();
}

$conn = getConnection();

$stmt = $conn->prepare("SELECT teacher_id, full_name, password FROM teachers WHERE teacher_id = ?");
$stmt->bind_param('s', $teacher_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(['success' => false, 'message' => 'Teacher identifier key code not found.']);
    $stmt->close();
    $conn->close();
    exit();
}

$teacher = $result->fetch_assoc();
$stmt->close();

if ($password !== $teacher['password']) {
    echo json_encode(['success' => false, 'message' => 'Invalid password verification entry.']);
    $conn->close();
    exit();
}

$conn->close();

echo json_encode([
    'success' => true,
    'teacher' => [
        'id'   => $teacher['teacher_id'],
        'name' => $teacher['full_name']
    ]
]);
?>