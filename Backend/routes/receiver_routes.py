from flask import Blueprint, request, jsonify
from extensions import db
from models.receiver import Receiver
from models.donor import Donor
from models.user import User
from models.transaction import Transaction
from models.inventory import BloodInventory
from utils.decorators import token_required, role_required
from utils.blood_compatibility import get_compatible_donors
from datetime import datetime

receiver_bp = Blueprint('receiver', __name__)

@receiver_bp.route('/profile', methods=['GET'])
@token_required
@role_required('receiver')
def get_profile(current_user):
    try:
        receiver = Receiver.query.filter_by(user_id=current_user.user_id).first()
        
        if not receiver:
            return jsonify({'error': 'Receiver profile not found'}), 404
        
        profile = current_user.to_dict()
        profile.update(receiver.to_dict())
        
        return jsonify(profile), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@receiver_bp.route('/profile', methods=['PUT'])
@token_required
@role_required('receiver')
def update_profile(current_user):
    try:
        data = request.get_json()
        receiver = Receiver.query.filter_by(user_id=current_user.user_id).first()
        
        # Update user fields
        if 'full_name' in data:
            current_user.full_name = data['full_name']
        if 'phone' in data:
            current_user.phone = data['phone']
        if 'city' in data:
            current_user.city = data['city']
        
        # Update receiver fields
        if 'medical_condition' in data:
            receiver.medical_condition = data['medical_condition']
        if 'urgency_level' in data:
            receiver.urgency_level = data['urgency_level']
        
        db.session.commit()
        
        return jsonify({'message': 'Profile updated successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@receiver_bp.route('/matching-donors', methods=['GET'])
@token_required
@role_required('receiver')
def get_matching_donors(current_user):
    try:
        receiver = Receiver.query.filter_by(user_id=current_user.user_id).first()
        compatible_blood_types = get_compatible_donors(receiver.blood_type)
        
        # Get eligible donors with compatible blood types
        donors = Donor.query.filter(
            Donor.blood_type.in_(compatible_blood_types),
            Donor.is_eligible == True
        ).all()
        
        result = []
        for donor in donors:
            user = User.query.get(donor.user_id)
            donor_data = donor.to_dict()
            donor_data.update({
                'full_name': user.full_name,
                'city': user.city,
                'state': user.state
            })
            result.append(donor_data)
        
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@receiver_bp.route('/request-blood', methods=['POST'])
@token_required
@role_required('receiver')
def request_blood(current_user):
    try:
        data = request.get_json()
        receiver = Receiver.query.filter_by(user_id=current_user.user_id).first()
        
        units_needed = data.get('units', 1)
        urgency = data.get('urgency', 'medium')
        reason = data.get('reason', '')
        
        # Check inventory first
        available_inventory = BloodInventory.query.filter_by(
            blood_type=receiver.blood_type,
            status='available'
        ).first()
        
        if available_inventory and available_inventory.units_available >= units_needed:
            # Create transaction from inventory
            transaction = Transaction(
                receiver_id=receiver.receiver_id,
                blood_type=receiver.blood_type,
                units=units_needed,
                transaction_type='from_inventory',
                notes=f'Fulfilled from inventory. Reason: {reason}'
            )
            
            # Update inventory
            available_inventory.units_available -= units_needed
            
            db.session.add(transaction)
            db.session.commit()
            
            return jsonify({
                'message': 'Blood request fulfilled from inventory',
                'transaction': transaction.to_dict()
            }), 201
        
        # If not in inventory, create a pending request
        return jsonify({
            'message': 'Blood not available in inventory. Please contact matching donors.',
            'available_units': available_inventory.units_available if available_inventory else 0
        }), 200
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@receiver_bp.route('/history', methods=['GET'])
@token_required
@role_required('receiver')
def get_history(current_user):
    try:
        receiver = Receiver.query.filter_by(user_id=current_user.user_id).first()
        transactions = Transaction.query.filter_by(receiver_id=receiver.receiver_id).all()
        
        history = [t.to_dict() for t in transactions]
        return jsonify(history), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@receiver_bp.route('/inventory-check', methods=['GET'])
@token_required
@role_required('receiver')
def check_inventory(current_user):
    try:
        receiver = Receiver.query.filter_by(user_id=current_user.user_id).first()
        compatible_blood_types = get_compatible_donors(receiver.blood_type)
        
        inventory = BloodInventory.query.filter(
            BloodInventory.blood_type.in_(compatible_blood_types),
            BloodInventory.status == 'available'
        ).all()
        
        result = [inv.to_dict() for inv in inventory]
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500