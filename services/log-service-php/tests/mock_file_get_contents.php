<?php

namespace Calculator\LogService\Tests;

/**
 * Mock function to override file_get_contents when reading from php://input
 */
function file_get_contents($filename)
{
    if ($filename === 'php://input') {
        return $GLOBALS['HTTP_RAW_POST_DATA'] ?? '';
    }
    
    return \file_get_contents($filename);
}