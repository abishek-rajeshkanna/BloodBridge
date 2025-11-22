from flask import Blueprint, request, jsonify
from extensions import db
from models.user import User
from models.donor import Donor
from models.receiver import Receiver
from models.inventory import BloodInventory
from models.transaction import Transaction
from utils.decorators import token_required, role_required
from datetime import datetime, timedelta

admin_bp = Blueprint('admin', __name__)

@admin_bp.route('/dashboard', methods=['GET'])
@token_required
@role_required('admin')
def dashboard(current_user):
    try:
        total_donors = Donor.query.count()
        total_receivers = Receiver.query.count()
        total_donations = Transaction.query.count()
        
        # Blood inventory summary
        inventory_summary = db.session.query(
            BloodInventory.blood_type,
            db.func.sum(BloodInventory.units_available)
        ).filter_by(status='available').group_by(BloodInventory.blood_type).all()
        
        inventory_data = {blood_type: units for blood_type, units in inventory_summary}
        
        return jsonify({
            'total_donors': total_donors,
            'total_receivers': total_receivers,
            'total_donations': total_donations,
            'inventory': inventory_data
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@admin_bp.route('/users', methods=['GET'])
@token_required
@role_required('admin')
def get_all_users(current_user):
    try:
        role = request.args.get('role')  # Filter by role if provided
        
        if role:
            users = User.query.filter_by(role=role).all()
        else:
            users = User.query.all()
        
        result = [user.to_dict() for user in users]
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@admin_bp.route('/users/<int:user_id>', methods=['DELETE'])
@token_required
@role_required('admin')
def delete_user(current_user, user_id):
    try:
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        db.session.delete(user)
        db.session.commit()
        
        return jsonify({'message': 'User deleted successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@admin_bp.route('/inventory', methods=['GET'])
@token_required
@role_required('admin')
def get_inventory(current_user):
    try:
        inventory = BloodInventory.query.all()
        result = [inv.to_dict() for inv in inventory]
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@admin_bp.route('/inventory', methods=['POST'])
@token_required
@role_required('admin')
def add_inventory(current_user):
    try:
        data = request.get_json()
        
        expiry_date = datetime.strptime(data['expiry_date'], '%Y-%m-%d').date() if 'expiry_date' in data else datetime.now().date() + timedelta(days=42)
        
        inventory = BloodInventory(
            blood_type=data['blood_type'],
            units_available=data['units'],
            collection_date=datetime.now().date(),
            expiry_date=expiry_date,
            status='available'
        )
        
        db.session.add(inventory)
        db.session.commit()
        
        return jsonify({'message': 'Inventory added successfully', 'inventory': inventory.to_dict()}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@admin_bp.route('/inventory/<int:inventory_id>', methods=['PUT'])
@token_required
@role_required('admin')
def update_inventory(current_user, inventory_id):
    try:
        inventory = BloodInventory.query.get(inventory_id)
        if not inventory:
            return jsonify({'error': 'Inventory not found'}), 404
        
        data = request.get_json()
        
        if 'units_available' in data:
            inventory.units_available = data['units_available']
        if 'status' in data:
            inventory.status = data['status']
        
        db.session.commit()
        
        return jsonify({'message': 'Inventory updated successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@admin_bp.route('/inventory/<int:inventory_id>', methods=['DELETE'])
@token_required
@role_required('admin')
def delete_inventory(current_user, inventory_id):
    try:
        inventory = BloodInventory.query.get(inventory_id)
        if not inventory:
            return jsonify({'error': 'Inventory not found'}), 404
        
        db.session.delete(inventory)
        db.session.commit()
        
        return jsonify({'message': 'Inventory deleted successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@admin_bp.route('/transactions', methods=['GET'])
@token_required
@role_required('admin')
def get_all_transactions(current_user):
    try:
        transactions = Transaction.query.all()
        result = [t.to_dict() for t in transactions]
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@admin_bp.route('/donors', methods=['GET'])
@token_required
@role_required('admin')
def get_all_donors(current_user):
    try:
        donors = Donor.query.all()
        result = []
        
        for donor in donors:
            user = User.query.get(donor.user_id)
            donor_data = donor.to_dict()
            donor_data.update({
                'email': user.email,
                'full_name': user.full_name,
                'phone': user.phone,
                'city': user.city
            })
            result.append(donor_data)
        
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@admin_bp.route('/receivers', methods=['GET'])
@token_required
@role_required('admin')
def get_all_receivers(current_user):
    try:
        receivers = Receiver.query.all()
        result = []
        
        for receiver in receivers:
            user = User.query.get(receiver.user_id)
            receiver_data = receiver.to_dict()
            receiver_data.update({
                'email': user.email,
                'full_name': user.full_name,
                'phone': user.phone,
                'city': user.city
            })
            result.append(receiver_data)
        
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500