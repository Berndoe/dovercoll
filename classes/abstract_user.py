from abc import ABC, abstractmethod


class AbstractUser(ABC):
    @abstractmethod
    def register(self, data):
        pass

    @abstractmethod
    def get(self, user_id):
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
