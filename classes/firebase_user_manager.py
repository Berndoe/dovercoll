import uuid

from firebase_admin import db, storage, auth
from classes.abstract_user import AbstractUser


class FirebaseManager(AbstractUser):
    def __init__(self, user_type):
        self.user_type = user_type

    def register(self, email, password, data):
        try:
            user = auth.create_user(email=email, password=password)
            data['uid'] = user.uid
            db.reference(f'{self.user_type}/{user.uid}').set(data)
            return user.uid
        except Exception as e:
            return {'error': str(e)}

    def login(self, email, password):
        try:
            user = auth.get_user_by_email(email)
            return {'message': 'User found', 'uid': user.uid}
        except Exception as e:
            return {'error': str(e)}

    def get(self):
        return db.reference(f'{self.user_type}').get()

    def get_user(self, user_id):
        return db.reference(f'{self.user_type}/{user_id}').get()

    def update(self, user_id, user_data):
        db_ref = db.reference(f'{self.user_type}/{user_id}')

        if db_ref.get():
            db_ref.update(user_data)
            return True

        return False

    def remove(self, user_id):
        db_ref = db.reference(f'{self.user_type}/{user_id}')

        if db_ref.get():
            db_ref.delete()
            return True

        return False

    def upload_picture(self, user_id, image):
        bucket = storage.bucket()
        blob = bucket.blob(f'{self.user_type}/{user_id}/profile_picture')
        blob.upload_from_file(image, content_type=image.content_type)

        blob.make_public()
        url = blob.public_url

        db_ref = db.reference(f'{self.user_type}/{user_id}')
        if db_ref.get():
            db_ref.update({"profile_picture": url})

        return url

    def create_booking(self, booking_data):
        booking_id = str(uuid.uuid4())
        db_ref = db.reference('bookings')
        db_ref.child(booking_id).set(booking_data)
        return booking_id

    def get_booking(self, booking_id):
        return db.reference(f'bookings/{booking_id}').get()

    def cancel_booking(self, booking_id):
        db_ref = db.reference(f'bookings/{booking_id}')
        if db_ref.get():
            db_ref.delete()
            return True
        return False

    def update_booking(self, booking_id, booking_data):
        db_ref = db.reference(f'bookings/{booking_id}')
        if db_ref.get():
            db_ref.update(booking_data)
            return True
        return False

    def get_booking_history(self, user_id):
        db_ref = db.reference('bookings')
        bookings = db_ref.order_by_child('user_id').equal_to(user_id).get()
        return bookings

    def get_trip_history(self, collector_id):
        db_ref = db.reference('bookings')
        trips = db_ref.order_by_child('collector_id').equal_to(collector_id).get()
        return trips
