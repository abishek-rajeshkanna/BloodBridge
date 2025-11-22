# Blood compatibility matrix
COMPATIBILITY = {
    'A+': ['A+', 'A-', 'O+', 'O-'],
    'A-': ['A-', 'O-'],
    'B+': ['B+', 'B-', 'O+', 'O-'],
    'B-': ['B-', 'O-'],
    'AB+': ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
    'AB-': ['A-', 'B-', 'AB-', 'O-'],
    'O+': ['O+', 'O-'],
    'O-': ['O-']
}

def can_receive_from(receiver_blood_type, donor_blood_type):
    """Check if receiver can receive blood from donor"""
    return donor_blood_type in COMPATIBILITY.get(receiver_blood_type, [])

def get_compatible_donors(receiver_blood_type):
    """Get list of compatible donor blood types for a receiver"""
    return COMPATIBILITY.get(receiver_blood_type, [])

def get_compatible_receivers(donor_blood_type):
    """Get list of blood types that can receive from this donor"""
    compatible = []
    for receiver_type, donors in COMPATIBILITY.items():
        if donor_blood_type in donors:
            compatible.append(receiver_type)
    return compatible