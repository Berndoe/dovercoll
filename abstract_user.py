from abc import ABC, abstractmethod


class AbstractUser(ABC):
    @abstractmethod
    def register(self, email, password, data):
        pass

    @abstractmethod
    def login(self, email,password):
        pass

    @abstractmethod
    def get(self):
        pass

    @abstractmethod
    def get_user(self, user_id):
        pass

    @abstractmethod
    def update(self, user_id, data):
        pass

    @abstractmethod
    def remove(self, user_id):
        pass

    @abstractmethod
    def upload_picture(self, user_id, file):
        pass
