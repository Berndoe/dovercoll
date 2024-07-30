import unittest
import requests
import json

BASE_URL = "http://127.0.0.1:5000"

class CollectorTestCases(unittest.TestCase):

    def test_register_collector(self):
        url = f"{BASE_URL}/collectors"
        payload = {
            "email": "testcollector@example.com",
            "password": "password123",
            "name": "Test Collector"
        }
        response = requests.post(url, json=payload)
        self.assertIn(response.status_code, [201, 400])

    def test_get_collectors(self):
        url = f"{BASE_URL}/collectors"
        response = requests.get(url)
        self.assertIn(response.status_code, [200, 400])

    def test_get_collector(self):
        collector_id = "sample_collector_id"
        url = f"{BASE_URL}/collectors/{collector_id}"
        response = requests.get(url)
        self.assertIn(response.status_code, [200, 404])

    def test_update_collector(self):
        collector_id = "sample_collector_id"
        url = f"{BASE_URL}/collectors/{collector_id}"
        payload = {
            "name": "Updated Collector"
        }
        response = requests.put(url, json=payload)
        self.assertIn(response.status_code, [200, 404])

    def test_delete_collector(self):
        collector_id = "sample_collector_id"
        url = f"{BASE_URL}/collectors/{collector_id}"
        response = requests.delete(url)
        self.assertIn(response.status_code, [200, 404])

    def test_upload_collector_picture(self):
        collector_id = "az9PK12EPhMRz99Yvl8xHbKoxBH2"
        url = f"{BASE_URL}/collectors/{collector_id}/profile_picture"
        with open('dovercoll.jpg', 'rb') as image_file:
            files = {'image': image_file}
            response = requests.post(url, files=files)
        self.assertIn(response.status_code, [200, 400])

    def test_collector_response(self):
        url = f"{BASE_URL}/collectors/respond"
        payload = {
             "booking_id": "f8300cb8-58fd-4399-bc36-b1428c79ac88",
             "collector_id": "az9PK12EPhMRz99Yvl8xHbKoxBH2"
        }
        response = requests.post(url, json=payload)
        self.assertIn(response.status_code, [201, 400, 404])

    def test_view_history_collector(self):
        collector_id = "sample_collector_id"
        url = f"{BASE_URL}/collectors/{collector_id}/history"
        response = requests.get(url)
        self.assertIn(response.status_code, [200, 400])

if __name__ == "__main__":
    suite = unittest.TestSuite()
    loader = unittest.TestLoader()
    suite.addTests(loader.loadTestsFromTestCase(CollectorTestCases))
    runner = unittest.TextTestRunner()
    runner.run(suite)
