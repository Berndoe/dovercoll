import unittest
from unittest.mock import patch, MagicMock
from flask import Flask, jsonify, request
from main import app, user_manager, waste_collector_manager


class UserTestCase(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.client = app.test_client()
        cls.client.testing = True

    def setUp(self):
        self.mock_user_ref = MagicMock()

    def test_create_user_success(self):
        with patch('firebase_admin.db.reference') as mock_db_ref:
            mock_db_ref.return_value.push.return_value = self.mock_user_ref
            self.mock_user_ref.key = 'user123'

            response = self.client.post('/users', json= {
                'uid': 'user123',
                'name': 'John Doe',
                'email': 'johndoe@example.com',
                'profile_picture': None,
                'rating': 0.0,
            }, headers={'Authorization': 'Bearer testtoken'})

            self.assertEqual(response.status_code, 201)
            self.assertEqual(response.json, {'id':'user123'})


if __name__ == '__main__':
    unittest.main()
