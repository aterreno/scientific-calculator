import unittest
import json
import sys
import os

# Add the parent directory to the path so we can import the app module
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from app import app


class MultiplicationServiceTestCase(unittest.TestCase):

    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_health_check(self):
        """Test the health check endpoint"""
        response = self.app.get('/health')
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data['status'], 'healthy')

    def test_multiply_basic(self):
        """Test basic multiplication"""
        response = self.app.post(
            '/multiply',
            data=json.dumps({'a': 5, 'b': 3}),
            content_type='application/json'
        )
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data['result'], 15)

    def test_multiply_negative(self):
        """Test multiplication with negative numbers"""
        response = self.app.post(
            '/multiply',
            data=json.dumps({'a': -5, 'b': 3}),
            content_type='application/json'
        )
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data['result'], -15)

    def test_multiply_zero(self):
        """Test multiplication with zero"""
        response = self.app.post(
            '/multiply',
            data=json.dumps({'a': 5, 'b': 0}),
            content_type='application/json'
        )
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 200)
        self.assertEqual(data['result'], 0)

    def test_multiply_decimal(self):
        """Test multiplication with decimal numbers"""
        response = self.app.post(
            '/multiply',
            data=json.dumps({'a': 5.5, 'b': 3.3}),
            content_type='application/json'
        )
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 200)
        self.assertAlmostEqual(data['result'], 18.15, places=2)

    def test_missing_parameters(self):
        """Test error handling with missing parameters"""
        response = self.app.post(
            '/multiply',
            data=json.dumps({'a': 5}),  # Missing 'b'
            content_type='application/json'
        )
        data = json.loads(response.data)
        
        self.assertEqual(response.status_code, 400)
        self.assertIn('error', data)


if __name__ == '__main__':
    unittest.main()