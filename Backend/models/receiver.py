from extensions import db

class Receiver(db.Model):
    __tablename__ = 'receivers'
    
    receiver_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id', ondelete='CASCADE'))
    blood_type = db.Column(db.String(5), nullable=False)
    medical_condition = db.Column(db.Text)
    urgency_level = db.Column(db.String(20), default='medium')
    
    def to_dict(self):
        return {
            'receiver_id': self.receiver_id,
            'user_id': self.user_id,
            'blood_type': self.blood_type,
            'medical_condition': self.medical_condition,
            'urgency_level': self.urgency_level
        }