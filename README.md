# BloodBridge

## Blood Bank Management System

BloodBridge is a comprehensive web-based blood bank management system designed to streamline the process of blood donation and distribution. The platform connects blood donors with receivers in need, while providing administrators with powerful tools to manage inventory and operations efficiently.

---

## Table of Contents

- [Features](#features)
- [Technology Stack](#technology-stack)
- [System Architecture](#system-architecture)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [API Documentation](#api-documentation)
- [Database Schema](#database-schema)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

---

## Features

### For Donors
- **User Registration & Authentication**: Secure registration with JWT-based authentication
- **Eligibility Tracking**: Automated eligibility checks based on last donation date (90-day waiting period)
- **Blood Donation**: Choose between direct donation to receivers or donation to blood bank inventory
- **Donation History**: Comprehensive tracking of all donations made
- **Receiver Matching**: View compatible receivers based on blood type compatibility
- **Profile Management**: Update personal information and health status

### For Receivers
- **Blood Request System**: Submit requests for required blood units with urgency levels
- **Inventory Checking**: Real-time visibility into available blood inventory
- **Donor Matching**: View compatible donors who can provide blood
- **Request History**: Track all blood requests and fulfillment status
- **Emergency Support**: Priority handling for critical requests

### For Administrators
- **Dashboard Analytics**: Comprehensive overview of system statistics
- **User Management**: Manage donors, receivers, and system users
- **Inventory Management**: Add, update, and monitor blood inventory
- **Transaction Monitoring**: Track all blood donations and distributions
- **Expiry Alerts**: Monitor blood units approaching expiration dates
- **Blood Type Analytics**: Visual representation of inventory by blood type

### Core System Features
- **Blood Compatibility Engine**: Automated checking of donor-receiver blood type compatibility
- **Real-time Inventory Tracking**: Live updates on blood availability
- **Secure Authentication**: JWT-based token authentication with role-based access control
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices
- **Dark Theme Interface**: Modern black and red themed UI

---

## Technology Stack

### Backend
- **Python 3.8+**: Core programming language
- **Flask 3.0**: Web framework
- **PostgreSQL**: Relational database
- **SQLAlchemy**: ORM for database operations
- **Flask-Bcrypt**: Password hashing
- **PyJWT**: JSON Web Token implementation
- **Flask-CORS**: Cross-Origin Resource Sharing

### Frontend
- **HTML5**: Markup language
- **CSS3**: Styling with custom variables and animations
- **JavaScript (ES6+)**: Client-side scripting
- **Fetch API**: HTTP requests to backend

### Database
- **PostgreSQL 12+**: Primary database system

---

## System Architecture

```
BloodBridge/
│
├── backend/                    # Flask backend application
│   ├── app.py                 # Application entry point
│   ├── config.py              # Configuration settings
│   ├── extensions.py          # Flask extensions initialization
│   ├── create_admin.py        # Admin user creation script
│   │
│   ├── models/                # Database models
│   │   ├── user.py           # User model
│   │   ├── donor.py          # Donor model
│   │   ├── receiver.py       # Receiver model
│   │   ├── inventory.py      # Blood inventory model
│   │   └── transaction.py    # Transaction model
│   │
│   ├── routes/               # API route handlers
│   │   ├── auth_routes.py   # Authentication endpoints
│   │   ├── donor_routes.py  # Donor endpoints
│   │   ├── receiver_routes.py # Receiver endpoints
│   │   └── admin_routes.py  # Admin endpoints
│   │
│   └── utils/                # Utility functions
│       ├── blood_compatibility.py # Blood matching logic
│       ├── validators.py     # Input validation
│       └── decorators.py     # Authentication decorators
│
└── frontend/                  # Frontend application
    ├── index.html            # Landing page
    ├── login.html            # Login page
    ├── register.html         # Registration page
    │
    ├── css/
    │   └── style.css         # Main stylesheet
    │
    ├── js/
    │   ├── api.js            # API configuration
    │   └── main.js           # Utility functions
    │
    ├── donor/                # Donor module
    │   ├── dashboard.html
    │   ├── donate.html
    │   └── history.html
    │
    ├── receiver/             # Receiver module
    │   ├── dashboard.html
    │   ├── request.html
    │   └── history.html
    │
    └── admin/                # Admin module
        ├── dashboard.html
        ├── users.html
        └── inventory.html
```

---

## Installation

### Prerequisites

Before installation, ensure you have the following installed:
- Python 3.8 or higher
- PostgreSQL 12 or higher
- pip (Python package manager)
- Git (for cloning the repository)

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/bloodbridge.git
cd bloodbridge
```

### Step 2: Database Setup

1. Start PostgreSQL service:
```bash
# Windows
net start postgresql

# macOS
brew services start postgresql

# Linux
sudo systemctl start postgresql
```

2. Create database:
```bash
psql -U postgres
```

```sql
CREATE DATABASE blood_bank_db;
\c blood_bank_db
```

3. Create tables:
```sql
-- Run all table creation SQL from the database schema section
-- Or let SQLAlchemy create them automatically on first run
```

### Step 3: Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Create virtual environment:
```bash
python -m venv venv
```

3. Activate virtual environment:
```bash
# Windows
venv\Scripts\activate

# macOS/Linux
source venv/bin/activate
```

4. Install dependencies:
```bash
pip install -r requirements.txt
```

5. Configure environment:

Edit `config.py` and update the database connection string:
```python
SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:your_password@localhost:5432/blood_bank_db'
SECRET_KEY = 'your-secret-key-here'
```

6. Create admin user:
```bash
python create_admin.py
```

7. Run the application:
```bash
python app.py
```

The backend will start on `http://localhost:5000`

### Step 4: Frontend Setup

1. Navigate to frontend directory:
```bash
cd ../frontend
```

2. Update API configuration:

Edit `js/api.js` and verify the API URL:
```javascript
const API_URL = 'http://localhost:5000/api';
```

3. Serve the frontend:

**Option A: Using Python's HTTP server**
```bash
python -m http.server 8000
```
Access at `http://localhost:8000`

**Option B: Using Live Server (VS Code Extension)**
- Install "Live Server" extension in VS Code
- Right-click `index.html` and select "Open with Live Server"

**Option C: Direct file access**
- Open `index.html` directly in your browser

---

## Configuration

### Backend Configuration (config.py)

```python
class Config:
    # Database Configuration
    SQLALCHEMY_DATABASE_URI = 'postgresql://username:password@localhost:5432/blood_bank_db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Security Configuration
    SECRET_KEY = 'your-secret-key-change-in-production'
    JWT_EXPIRATION = timedelta(hours=24)
    
    # Application Configuration
    JSON_SORT_KEYS = False
```

### Frontend Configuration (js/api.js)

```javascript
const API_URL = 'http://localhost:5000/api';
```

### Environment Variables (Optional)

Create a `.env` file in the backend directory:
```env
DATABASE_URL=postgresql://postgres:password@localhost:5432/blood_bank_db
SECRET_KEY=your-secret-key
FLASK_ENV=development
```

---

## Usage

### Creating an Admin Account

Run the admin creation script:
```bash
cd backend
python create_admin.py
```

Default credentials:
- Email: `admin@bloodbank.com`
- Password: `admin123`

**Important:** Change the default password immediately after first login!

### User Registration

1. Navigate to the registration page
2. Select role (Donor/Receiver)
3. Fill in required information:
   - Full name
   - Email address
   - Password
   - Phone number
   - Blood type
   - City and State
   - Additional fields based on role

### Donor Workflow

1. **Login** with donor credentials
2. **Check Eligibility** for blood donation
3. **Choose Donation Type**:
   - Donate to inventory
   - Direct donation to receiver
4. **Complete Donation** form
5. **View History** of all donations

### Receiver Workflow

1. **Login** with receiver credentials
2. **Check Available Inventory** for compatible blood types
3. **Submit Blood Request** with:
   - Required units
   - Urgency level
   - Medical reason
4. **View Matching Donors** who can provide blood
5. **Track Request Status** in history

### Admin Workflow

1. **Login** with admin credentials
2. **View Dashboard** for system overview
3. **Manage Users**:
   - View all donors and receivers
   - Delete users if necessary
   - Filter by role
4. **Manage Inventory**:
   - Add new blood units
   - Update existing inventory
   - Monitor expiration dates
   - Delete expired items
5. **Monitor Transactions** across the system

---

## API Documentation

### Base URL
```
http://localhost:5000/api
```

### Authentication Endpoints

#### Register User
```http
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "role": "donor",
  "full_name": "John Doe",
  "phone": "1234567890",
  "blood_type": "O+",
  "city": "Chennai",
  "state": "Tamil Nadu"
}
```

**Response:**
```json
{
  "message": "User registered successfully",
  "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "user_id": 1,
    "email": "user@example.com",
    "role": "donor",
    "full_name": "John Doe"
  }
}
```

#### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "message": "Login successful",
  "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "user_id": 1,
    "email": "user@example.com",
    "role": "donor"
  }
}
```

### Donor Endpoints

All donor endpoints require authentication header:
```
Authorization: Bearer <token>
```

#### Get Donor Profile
```http
GET /donor/profile
```

#### Check Donation Eligibility
```http
GET /donor/check-eligibility
```

#### Submit Donation
```http
POST /donor/donate
Content-Type: application/json

{
  "donation_type": "inventory",
  "units": 1
}
```

#### Get Eligible Receivers
```http
GET /donor/eligible-receivers
```

#### Get Donation History
```http
GET /donor/history
```

### Receiver Endpoints

#### Get Receiver Profile
```http
GET /receiver/profile
```

#### Request Blood
```http
POST /receiver/request-blood
Content-Type: application/json

{
  "units": 2,
  "urgency": "high",
  "reason": "Surgery scheduled"
}
```

#### Get Matching Donors
```http
GET /receiver/matching-donors
```

#### Check Inventory
```http
GET /receiver/inventory-check
```

#### Get Request History
```http
GET /receiver/history
```

### Admin Endpoints

#### Get Dashboard Statistics
```http
GET /admin/dashboard
```

#### Get All Users
```http
GET /admin/users?role=donor
```

#### Get All Donors
```http
GET /admin/donors
```

#### Get All Receivers
```http
GET /admin/receivers
```

#### Get Inventory
```http
GET /admin/inventory
```

#### Add to Inventory
```http
POST /admin/inventory
Content-Type: application/json

{
  "blood_type": "O+",
  "units": 5,
  "expiry_date": "2025-01-15"
}
```

#### Update Inventory
```http
PUT /admin/inventory/{inventory_id}
Content-Type: application/json

{
  "units_available": 3,
  "status": "available"
}
```

#### Delete User
```http
DELETE /admin/users/{user_id}
```

#### Get All Transactions
```http
GET /admin/transactions
```

---

## Database Schema

### Users Table
```sql
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('admin', 'donor', 'receiver')) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);
```

### Donors Table
```sql
CREATE TABLE donors (
    donor_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    blood_type VARCHAR(5) CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')) NOT NULL,
    last_donation_date DATE,
    weight DECIMAL(5,2),
    health_status VARCHAR(50) DEFAULT 'healthy',
    is_eligible BOOLEAN DEFAULT TRUE,
    total_donations INTEGER DEFAULT 0
);
```

### Receivers Table
```sql
CREATE TABLE receivers (
    receiver_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    blood_type VARCHAR(5) CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')) NOT NULL,
    medical_condition TEXT,
    urgency_level VARCHAR(20) CHECK (urgency_level IN ('low', 'medium', 'high', 'critical')) DEFAULT 'medium'
);
```

### Blood Inventory Table
```sql
CREATE TABLE blood_inventory (
    inventory_id SERIAL PRIMARY KEY,
    blood_type VARCHAR(5) CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')) NOT NULL,
    units_available INTEGER DEFAULT 0,
    collection_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('available', 'reserved', 'expired')) DEFAULT 'available',
    donor_id INTEGER REFERENCES donors(donor_id)
);
```

### Transactions Table
```sql
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    donor_id INTEGER REFERENCES donors(donor_id),
    receiver_id INTEGER REFERENCES receivers(receiver_id),
    blood_type VARCHAR(5) NOT NULL,
    units INTEGER NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_type VARCHAR(20) CHECK (transaction_type IN ('direct', 'from_inventory')) NOT NULL,
    notes TEXT
);
```

### Entity Relationship Diagram

```
┌─────────────┐         ┌──────────────┐
│    Users    │◄────────│    Donors    │
└─────────────┘         └──────────────┘
      │                        │
      │                        │
      │                        ▼
      │                 ┌──────────────┐
      │                 │ Blood        │
      │                 │ Inventory    │
      │                 └──────────────┘
      │                        │
      │                        │
      ▼                        ▼
