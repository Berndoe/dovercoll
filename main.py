"""
Author: Bernd Opoku-Boadu
"""
from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials
from flask_cors import CORS

from classes.firebase_user_manager import FirebaseManager

# initialise flask app
app = Flask(__name__)
CORS(app)
# initialise firebase admin sdk
cred = credentials.Certificate('dovercoll_key.json')
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://dovercoll-623b6-default-rtdb.firebaseio.com/',
    'storageBucket': 'dovercoll-623b6.appspot.com'
})

# instantiate firebase manager for users and waste collectors
user_manager = FirebaseManager('users')
waste_collector_manager = FirebaseManager('collectors')

# register stores password


@app.route('/users', methods=['POST'])
def register_user():
    user_data = request.json
    email = user_data.get('email')
    password = user_data.get('password')

    if not email or not password:
        return jsonify({'error': 'Email and password are required'}), 400
    user_id = user_manager.register(email, password, user_data)

    if 'error' in user_id:
        return jsonify({'error': user_id['error']}), 400
    return jsonify({
        "user": user_id
    }), 201


@app.route('/collectors', methods=['POST'])
def register_collector():
    collector_data = request.json
    email = collector_data.get('email')
    password = collector_data.get('password')

    if not email or not password:
        return jsonify({'error': 'Email and password are required'}), 400

    collector_id = waste_collector_manager.register(email, password, collector_data)

    if 'error' in collector_id:
        return jsonify({'error': collector_id['error']}), 400
    return jsonify({
        "id": collector_id
    }), 201


@app.route('/users', methods=['GET'])
def get_users():
    user_data = user_manager.get()
    return jsonify({
        "users": user_data
    }), 200


@app.route('/collectors', methods=['GET'])
def get_collectors():
    user_data = user_manager.get()
    return jsonify({
        "collectors": user_data
    }), 200


@app.route('/users/<uid>', methods=['GET'])
def get_user(uid):
    user = user_manager.get_user(uid)

    if user:
        return jsonify(user), 200
    else:
        return jsonify({"error": "User not found"}), 404


@app.route('/collectors/<cid>', methods=['GET'])
def get_collector(cid):
    collector = waste_collector_manager.get_user(cid)

    if collector:
        return jsonify(collector), 200
    else:
        return jsonify({"error": "User not found"}), 404


@app.route('/users/<uid>', methods=['PUT'])
def update_user(uid):
    user_data = request.json
    if user_manager.update(uid, user_data):
        return jsonify({"message": "User updated successfully"}), 200
    else:
        return jsonify({"message": "User not found"}), 404


@app.route('/collectors/<cid>', methods=['PUT'])
def update_collector(cid):
    user_data = request.json
    if user_manager.update(cid, user_data):
        return jsonify({"message": "Collector updated successfully"}), 200
    else:
        return jsonify({"message": "Collector not found"}), 404


@app.route('/users/<uid>', methods=['DELETE'])
def delete_user(uid):
    if user_manager.remove(uid):
        return jsonify({"message": "User deleted successfully"}), 200
    return jsonify({"message": "User not found"}), 404


@app.route('/collectors/<cid>', methods=['DELETE'])
def delete_collector(cid):
    if waste_collector_manager.remove(cid):
        return jsonify({"message": "Collector deleted successfully"}), 200
    return jsonify({"message": "Collector not found"}), 404


@app.route('/users/<uid>/profile_picture', methods=['POST'])
def upload_user_picture(uid):
    if 'image' not in request.files:
        return jsonify({"error": "No file part"}), 400

    image = request.files['image']
    if image.filename == '':
        return jsonify({"error": "No selected file"}), 400

    image_url = user_manager.upload_picture(uid, image)
    return jsonify({"url": image_url}), 200


@app.route('/collectors/<cid>/profile_picture', methods=['POST'])
def upload_collector_picture(cid):
    if 'image' not in request.files:
        return jsonify({"error": "No file part"}), 400

    image = request.files['image']
    if image.filename == '':
        return jsonify({"error": "No selected file"}), 400

    image_url = waste_collector_manager.upload_picture(cid, image)
    return jsonify({"url": image_url}), 200


@app.route('/booking', methods=['POST'])
def order_collection_service():
    booking_data = request.json
    booking_id = user_manager.create_booking(booking_data)
    return jsonify({"booking_id": booking_id}), 201


@app.route('/booking/<bid>', methods=['GET'])
def get_booking(bid):
    booking = user_manager.get_booking(bid)

    if booking:
        return jsonify({"booking": booking}), 200

    return jsonify({"message": "Booking not found"}), 404


@app.route('/booking/<bid>', methods=['PUT'])
def modify_collection_service(bid):
    booking_data = request.json
    if user_manager.update_booking(bid, booking_data):
        return jsonify({"message": "Booking updated successfully"}), 200
    return jsonify({"message": "Booking not found"})


@app.route('/bin', methods=['GET'])
def calculate_bin_level():
    return jsonify({"bin_level": 134}), 200


@app.route('/booking/<bid>', methods=['DELETE'])
def cancel_collection_service(bid):
    if user_manager.cancel_booking(bid):
        return jsonify({"message": "Booking cancelled"}), 200
    return jsonify({"message": "Booking not found"}), 404


@app.route('/history', methods=['GET'])
def view_history():
    return jsonify({"history": 1}), 200


if __name__ == '__main__':
    app.run(debug=True)

