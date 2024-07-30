import unittest
import requests

BASE_URL = "http://127.0.0.1:5000"

class UserTestCases(unittest.TestCase):

    def test_register_user(self):
        url = f"{BASE_URL}/users"
        payload = {
            "email": "testuser@example.com",
            "password": "password123",
            "name": "Test User"
        }
        response = requests.post(url, json=payload)
        self.assertIn(response.status_code, [201, 400])

    def test_get_users(self):
        url = f"{BASE_URL}/users"
        response = requests.get(url)
        self.assertIn(response.status_code, [200, 400])

    def test_get_user(self):
        user_id = "sample_user_id"
        url = f"{BASE_URL}/users/{user_id}"
        response = requests.get(url)
        self.assertIn(response.status_code, [200, 404])

    def test_update_user(self):
        user_id = "sample_user_id"
        url = f"{BASE_URL}/users/{user_id}"
        payload = {
            "name": "Updated User"
        }
        response = requests.put(url, json=payload)
        self.assertIn(response.status_code, [200, 404])

    def test_delete_user(self):
        user_id = "sample_user_id"
        url = f"{BASE_URL}/users/{user_id}"
        response = requests.delete(url)
        self.assertIn(response.status_code, [200, 404])

    def test_upload_user_picture(self):
        user_id = "sample_user_id"
        url = f"{BASE_URL}/users/{user_id}/profile_picture"
        with open('dovercoll.jpg', 'rb') as image_file:
            files = {'image': image_file}
            response = requests.post(url, files=files)
        self.assertIn(response.status_code, [200, 400])

    def test_order_collection_service(self):
        url = f"{BASE_URL}/users/booking"
        payload = {
            "user_id": "sample_user_id",
            "pickup_location": {"latitude": 5.6037, "longitude": -0.1870},
            "number_of_bins": 2
        }
        response = requests.post(url, json=payload)
        self.assertIn(response.status_code, [201, 400, 404])

    def test_get_collection_service(self):
        booking_id = "sample_booking_id"
        url = f"{BASE_URL}/users/booking/{booking_id}"
        response = requests.get(url)
        self.assertIn(response.status_code, [200, 404])

    def test_modify_collection_service(self):
        booking_id = "sample_booking_id"
        url = f"{BASE_URL}/users/booking/{booking_id}"
        payload = {
            "number_of_bins": 3
        }
        response = requests.put(url, json=payload)
        self.assertIn(response.status_code, [200, 404])

    def test_cancel_collection_service(self):
        booking_id = "sample_booking_id"
        url = f"{BASE_URL}/users/booking/{booking_id}"
        response = requests.delete(url)
        self.assertIn(response.status_code, [200, 404])

    def test_receive_bin_data(self):
        url = f"{BASE_URL}/retrieve_bin_status"
        payload = {
            "fill_percentage": 75
        }
        response = requests.post(url, json=payload)
        self.assertIn(response.status_code, [200, 400])

    def test_get_bin_data(self):
        url = f"{BASE_URL}/get_bin_data"
        response = requests.get(url)
        self.assertIn(response.status_code, [200, 400])

    def test_add_waste_practice_video(self):
        url = f"{BASE_URL}/practices"
        payload = {
            "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        }
        response = requests.post(url, json=payload)
        self.assertIn(response.status_code, [201, 400])

    def test_get_waste_practices(self):
        url = f"{BASE_URL}/practices"
        response = requests.get(url)
        self.assertIn(response.status_code, [200, 404])

    def test_view_history_user(self):
        user_id = "E5ZIRRES8yQBB0tYxYgf4xH561z1"
        url = f"{BASE_URL}/users/{user_id}/history"
        response = requests.get(url)
        self.assertIn(response.status_code, [200, 400])

    def test_send_message(self):
        url = f"{BASE_URL}/notifications/sms"
        payload = {
            "phone_number": "0208915108"
        }
        response = requests.post(url, json=payload)
        self.assertIn(response.status_code, [201, 400])

if __name__ == "__main__":
    suite = unittest.TestSuite()
    loader = unittest.TestLoader()
    suite.addTests(loader.loadTestsFromTestCase(UserTestCases))
    runner = unittest.TextTestRunner()
    runner.run(suite)
