
# DoverColl- A Waste Management Application

## Overview

**DoverColl** is a mobile application developed using Flutter to improve waste management processes. The application provides users with various functionalities, including waste collection booking, real-time navigation, feedback, historical data tracking, invoicing, and payment. It also incorporates sensor notifications to monitor waste levels and delivers sustainability content.

## Features

**User Registration and Login**: Secure and easy registration process for new users. Existing users can log in with their credentials.

**Collection Services**: Users can schedule waste collection services based on their location and preferred time.

**Navigation**: The application provides real-time navigation for collectors to navigate to households.

**Feedback System**: Users can provide feedback on the services received to help improve the overall quality of the service.

**History Tracking**: Keeps a record of past bookings and services for user reference.

**Invoicing and Payment**: Users can view invoices for the services rendered and make payments directly through the app.

**Sensor Notifications**: Alerts are sent to users when their waste levels reach a certain threshold, prompting them to book a collection service.

**Sustainability Information**: Provides users with tips and data on how to manage waste sustainably.


## Technical Stack

- **Frontend:** Flutter
  - Dart programming language
  - Google Maps SDK for Flutter
  - Firebase Authentication
  - Firebase Realtime Database / Firestore

- **Backend:**
  - Flask
  - Firebase Realtime Database / Firestore for real-time data syncing

- **Payment Integration:** 
  - Paystack

- **Push Notifications:** 
  - OneSignal

## Setup and Installation

### Prerequisites
- Flutter SDK installed
- A Firebase project set up with Authentication, Firestore/Realtime Database
- A Google Maps API key
- Paystack for payment processing


### Installation Steps

1. **Clone the Repository:**
   \`\`\`bash
   git clone 
   cd DoverColl
   \`\`\`

2. **Install Dependencies:**
   \`\`\`bash
   flutter pub get
   \`\`\`

3. **Configure Firebase:**
   - Download the \`google-services.json\` file from your Firebase project and place it in the \`android/app\` directory.
   - Download the \`GoogleService-Info.plist\` file and place it in the \`ios/Runner\` directory.

4. **Configure Google Maps API:**
   - Add your Google Maps API key to the \`android/app/src/main/AndroidManifest.xml\` and \`ios/Runner/AppDelegate.swift\`.

5. **Run the App:**
   \`\`\`bash
   flutter run
   \`\`\`

### Testing
- Use unnitest for Flask API testing
- Use the Flutter testing framework to write unit and widget tests.
- Use the Firebase emulator suite to test Firebase-related functionalities locally.

### Deployment

1. **Build for Android:**
   \`\`\`bash
   flutter build apk
   \`\`\`

2. **Build for iOS:**
   \`\`\`bash
   flutter build ios
   \`\`\`



## Project Structure
├── controllers/
│   ├── booking_controller.dart         # Handles operations related to bookings
│   ├── collector_controller.dart       # Manages functions related to waste collectors
│   ├── sensor_controller.dart          # Controls sensor data processing and notifications
│   ├── user_controller.dart            # Manages user-related operations and data
│
├── models/
│   ├── booking_model.dart              # Data model for bookings
│   ├── collector_model.dart            # Data model for collectors
│   ├── directions.dart                 # Handles direction-related data and operations
│   ├── sensor_model.dart               # Data model for sensors
│   ├── user_model.dart                 # Data model for users
│
├── services/
│   ├── api_service.dart                # Handles API requests and responses
│   ├── booking_service.dart            # Service for handling bookings
│   ├── sensor_service.dart             # Service for managing sensors and their data
│   ├── user_service.dart               # Service for user-related operations
│   ├── waste_collector_service.dart    # Service for waste collector functionalities
│   ├── waste_practices_service.dart    # Service focused on waste management practices
│
├── utils/
│   ├── constants.dart                  # Defines constants used throughout the app
│   ├── helpers.dart                    # Contains helper functions used across the app
│   ├── profile_type.dart               # Manages different user profile types
│   ├── state_management.dart           # Handles state management within the app
│
├── views/
│   ├── collector_history.dart          # UI for displaying a collector's history
│   ├── collector_home_page.dart        # Home page UI for collectors
│   ├── collector_main_page.dart        # Main page UI for collectors
│   ├── contact_card.dart               # UI component for displaying contact information
│   ├── history_cards.dart              # UI component for displaying history items
│   ├── home_page.dart                  # Main user home page UI
│   ├── login.dart                      # UI for the login screen
│   ├── main_page.dart                  # UI for the main navigation page
│   ├── notifications.dart              # UI for managing and displaying notifications
│   ├── payment.dart                    # UI for the payment processing screen
│   ├── profile_page.dart               # UI for the user's profile page
│   ├── register.dart                   # UI for the registration screen
│   ├── user_history.dart               # UI for displaying a user's history


## License

This project is licensed under the MIT License - see the \`LICENSE\` file for details.

## Contact

If you have any questions, feel free to reach out to bernd.opoku.boadu@gmail.com

