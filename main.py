"""
Author: Bernd Opoku-Boadu
"""
import datetime
import threading
import time
from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, db
from flask_cors import CORS
from firebase_user_manager import FirebaseManager
from geopy.distance import geodesic
from twilio.rest import Client


# initialise flask app
app = Flask(__name__)
CORS(app)
# initialise firebase admin sdk
cred = credentials.Certificate('dovercoll_key.json')
firebase_admin.initialize_app(cred, {
    'databaseURL': '',
    'storageBucket': ''
})

# instantiate firebase manager for users and waste collectors
user_manager = FirebaseManager('users')
waste_collector_manager = FirebaseManager('collectors')

MAX_DISTANCE_KM = 15
PRICE = 20
DISCOUNT_FACTOR = 0.1
RESPONSE_WAIT_TIME = 5
GH_CODE = '+233'


# problem: register stores password

@app.route('/users', methods=['POST'])
def register_user():
    try:
        user_data = request.json
        email = user_data.get('email')
        password = user_data.get('password')
        if not email or not password:
            return jsonify({'error': 'Email and password are required'}), 400
        user_id = user_manager.register(email, password, user_data)
        if 'error' in user_id:
            return jsonify({'error': user_id['error']}), 400
        return jsonify({"user": user_id}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/collectors', methods=['POST'])
def register_collector():
    try:
        collector_data = request.json
        email = collector_data.get('email')
        password = collector_data.get('password')
        if not email or not password:
            return jsonify({'error': 'Email and password are required'}), 400
        collector_id = waste_collector_manager.register(email, password, collector_data)
        if 'error' in collector_id:
            return jsonify({'error': collector_id['error']}), 400
        return jsonify({"id": collector_id, }), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route('/login', methods=['POST'])
def login_user():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    result = user_manager.login(email, password)
    
    if 'error' in result:
        return jsonify({'error': result['error']['message']}), 400
    else:
        return jsonify({
            'message': 'Login successful',
            'idToken': result['idToken'],
            'refreshToken': result['refreshToken'],
            'expiresIn': result['expiresIn'],
            'localId': result['localId'],
            'email': result['email']
        }), 200
@app.route('/users', methods=['GET'])
def get_users():
    try:
        user_data = user_manager.get()
        return jsonify({
            "users": user_data
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/collectors', methods=['GET'])
def get_collectors():
    try:
        user_data = waste_collector_manager.get()
        return jsonify({
            "collectors": user_data
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/users/<uid>', methods=['GET'])
def get_user(uid):
    try:
        user = user_manager.get_user(uid)

        if user:
            return jsonify(user), 200
        else:
            return jsonify({"error": "User not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/collectors/<cid>', methods=['GET'])
def get_collector(cid):
    try:
        collector = waste_collector_manager.get_user(cid)

        if collector:
            return jsonify(collector), 200
        else:
            return jsonify({"error": "User not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/users/<uid>', methods=['PUT'])
def update_user(uid):
    try:
        user_data = request.json
        if user_manager.update(uid, user_data):
            return jsonify({"message": "User updated successfully"}), 200
        else:
            return jsonify({"message": "User not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/collectors/<cid>', methods=['PUT'])
def update_collector(cid):
    try:
        user_data = request.json
        if waste_collector_manager.update(cid, user_data):
            return jsonify({"message": "Collector updated successfully"}), 200
        else:
            return jsonify({"message": "Collector not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 400


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
    try:
        if 'image' not in request.files:
            return jsonify({"error": "No file part"}), 400

        image = request.files['image']
        if image.filename == '':
            return jsonify({"error": "No selected file"}), 400

        image_url = user_manager.upload_picture(uid, image)
        return jsonify({"url": image_url}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/collectors/<cid>/profile_picture', methods=['POST'])
def upload_collector_picture(cid):
    try:
        if 'image' not in request.files:
            return jsonify({"error": "No file part"}), 400

        image = request.files['image']
        if image.filename == '':
            return jsonify({"error": "No selected file"}), 400

        image_url = waste_collector_manager.upload_picture(cid, image)
        return jsonify({"url": image_url}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/users/booking', methods=['POST'])
def order_collection_service():
    try:
        booking_data = request.json
        user_id = booking_data.get('user_id')
        pickup_location = booking_data.get('pickup_location')
        number_of_bins = booking_data.get('number_of_bins')
        price = number_of_bins * PRICE

        if not user_id or not pickup_location:
            return jsonify({"error": "User ID and pickup location required"}), 400

        user_location = (pickup_location['latitude'], pickup_location['longitude'])
        nearby_waste_collectors = find_nearby_collectors(user_location)
        print(nearby_waste_collectors)

        if not nearby_waste_collectors:
            return jsonify({"error": "No collectors available nearby. "
                                     "Try calling from the driver section"}), 404

        booking_data = {
            'user_id': user_id,
            'number_of_bins': number_of_bins,
            'status': 'pending',
            'price': price if number_of_bins <= 2 else (price - (price * DISCOUNT_FACTOR)),
            'time_requested': str(f'{datetime.datetime.now().now()}'),
            'location': {
                'longitude': user_location[0],
                'latitude': user_location[1]
            }
        }

        booking_id = user_manager.create_booking(booking_data)
        user_manager.update_booking(booking_id, {
            'booking_id': booking_id,
        })

        threading.Thread(target=wait_for_collector_response, args=(booking_id,)).start()

        return jsonify({"booking_data": booking_data,
                        "nearby_waste_collectors": nearby_waste_collectors}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400


def find_nearby_collectors(user_location):
    collector_ref = db.reference('collectors')
    collectors = collector_ref.get()

    nearby_collectors = []

    if collectors:
        for collector_id, collector_data in collectors.items():
            if 'location' in collector_data and collector_data['location']:
                collector_location = (
                    collector_data['location']['latitude'],
                    collector_data['location']['longitude']
                )

                distance = geodesic(user_location, collector_location).km

                if distance <= MAX_DISTANCE_KM:
                    nearby_collectors.append({"collector_id": collector_id})

    return nearby_collectors


@app.route('/collectors/respond', methods=['POST'])
def collector_response():
    try:
        collector_response = request.json
        booking_id = collector_response.get('booking_id')
        collector_id = collector_response.get('collector_id')

        if not booking_id or not collector_id:
            return jsonify({"error": "Booking ID and Collector ID required"}), 400

        booking_data = user_manager.get_booking(booking_id)

        if not booking_data or booking_data.get('status') != 'pending':
            return jsonify({"error": "Invalid or non-pending booking ID"}), 404

        if booking_data.get('status') == 'ongoing':
            return jsonify({"error": "Collector already assigned to booking"}), 400

        user_manager.update_booking(booking_id, {'collector_id': collector_id, 'status': 'ongoing'})

        return jsonify({"message": "Booking accepted", "booking_id": booking_id, "collector_id": collector_id}), 201

    except Exception as e:
        return jsonify({"error": f"Error in collector response: {str(e)}"}), 400


def wait_for_collector_response(booking_id):
    time.sleep(RESPONSE_WAIT_TIME)
    booking_data = user_manager.get_booking(booking_id)
    if booking_data and booking_data.get('status') == 'pending':
        print("Booking data " + str(booking_data))
        user_manager.cancel_booking(booking_id)


@app.route('/bookings', methods=['GET'])
def get_bookings():
    try:
        db_ref = db.reference('bookings')
        bookings = db_ref.get()

        if bookings:
            return jsonify({"bookings": bookings}), 200

        return jsonify({"message": "No bookings available"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/users/booking/<bid>', methods=['GET'])
def get_collection_service(bid):
    try:
        booking = user_manager.get_booking(bid)

        if booking:
            return jsonify({"booking": booking}), 200

        return jsonify({"message": "Booking not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/users/booking/<bid>', methods=['PUT'])
def modify_collection_service(bid):
    booking_data = request.json
    if user_manager.update_booking(bid, booking_data):
        return jsonify({"message": "Booking updated successfully"}), 200
    return jsonify({"message": "Booking not found"})


@app.route('/retrieve_bin_status', methods=['POST'])
def receive_bin_data():
    try:
        data = request.get_json()
        fill_percentage = data.get('fill_percentage')
        print(f"Received fill percentage: {fill_percentage}%")

        db.reference('sensors').set({
            'fill_percentage': fill_percentage
        })
        return jsonify({"status": "success", "fill_percentage": fill_percentage}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/get_bin_data', methods=['GET'])
def get_bin_data():
    try:
        sensor_data = db.reference('sensors').get()
        if sensor_data:
            data = sensor_data
            return jsonify(data), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/users/booking/<bid>', methods=['DELETE'])
def cancel_collection_service(bid):
    try:
        if user_manager.cancel_booking(bid):
            return jsonify({"message": "Booking cancelled"}), 200
        return jsonify({"message": "Booking not found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/practices', methods=['POST'])
def add_waste_practice_video():
    try:
        url = request.json
        db_ref = db.reference('waste_practices')
        db_ref.push(url)
        return jsonify({"url": url}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400


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
    try:
        user_history = user_manager.get_booking_history(uid)
        return jsonify({"history": user_history}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/collectors/<string:cid>/history', methods=['GET'])
def view_history_collector(cid):
    try:
        collector_history = waste_collector_manager.get_trip_history(cid)
        return jsonify({"history": collector_history}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@app.route('/notifications/sms', methods=['POST'])
def send_message():
    # Extract phone_number from the request data
    data = request.get_json()
    phone_number = data.get('phone_number')

    if not phone_number:
        return jsonify({"error": "Phone number is required"}), 400

    # Twilio credentials
    account_sid = ''
    auth_token = ''

    client = Client(account_sid, auth_token)

    formatted_number = f"{GH_CODE}{phone_number[1:]}"

    # Send the message
    message = client.messages.create(
        body='Your bin is full!',  # Message content
        from_='+12512930904',  # Replace with your Twilio number
        to=formatted_number
    )
    return jsonify({"message": "Message sent", "sid": message.sid}), 201


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
