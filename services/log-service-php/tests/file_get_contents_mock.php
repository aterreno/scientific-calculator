<?php

namespace Calculator\LogService;

/**
 * Mock function to override file_get_contents when reading from php://input
 * 
 * This function overrides the one in the Calculator\LogService namespace,
 * which is where LogController looks for file_get_contents
 */
function file_get_contents($filename)
{
    if ($filename === 'php://input') {
        return $GLOBALS['HTTP_RAW_POST_DATA'] ?? '';
    }
    
    return \file_get_contents($filename);
}