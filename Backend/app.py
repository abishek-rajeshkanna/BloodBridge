from flask import Flask
from flask_cors import CORS
from config import Config
from extensions import db, bcrypt

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    
    # Initialize extensions with app
    db.init_app(app)
    bcrypt.init_app(app)
    CORS(app)
    
    # Import models here (after app context)
    with app.app_context():
        from models.user import User
        from models.donor import Donor
        from models.receiver import Receiver
        from models.inventory import BloodInventory
        from models.transaction import Transaction
        
        # Register blueprints
        from routes.auth_routes import auth_bp
        from routes.admin_routes import admin_bp
        from routes.donor_routes import donor_bp
        from routes.receiver_routes import receiver_bp
        
        app.register_blueprint(auth_bp, url_prefix='/api/auth')
        app.register_blueprint(admin_bp, url_prefix='/api/admin')
        app.register_blueprint(donor_bp, url_prefix='/api/donor')
        app.register_blueprint(receiver_bp, url_prefix='/api/receiver')
        
        # Create tables
        db.create_all()
    
    @app.route('/')
    def home():
        return {'message': 'Blood Bank API is running'}
    
    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True, port=5000)