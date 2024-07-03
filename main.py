"""
Author: Bernd Opoku-Boadu
"""
import datetime

from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, db
from flask_cors import CORS
from classes.firebase_user_manager import FirebaseManager
from geopy.distance import geodesic


# initialise flask app
app = Flask(__name__)
CORS(app)
# initialise firebase admin sdk
cred = credentials.Certificate('dovercoll_key.json')
firebase_admin.initialize_app(cred, {
    
})

# instantiate firebase manager for users and waste collectors
user_manager = FirebaseManager('users')
waste_collector_manager = FirebaseManager('collectors')

MAX_DISTANCE_KM = 15
PRICE = 20
DISCOUNT_FACTOR = 0.1


# problem: register stores password


@app.route('/users', methods=['POST'])
def register_user():
    user_data = request.json
    email = user_data.get('email')
    password = user_data.get('password')

    location = user_data.get('location', {})
    latitude = location.get('latitude')
    longitude = location.get('longitude')

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
        "id": collector_id,

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
    user_id = booking_data.get('user_id')
    pickup_location = booking_data.get('location')
    number_of_bins = booking_data.get('number_of_bins')
    price = number_of_bins * PRICE

    if not user_id or not pickup_location:
        return jsonify({"error": "User ID and pickup location required"}), 400

    user_location = (pickup_location['pickup_latitude'], pickup_location['pickup_longitude'])
    # nearby_drivers = find_nearby_collectors(user_location)

    # print("Nearby drivers: " + str(nearby_drivers))
    # if not nearby_drivers:
    #     return jsonify({"error": "No drivers available nearby. "
    #                              "Try calling from the driver section"}), 404

    booking_id = user_manager.create_booking(booking_data)

    return jsonify({"booking_id": booking_id,
                    "price": price if number_of_bins <= 2 else (price - (price * DISCOUNT_FACTOR))}), 201


def find_nearby_collectors(user_location):
    collector_ref = db.reference('collectors')
    collectors = collector_ref.get()

    nearby_collectors = []

    if collectors:
        for collector_id, collector_data in collectors.items():
            if 'location' in collector_data and collector_data['location']:
                collector_location = (
                    collector_data['location']['pickup_latitude'],
                    collector_data['location']['pickup_longitude']
                )

                distance = geodesic(user_location, collector_location).km

                if distance <= MAX_DISTANCE_KM:
                    nearby_collectors.append({"collector_id": collector_id, "distance": distance})

    return sorted(nearby_collectors, key=lambda k: k['distance'])


@app.route('/booking/<bid>', methods=['GET'])
def get_collection_service(bid):
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


@app.route('/practices', methods=['POST'])
def add_waste_practice_video():
    url = request.json
    db_ref = db.reference('waste_practices')
    db_ref.push(url)
    return jsonify({"url": url}), 201


@app.route('/practices', methods=['GET'])
def get_waste_practices():
    try:
        db_ref = db.reference('waste_practices')
        youtube_urls = db_ref.get()

        if youtube_urls:
            urls = [video_data['url'] for video_data in youtube_urls.values()]
            return jsonify({"videos": urls}), 200

        return jsonify({"message": "No videos available"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/users/<string:uid>/history', methods=['GET'])
def view_history_user(uid):
    user_history = user_manager.get_booking_history(uid)

    return jsonify({"history": user_history}), 200


@app.route('/collectors/<string:cid>/history', methods=['GET'])
def view_history_collector(cid):
    collector_history = waste_collector_manager.get_trip_history(cid)
    return jsonify({"history": collector_history}), 200


if __name__ == '__main__':
    app.run(debug=True)
