import firebase_admin
from firebase_admin import credentials, auth, firestore
import uuid
import random
import os

# Initialize Firebase app
# Use os.path.join for cross-platform compatibility
cred = credentials.Certificate(os.path.join(os.path.dirname(__file__), "serviceAccountKey.json"))
firebase_admin.initialize_app(cred)

db = firestore.client()

# Sample data
SAMPLE_USERS = [
    {
        "email": "admin@example.com",
        "password": "adminPass123!",
        "displayName": "Alex Johnson",
        "isAdmin": True,
        "address": "1234 Admin St, Adminville, CA 90210",
        "phone": "5551234567",
        "holiday": 0
    },
    {
        "email": "sarah.smith@example.com",
        "password": "sarahPass456!",
        "displayName": "Sarah Smith",
        "isAdmin": False,
        "address": "5678 Oak Ave, Springfield, IL 62701",
        "phone": "5552345678",
        "holiday": 6
    },
    {
        "email": "michael.brown@example.com",
        "password": "mikePass789!",
        "displayName": "Michael Brown",
        "isAdmin": False,
        "address": "9101 Pine Rd, Riverside, TX 77801",
        "phone": "5553456789",
        "holiday": 6
    },
    {
        "email": "emily.davis@example.com",
        "password": "emilyPass101!",
        "displayName": "Emily Davis",
        "isAdmin": False,
        "address": "1122 Maple Ln, Lakeside, FL 33801",
        "phone": "5554567890",
        "holiday": 6
    },
    {
        "email": "david.wilson@example.com",
        "password": "davidPass202!",
        "displayName": "David Wilson",
        "isAdmin": False,
        "address": "3344 Cedar Blvd, Mountain View, CO 80401",
        "phone": "5555678901",
        "holiday": 6
    }
]

SAMPLE_MEMBERS = [
    {
        "memberName": "Olivia Taylor",
        "memberFullAddress": "7788 Birch St, Sunnyside, WA 98944",
        "memberNumber": "5556789012"
    },
    {
        "memberName": "Ethan Anderson",
        "memberFullAddress": "9900 Elm Ave, Hilltown, NY 14741",
        "memberNumber": "5557890123"
    },
    {
        "memberName": "Sophia Martinez",
        "memberFullAddress": "1122 Willow Rd, Valleyville, AZ 85001",
        "memberNumber": "5558901234"
    },
    {
        "memberName": "Liam Thompson",
        "memberFullAddress": "3344 Aspen Ct, Mountainburg, OR 97101",
        "memberNumber": "5559012345"
    },
    {
        "memberName": "Ava Rodriguez",
        "memberFullAddress": "5566 Redwood Dr, Coastville, NC 28401",
        "memberNumber": "5550123456"
    }
]

def create_user_with_auth(user_data):
    try:
        user = auth.create_user(
            email=user_data['email'],
            password=user_data['password'],
            display_name=user_data['displayName']
        )
        print(f"Created authenticated user: {user.uid}")
        
        user_doc_data = {
            'address': user_data['address'],
            'name': user_data['displayName'],
            'email': user_data['email'],
            'deviceIDToken': str(uuid.uuid4()),
            'holiday': user_data['holiday'],
            'notification': random.choice([True, False]),
            'phone': user_data['phone'],
            'userFace': f"https://example.com/{user_data['displayName'].lower().replace(' ', '_')}_face.jpg",
            'userProfilePicture': f"https://example.com/{user_data['displayName'].lower().replace(' ', '_')}_profile.jpg",
            'isAdmin': user_data['isAdmin'],
            'userID': user.uid,
            'attendance': []
        }
        
        db.collection('Users').document(user.uid).set(user_doc_data)
        print(f"Added user data to Firestore for: {user.uid}")
        
        return user.uid
    except Exception as e:
        print(f"Error creating user {user_data['email']}: {str(e)}")
        return None

def create_member(member_data, created_by_admin_uid):
    member_doc_data = {
        'memberFullAddress': member_data['memberFullAddress'],
        'memberName': member_data['memberName'],
        'memberNumber': member_data['memberNumber'],
        'memberPicture': f"https://example.com/{member_data['memberName'].lower().replace(' ', '_')}_picture.jpg",
        'attendance': [],
        'createdBy': created_by_admin_uid
    }
    
    member_ref = db.collection('Members').add(member_doc_data)
    print(f"Created member: {member_ref[1].id}")
    return member_ref[1].id

def create_space(name, owner_uid, app_members, custom_members):
    space_data = {
        'appMembers': app_members,
        'icon': f'https://example.com/{name.lower().replace(" ", "_")}_icon.png',
        'memberList': custom_members,
        'name': name,
        'ownerUID': owner_uid,
        'spaceLat': random.uniform(25.0, 48.0),  # Random latitude within continental US
        'spaceLon': random.uniform(-125.0, -65.0),  # Random longitude within continental US
        'spaceRadius': random.randint(100, 5000),  # Random radius between 100 and 5000 meters
        'spaceID': str(uuid.uuid4())
    }
    
    space_ref = db.collection('Spaces').add(space_data)
    print(f"Created space: {space_ref[1].id}")
    return space_ref[1].id

# Run the setup
if __name__ == "__main__":
    user_ids = []
    admin_uid = None
    
    # Create users
    for user in SAMPLE_USERS:
        uid = create_user_with_auth(user)
        if uid:
            user_ids.append(uid)
            if user['isAdmin']:
                admin_uid = uid
    
    if not admin_uid:
        print("No admin user created. Exiting.")
        exit(1)
    
    # Create members
    member_ids = []
    for member in SAMPLE_MEMBERS:
        member_id = create_member(member, admin_uid)
        if member_id:
            member_ids.append(member_id)
    
    # Create spaces
    space_names = ["Work Office", "Fitness Center", "Book Club", "Neighborhood Watch", "Volunteer Group"]
    for space_name in space_names:
        space_members = random.sample(user_ids, random.randint(2, len(user_ids)))
        space_custom_members = random.sample(member_ids, random.randint(1, len(member_ids)))
        space_id = create_space(space_name, random.choice(user_ids), space_members, space_custom_members)
    
    print("Firebase authentication and database structure created successfully with sample data")