┌─────────────┐         ┌──────────────┐
│  Receivers  │────────►│Transactions  │
└─────────────┘         └──────────────┘
```

---

## Security

### Authentication
- JWT-based token authentication
- Tokens expire after 24 hours (configurable)
- Passwords hashed using bcrypt with salt rounds
- Role-based access control (RBAC)

### Authorization
- Middleware decorators for route protection
- Role verification on protected endpoints
- User-specific data isolation

### Data Protection
- SQL injection prevention via SQLAlchemy ORM
- Input validation and sanitization
- CORS configuration for cross-origin requests
- Secure password requirements (minimum 8 characters)

### Best Practices
- Never commit sensitive credentials to repository
- Use environment variables for configuration
- Regular security audits recommended
- HTTPS recommended for production deployment

---

## Testing

### Manual Testing Checklist

**Authentication:**
- [ ] User registration (donor, receiver, admin)
- [ ] User login with valid credentials
- [ ] Login failure with invalid credentials
- [ ] Token expiration handling

**Donor Module:**
- [ ] View dashboard and profile
- [ ] Check donation eligibility
- [ ] Donate to inventory
- [ ] Direct donation to receiver
- [ ] View donation history

**Receiver Module:**
- [ ] View dashboard and profile
- [ ] Check available inventory
- [ ] Submit blood request
- [ ] View matching donors
- [ ] View request history

**Admin Module:**
- [ ] View dashboard statistics
- [ ] Manage users (view, delete)
- [ ] Manage inventory (add, update, delete)
- [ ] View all transactions

### Using Postman

Import the provided Postman collection for automated API testing.

<img width="1920" height="1020" alt="Screenshot 2025-11-22 190437" src="https://github.com/user-attachments/assets/1456c182-df48-42c7-930f-5e99d6ec3a7b" />

---

## Known Issues & Limitations

- Blood expiry alerts are visual only (no automated notifications)
- No email/SMS notification system implemented
- Direct donor-receiver communication not supported
- No appointment scheduling for donations
- Limited reporting and analytics features

---

## Future Enhancements

- [ ] Email/SMS notification system
- [ ] Appointment scheduling for blood donations
- [ ] Real-time chat between donors and receivers
- [ ] Mobile application (iOS/Android)
- [ ] Advanced analytics and reporting dashboard
- [ ] Multi-language support
- [ ] Blood drive campaign management
- [ ] Integration with hospital systems
- [ ] QR code-based blood bag tracking
- [ ] Machine learning for demand prediction

---

### Code Style
- Follow PEP 8 for Python code
- Use meaningful variable and function names
- Add comments for complex logic
- Write docstrings for functions and classes

---

## Author
https://github.com/abishek-rajeshkanna

---

## Acknowledgments

- Blood type compatibility matrix based on medical standards
- Flask documentation and community
- PostgreSQL documentation
- All contributors and testers
