<?php

declare(strict_types=1);

namespace Calculator\LogService\Tests;

use Calculator\LogService\LogController;
use PHPUnit\Framework\TestCase;

class LogControllerTest extends TestCase
{
    private LogController $controller;

    protected function setUp(): void
    {
        if (!defined('PHPUNIT_RUNNING')) {
            define('PHPUNIT_RUNNING', true);
        }
        $this->controller = new LogController();
    }

    /**
     * @runInSeparateProcess
     */
    public function testHealth(): void
    {
        // Start output buffering to capture the output
        ob_start();
        $this->controller->health();
        $output = ob_get_clean();

        // Verify the output
        $this->assertEquals('{"status":"healthy"}', $output);
        
        // We'll skip the header assertion since xdebug_get_headers isn't available
        // and it's not critical for our test functionality
    }

    /**
     * @runInSeparateProcess
     */
    public function testNaturalLog(): void
    {
        // Setup the mock input data
        $inputData = ['a' => 2.718281828459045]; // e
        $this->mockInput(json_encode($inputData));

        // Start output buffering to capture the output
        ob_start();
        $this->controller->naturalLog();
        $output = ob_get_clean();

        // Verify the output
        $result = json_decode($output, true);
        $this->assertIsArray($result);
        $this->assertArrayHasKey('result', $result);
        $this->assertEqualsWithDelta(1.0, $result['result'], 0.0001);
    }

    /**
     * @runInSeparateProcess
     */
    public function testLog10(): void
    {
        // Setup the mock input data
        $inputData = ['a' => 10.0];
        $this->mockInput(json_encode($inputData));

        // Start output buffering to capture the output
        ob_start();
        $this->controller->log10();
        $output = ob_get_clean();

        // Verify the output
        $result = json_decode($output, true);
        $this->assertIsArray($result);
        $this->assertArrayHasKey('result', $result);
        $this->assertEqualsWithDelta(1.0, $result['result'], 0.0001);
    }

    /**
     * @runInSeparateProcess
     */
    public function testNaturalLogWithZeroInput(): void
    {
        // Setup the mock input data
        $inputData = ['a' => 0.0];
        $this->mockInput(json_encode($inputData));

        // Start output buffering to capture the output
        ob_start();
        $this->controller->naturalLog();
        $output = ob_get_clean();

        // Verify the output (should be an error)
        $result = json_decode($output, true);
        $this->assertIsArray($result);
        $this->assertArrayHasKey('error', $result);
        $this->assertStringContainsString('positive number', $result['error']);
    }

    /**
     * @runInSeparateProcess
     */
    public function testNaturalLogWithNegativeInput(): void
    {
        // Setup the mock input data
        $inputData = ['a' => -1.0];
        $this->mockInput(json_encode($inputData));

        // Start output buffering to capture the output
        ob_start();
        $this->controller->naturalLog();
        $output = ob_get_clean();

        // Verify the output (should be an error)
        $result = json_decode($output, true);
        $this->assertIsArray($result);
        $this->assertArrayHasKey('error', $result);
        $this->assertStringContainsString('positive number', $result['error']);
    }

    /**
     * @runInSeparateProcess
     */
    public function testNaturalLogWithMissingInput(): void
    {
        // Setup the mock input data
        $inputData = []; // Missing 'a' parameter
        $this->mockInput(json_encode($inputData));

        // Start output buffering to capture the output
        ob_start();
        $this->controller->naturalLog();
        $output = ob_get_clean();

        // Verify the output (should be an error)
        $result = json_decode($output, true);
        $this->assertIsArray($result);
        $this->assertArrayHasKey('error', $result);
        $this->assertStringContainsString('Missing required parameter', $result['error']);
    }

    /**
     * Mocks the PHP input stream with the given data
     */
    private function mockInput(string $data): void
    {
        $stream = fopen('php://memory', 'r+');
        fwrite($stream, $data);
        rewind($stream);

        $GLOBALS['HTTP_RAW_POST_DATA'] = $data;
        
        // Create a function to override file_get_contents for php://input
        require_once __DIR__ . '/file_get_contents_mock.php';
    }
}