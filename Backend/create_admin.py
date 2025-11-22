from extensions import db, bcrypt
from models.user import User
from app import create_app

def create_admin():
    app = create_app()
    
    with app.app_context():
        # Check if admin exists
        existing_admin = User.query.filter_by(email='admin@bloodbank.com').first()
        
        if existing_admin:
            print("Admin user already exists!")
            return
        
        # Create admin user
        hashed_password = bcrypt.generate_password_hash('admin123').decode('utf-8')
        
        admin = User(
            email='admin@bloodbank.com',
            password_hash=hashed_password,
            role='admin',
            full_name='System Administrator',
            phone='1234567890',
            city='Chennai',
            state='Tamil Nadu',
            is_active=True
        )
        
        db.session.add(admin)
        db.session.commit()
        
        print("Admin user created successfully!")
        print("Email: admin@bloodbank.com")
        print("Password: admin123")

if __name__ == '__main__':
    create_admin()