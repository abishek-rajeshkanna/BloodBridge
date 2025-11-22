from flask import Blueprint, request, jsonify
from extensions import db
from models.donor import Donor
from models.receiver import Receiver
from models.user import User
from models.transaction import Transaction
from models.inventory import BloodInventory
from utils.decorators import token_required, role_required
from utils.blood_compatibility import get_compatible_receivers
from datetime import datetime, timedelta

donor_bp = Blueprint('donor', __name__)

@donor_bp.route('/profile', methods=['GET'])
@token_required
@role_required('donor')
def get_profile(current_user):
    try:
        donor = Donor.query.filter_by(user_id=current_user.user_id).first()
        
        if not donor:
            return jsonify({'error': 'Donor profile not found'}), 404
        
        profile = current_user.to_dict()
        profile.update(donor.to_dict())
        
        return jsonify(profile), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@donor_bp.route('/profile', methods=['PUT'])
@token_required
@role_required('donor')
def update_profile(current_user):
    try:
        data = request.get_json()
        donor = Donor.query.filter_by(user_id=current_user.user_id).first()
        
        # Update user fields
        if 'full_name' in data:
            current_user.full_name = data['full_name']
        if 'phone' in data:
            current_user.phone = data['phone']
        if 'city' in data:
            current_user.city = data['city']
        if 'state' in data:
            current_user.state = data['state']
        
        # Update donor fields
        if 'weight' in data:
            donor.weight = data['weight']
        if 'health_status' in data:
            donor.health_status = data['health_status']
        
        db.session.commit()
        
        return jsonify({'message': 'Profile updated successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@donor_bp.route('/eligible-receivers', methods=['GET'])
@token_required
@role_required('donor')
def get_eligible_receivers(current_user):
    try:
        donor = Donor.query.filter_by(user_id=current_user.user_id).first()
        compatible_blood_types = get_compatible_receivers(donor.blood_type)
        
        # Get receivers with compatible blood types
        receivers = Receiver.query.filter(Receiver.blood_type.in_(compatible_blood_types)).all()
        
        result = []
        for receiver in receivers:
            user = User.query.get(receiver.user_id)
            receiver_data = receiver.to_dict()
            receiver_data.update({
                'full_name': user.full_name,
                'city': user.city,
                'state': user.state
            })
            result.append(receiver_data)
        
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@donor_bp.route('/donate', methods=['POST'])
@token_required
@role_required('donor')
def donate(current_user):
    try:
        data = request.get_json()
        donor = Donor.query.filter_by(user_id=current_user.user_id).first()
        
        # Check eligibility (3 months since last donation)
        if donor.last_donation_date:
            days_since_last = (datetime.now().date() - donor.last_donation_date).days
            if days_since_last < 90:
                return jsonify({
                    'error': f'You must wait {90 - days_since_last} more days before donating again'
                }), 400
        
        donation_type = data.get('donation_type')  # 'direct' or 'inventory'
        units = data.get('units', 1)
        
        if donation_type == 'direct':
            # Direct donation to receiver
            receiver_id = data.get('receiver_id')
            if not receiver_id:
                return jsonify({'error': 'receiver_id is required for direct donation'}), 400
            
            # Create transaction (pending admin approval)
            transaction = Transaction(
                donor_id=donor.donor_id,
                receiver_id=receiver_id,
                blood_type=donor.blood_type,
                units=units,
                transaction_type='direct',
                notes='Pending admin approval'
            )
            db.session.add(transaction)
            
        elif donation_type == 'inventory':
            # Donate to blood bank inventory
            expiry_date = datetime.now().date() + timedelta(days=42)  # Blood expires in 42 days
            
            inventory = BloodInventory(
                blood_type=donor.blood_type,
                units_available=units,
                collection_date=datetime.now().date(),
                expiry_date=expiry_date,
                status='available',
                donor_id=donor.donor_id
            )
            db.session.add(inventory)
        else:
            return jsonify({'error': 'Invalid donation_type'}), 400
        
        # Update donor info
        donor.last_donation_date = datetime.now().date()
        donor.total_donations += 1
        
        db.session.commit()
        
        return jsonify({'message': 'Donation recorded successfully'}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@donor_bp.route('/history', methods=['GET'])
@token_required
@role_required('donor')
def get_history(current_user):
    try:
        donor = Donor.query.filter_by(user_id=current_user.user_id).first()
        transactions = Transaction.query.filter_by(donor_id=donor.donor_id).all()
        
        history = [t.to_dict() for t in transactions]
        return jsonify(history), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@donor_bp.route('/check-eligibility', methods=['GET'])
@token_required
@role_required('donor')
def check_eligibility(current_user):
    try:
        donor = Donor.query.filter_by(user_id=current_user.user_id).first()
        
        if not donor.last_donation_date:
            return jsonify({
                'eligible': True,
                'message': 'You are eligible to donate'
            }), 200
        
        days_since_last = (datetime.now().date() - donor.last_donation_date).days
        
        if days_since_last >= 90:
            return jsonify({
                'eligible': True,
                'message': 'You are eligible to donate'
            }), 200
        else:
            return jsonify({
                'eligible': False,
                'days_remaining': 90 - days_since_last,
                'message': f'You must wait {90 - days_since_last} more days'
            }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500