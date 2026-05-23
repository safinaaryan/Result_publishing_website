<?php
define('DB_HOST',     'localhost');
define('DB_USER',     'root');       // your MySQL username
define('DB_PASS',     '');           // your MySQL password
define('DB_NAME',     'student_portal');

// Create connection
function getConnection() {
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

    if ($conn->connect_error) {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Database connection failed.']);
        exit();
    }

    $conn->set_charset('utf8mb4');
    return $conn;
}
?>
