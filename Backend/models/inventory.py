from extensions import db
from datetime import datetime

class BloodInventory(db.Model):
    __tablename__ = 'blood_inventory'
    
    inventory_id = db.Column(db.Integer, primary_key=True)
    blood_type = db.Column(db.String(5), nullable=False)
    units_available = db.Column(db.Integer, default=0)
    collection_date = db.Column(db.Date, nullable=False)
    expiry_date = db.Column(db.Date, nullable=False)
    status = db.Column(db.String(20), default='available')
    donor_id = db.Column(db.Integer, db.ForeignKey('donors.donor_id'))
    
    def to_dict(self):
        return {
            'inventory_id': self.inventory_id,
            'blood_type': self.blood_type,
            'units_available': self.units_available,
            'collection_date': str(self.collection_date),
            'expiry_date': str(self.expiry_date),
            'status': self.status
        }