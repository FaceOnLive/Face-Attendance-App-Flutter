# Firebase Setup Guide for Face Attendance Project

This guide will walk you through the process of setting up the Firebase database structure for the Face Attendance project on Mac, Windows, and Linux.

## Prerequisites

1. Python 3.7 or higher installed on your system
2. pip (Python package installer)
3. Git (optional, for cloning the repository)
4. A Google account
5. Firebase project created

## Setup Steps

### Step 1: Firebase Console Setup

1. Go to the Firebase Console (https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Enable Email/Password Authentication:
   - In the left sidebar, click on "Authentication"
   - Click on the "Sign-in method" tab
   - Enable the "Email/Password" sign-in provider
4. Set up Firestore:
   - In the left sidebar, click on "Firestore Database"
   - Click "Create database"
   - Choose "Start in production mode" or "Start in test mode" based on your needs
   - Select a location for your database
   - Click "Enable"

### Step 2: Clone or Download the Project

If you're using Git:
```
git clone https://github.com/FaceOnLive/Face-Attendance-App-Flutter
cd Face-Attendance-App-Flutter
```

If not using Git, download the project files and navigate to the project directory.

### Step 3: Set Up Python Environment

#### For Homebrew Python users on Mac:

1. Create a virtual environment:
   ```
   python3 -m venv face_attendance_env
   ```
2. Activate the virtual environment:
   ```
   source face_attendance_env/bin/activate
   ```

#### For Windows users:

1. Create a virtual environment:
   ```
   python -m venv face_attendance_env
   ```
2. Activate the virtual environment:
   ```
   face_attendance_env\Scripts\activate
   ```

#### For Linux users:

1. Create a virtual environment:
   ```
   python3 -m venv face_attendance_env
   ```
2. Activate the virtual environment:
   ```
   source face_attendance_env/bin/activate
   ```

### Step 4: Install Required Python Packages

With your virtual environment activated, run:
```
pip install firebase-admin
```

### Step 5: Prepare the Firebase Service Account Key

1. In the Firebase Console, go to Project settings > Service Accounts
2. Click "Generate new private key"
3. Save the JSON file as `serviceAccountKey.json` in the project directory

### Step 6: Run the Setup Script

With your virtual environment still activated:

#### On Mac or Linux:

```
python3 firebase_setup.py
```

#### On Windows:

```
python firebase_setup.py
```

### Step 7: Verify the Setup

1. Go to the Firebase Console
2. Navigate to Firestore Database
3. Check if the collections "Users", "Members", and "Spaces" have been created with sample data

## Troubleshooting

- If you get a "Module not found" error, ensure you've activated the virtual environment and installed the firebase-admin package.
- For Mac/Linux users: If you get a "python3: command not found" error, try using `python` instead of `python3`.
- If you encounter permission issues in Firestore, make sure you've set appropriate security rules in the Firebase Console.

## Security Notes

- Keep your `serviceAccountKey.json` file secure and never commit it to a public repository.
- In production, set up proper Firestore security rules to protect your data.

## Next Steps

After successfully running the setup script, your Firebase Firestore database will be populated with sample data for the Face Attendance project. You can now proceed with connecting your Flutter application to this Firebase backend.

## Cleaning Up

When you're done, deactivate the virtual environment:
```
deactivate
```

For any issues or questions, please refer to the project's documentation or contact the project maintainers.