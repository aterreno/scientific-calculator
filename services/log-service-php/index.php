<?php

declare(strict_types=1);

require_once __DIR__ . '/vendor/autoload.php';

use Calculator\LogService\LogController;

// Configure error reporting
error_reporting(E_ALL);
ini_set('display_errors', '1');

// Parse request URI and method
$uri = parse_url($_SERVER['REQUEST_URI'])['path'] ?? '/';
$method = $_SERVER['REQUEST_METHOD'];

// Create controller
$controller = new LogController();

// Simple router
if ($method === 'GET' && $uri === '/health') {
    $controller->health();
} elseif ($method === 'POST' && $uri === '/log') {
    $controller->naturalLog();
} elseif ($method === 'POST' && $uri === '/log10') {
    $controller->log10();
} elseif ($method === 'POST' && $uri === '/ln') {
    $controller->naturalLog();
} else {
    // Not found
    header('Content-Type: application/json');
    http_response_code(404);
    echo json_encode(['error' => 'Not found']);
}