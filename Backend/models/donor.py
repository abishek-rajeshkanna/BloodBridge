from extensions import db
from datetime import datetime

class Donor(db.Model):
    __tablename__ = 'donors'
    
    donor_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id', ondelete='CASCADE'))
    blood_type = db.Column(db.String(5), nullable=False)
    last_donation_date = db.Column(db.Date)
    weight = db.Column(db.Numeric(5, 2))
    health_status = db.Column(db.String(50), default='healthy')
    is_eligible = db.Column(db.Boolean, default=True)
    total_donations = db.Column(db.Integer, default=0)
    
    def to_dict(self):
        return {
            'donor_id': self.donor_id,
            'user_id': self.user_id,
            'blood_type': self.blood_type,
            'last_donation_date': str(self.last_donation_date) if self.last_donation_date else None,
            'is_eligible': self.is_eligible,
            'total_donations': self.total_donations
        }