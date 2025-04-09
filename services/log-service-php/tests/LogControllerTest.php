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
        $this->controller = new LogController();
    }

    /**
     * @runInSeparateProcess
     */
    public function testHealth(): void
    {
        ob_start();
        $this->controller->health();
        $output = ob_get_clean();

        $this->assertEquals('{"status":"healthy"}', $output);
    }

    /**
     * @runInSeparateProcess
     */
    public function testNaturalLog(): void
    {
        $_SERVER['CONTENT_TYPE'] = 'application/json';
        $_SERVER['HTTP_CONTENT_TYPE'] = 'application/json';

        // Mock the input stream
        $this->mockInputData(['a' => 2.718281828459045]);

        ob_start();
        $this->controller->naturalLog();
        $output = ob_get_clean();

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
        $_SERVER['CONTENT_TYPE'] = 'application/json';
        $_SERVER['HTTP_CONTENT_TYPE'] = 'application/json';

        // Mock the input stream
        $this->mockInputData(['a' => 100]);

        ob_start();
        $this->controller->log10();
        $output = ob_get_clean();

        $result = json_decode($output, true);
        $this->assertIsArray($result);
        $this->assertArrayHasKey('result', $result);
        $this->assertEqualsWithDelta(2.0, $result['result'], 0.0001);
    }

    /**
     * @runInSeparateProcess
     */
    public function testLogWithNegativeInput(): void
    {
        $_SERVER['CONTENT_TYPE'] = 'application/json';
        $_SERVER['HTTP_CONTENT_TYPE'] = 'application/json';

        // Mock the input stream
        $this->mockInputData(['a' => -1]);

        ob_start();
        $this->controller->naturalLog();
        $output = ob_get_clean();

        $result = json_decode($output, true);
        $this->assertIsArray($result);
        $this->assertArrayHasKey('error', $result);
        $this->assertStringContainsString('positive number', $result['error']);
    }

    /**
     * @runInSeparateProcess
     */
    public function testLogWithMissingInput(): void
    {
        $_SERVER['CONTENT_TYPE'] = 'application/json';
        $_SERVER['HTTP_CONTENT_TYPE'] = 'application/json';

        // Mock the input stream with missing 'a' parameter
        $this->mockInputData([]);

        ob_start();
        $this->controller->naturalLog();
        $output = ob_get_clean();

        $result = json_decode($output, true);
        $this->assertIsArray($result);
        $this->assertArrayHasKey('error', $result);
        $this->assertStringContainsString('Missing required parameter', $result['error']);
    }

    private function mockInputData(array $data): void
    {
        $json = json_encode($data);

        // Create a temporary stream
        $stream = fopen('php://memory', 'r+');
        fwrite($stream, $json);
        rewind($stream);

        // Mock the php://input stream
        $GLOBALS['HTTP_RAW_POST_DATA'] = $json;
        
        // Create a function to override file_get_contents for php://input
        require_once __DIR__ . '/mock_file_get_contents.php';
    }
}