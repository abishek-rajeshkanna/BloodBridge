import os
from datetime import timedelta

class Config:
    # Database
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:1234@localhost:5432/bloodbridge'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Secret Key for JWT
    SECRET_KEY = 'your-secret-key-change-this-in-production'
    JWT_EXPIRATION = timedelta(hours=24)
    
    # Other configs
    JSON_SORT_KEYS = False