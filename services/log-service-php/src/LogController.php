<?php

declare(strict_types=1);

namespace Calculator\LogService;

class LogController
{
    public function __construct()
    {
        // Constructor
    }

    public function health(): void
    {
        header('Content-Type: application/json');
        echo json_encode(['status' => 'healthy']);
    }

    public function naturalLog(): void
    {
        $this->handleLogRequest(function ($a) {
            return log($a);
        }, 'Natural Log');
    }

    public function log10(): void
    {
        $this->handleLogRequest(function ($a) {
            return log10($a);
        }, 'Log10');
    }

    private function handleLogRequest(callable $logFunction, string $operationType): void
    {
        header('Content-Type: application/json');
        
        // Get and decode the request body
        $data = json_decode(file_get_contents('php://input'), true);
        
        if (!isset($data['a'])) {
            http_response_code(400);
            echo json_encode(['error' => 'Missing required parameter: a']);
            return;
        }
        
        $a = (float) $data['a'];
        
        if ($a <= 0) {
            http_response_code(400);
            echo json_encode(['error' => 'Invalid input: logarithm requires a positive number']);
            return;
        }
        
        $result = $logFunction($a);
        
        // Log message but suppress for testing
        if (!defined('PHPUNIT_RUNNING')) {
            error_log("$operationType: $a = $result");
        }
        
        echo json_encode(['result' => $result]);
    }
}