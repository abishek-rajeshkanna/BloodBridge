from extensions import db
from datetime import datetime

class Transaction(db.Model):
    __tablename__ = 'transactions'
    
    transaction_id = db.Column(db.Integer, primary_key=True)
    donor_id = db.Column(db.Integer, db.ForeignKey('donors.donor_id'))
    receiver_id = db.Column(db.Integer, db.ForeignKey('receivers.receiver_id'))
    blood_type = db.Column(db.String(5), nullable=False)
    units = db.Column(db.Integer, nullable=False)
    transaction_date = db.Column(db.DateTime, default=datetime.utcnow)
    transaction_type = db.Column(db.String(20), nullable=False)
    notes = db.Column(db.Text)
    
    def to_dict(self):
        return {
            'transaction_id': self.transaction_id,
            'donor_id': self.donor_id,
            'receiver_id': self.receiver_id,
            'blood_type': self.blood_type,
            'units': self.units,
            'transaction_date': str(self.transaction_date),
            'transaction_type': self.transaction_type
        }