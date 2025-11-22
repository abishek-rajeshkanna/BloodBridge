from flask import Blueprint, request, jsonify
from extensions import db, bcrypt
from models.user import User
from models.donor import Donor
from models.receiver import Receiver
import jwt
from datetime import datetime, timedelta
from config import Config

auth_bp = Blueprint('auth', __name__)

def generate_token(user_id):
    payload = {
        'user_id': user_id,
        'exp': datetime.utcnow() + Config.JWT_EXPIRATION
    }
    return jwt.encode(payload, Config.SECRET_KEY, algorithm='HS256')

@auth_bp.route('/register', methods=['POST'])
def register():
    try:
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['email', 'password', 'role', 'full_name']
        for field in required_fields:
            if field not in data:
                return jsonify({'error': f'Missing required field: {field}'}), 400
        
        # Check if blood_type is required for donor/receiver
        if data['role'] in ['donor', 'receiver'] and 'blood_type' not in data:
            return jsonify({'error': 'blood_type is required for donors and receivers'}), 400
        
        # Check if user exists
        if User.query.filter_by(email=data['email']).first():
            return jsonify({'error': 'Email already exists'}), 400
        
        # Hash password
        hashed_password = bcrypt.generate_password_hash(data['password']).decode('utf-8')
        
        # Create user
        new_user = User(
            email=data['email'],
            password_hash=hashed_password,
            role=data['role'],
            full_name=data['full_name'],
            phone=data.get('phone'),
            city=data.get('city'),
            state=data.get('state')
        )
        
        db.session.add(new_user)
        db.session.flush()
        
        # Create donor or receiver profile
        if data['role'] == 'donor':
            donor = Donor(
                user_id=new_user.user_id,
                blood_type=data['blood_type'],
                weight=data.get('weight')
            )
            db.session.add(donor)
        elif data['role'] == 'receiver':
            receiver = Receiver(
                user_id=new_user.user_id,
                blood_type=data['blood_type'],
                medical_condition=data.get('medical_condition'),
                urgency_level=data.get('urgency_level', 'medium')
            )
            db.session.add(receiver)
        
        db.session.commit()
        
        # Generate token
        token = generate_token(new_user.user_id)
        
        return jsonify({
            'message': 'User registered successfully',
            'token': token,
            'user': new_user.to_dict()
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@auth_bp.route('/login', methods=['POST'])
def login():
    try:
        data = request.get_json()
        user = User.query.filter_by(email=data['email']).first()
        
        if user and bcrypt.check_password_hash(user.password_hash, data['password']):
            token = generate_token(user.user_id)
            
            return jsonify({
                'message': 'Login successful',
                'token': token,
                'user': user.to_dict()
            }), 200
        
        return jsonify({'error': 'Invalid credentials'}), 401
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500