HeavyFreight App
Overview
The HeavyFreight App is a Flutter-based mobile application designed to streamline freight transportation by connecting clients and drivers. Clients can create delivery requests by providing pickup and drop-off locations, package sizes, and delivery types, while drivers can view and accept available jobs. The app features a user-friendly interface with OTP-based authentication, Google Maps integration for location tracking, and a responsive design suitable for both iOS and Android platforms.
Features

User Roles:
Clients: Create and track delivery requests.
Drivers: View available jobs, accept jobs, and manage their dashboard.


Authentication: OTP-based login using phone number verification (mocked for development).
Google Maps Integration: Display pickup and drop-off locations with markers.
Job Management: Drivers can view job details (pickup, drop-off, size, pay) and accept jobs with confirmation messages.
Responsive UI: Consistent design with a dark theme, white containers, and rounded corners, optimized for various screen sizes.
State Management: Uses Riverpod for efficient state management across screens.

Project Structure
The app follows a clean architecture with a feature-based folder structure for scalability and maintainability:
lib/
  core/
    constants/
      app_colors.dart        # App-wide color constants
    widgets/
      custom_button.dart     # Reusable button widget
  features/
    auth/
      presentation/
        screens/
          phone_screen.dart  # Phone number entry screen
          otp_screen.dart    # OTP verification screen
      providers/
        auth_provider.dart  # Authentication state management
    driver/
      data/
        repository/
          driver_repository.dart  # Mock data for driver jobs
      presentation/
        provider/
          driver_provider.dart    # State management for driver jobs
        screens/
          driver_screen.dart      # Driver dashboard
        viewmodel/
          driver_viewmodel.dart   # Business logic for driver feature
    package_form/
      presentation/
        screens/
          package_form_screen.dart  # Client package creation screen
    tracking/
      presentation/
        screens/
          tracking_screen.dart      # Delivery tracking screen
  main.dart                         # App entry point

Prerequisites

Flutter: Ensure Flutter is installed (version 3.7.2 or higher).
Dart: Included with Flutter (version compatible with Flutter SDK).
IDE: Android Studio, VS Code, or any IDE with Flutter support.
Emulator/Device: An Android/iOS emulator or physical device for testing.
Google Maps API Key: Required for Google Maps integration (set up in .env).

Setup Instructions
1. Clone the Repository
git clone https://github.com/your-repo/mohamed_amine_benkhoud_heavyfreight_flutter_test.git
cd mohamed_amine_benkhoud_heavyfreight_flutter_test

2. Install Dependencies
Run the following command to install all required packages:
flutter pub get

3. Configure Environment Variables

Create a .env file in the root directory if it doesn’t exist.
Add your Google Maps API key:GOOGLE_MAPS_API_KEY=your_api_key_here   


Ensure the .env file is listed in pubspec.yaml under assets.

4. Run the App

Connect an emulator or physical device.
Run the app using:flutter run


The app will launch on your device/emulator, starting with the LandingScreen.

How to Use the App

Landing Screen:
Choose your role: "Connect as Client" or "Connect as Driver".


Authentication:
Enter your phone number on the PhoneScreen.
Receive an OTP (mocked in development; enter any 4-digit code like 1234).
Verify the OTP on the OTPScreen.


Client Flow:
After OTP verification, clients are directed to the PackageFormScreen to create a delivery request.
Fill in details (pickup, drop-off, size, delivery type) and confirm to track the delivery on the TrackingScreen.


Driver Flow:
After OTP verification, drivers are directed to the DriverScreen.
View available jobs with details (pickup, drop-off, size, pay).
Accept a job using the "Accept Job" button, which shows a confirmation message.



Approach and Assumptions
Development Approach

Architecture: Followed a feature-based clean architecture with MVVM pattern for separation of concerns.
State Management: Used flutter_riverpod for reactive state management, ensuring scalability.
UI Design: Consistent dark theme with white containers, rounded corners, and orange accents (AppColors.primaryOrange).
Navigation: Used Flutter’s Navigator with push and pushReplacement to manage screen transitions.
Error Handling: Basic error handling for job fetching and OTP verification with user feedback via SnackBar.

Assumptions

Mock Data:
OTP authentication is mocked; any 4-digit code (e.g., 1234) will work for development.
Driver jobs are mocked in DriverRepository with static data (e.g., pickup/drop-off locations, sizes, pay).


Google Maps:
A valid Google Maps API key is required in .env for map functionality.
Location permissions are handled by geolocator and geocoding packages.


Assets:
All assets (e.g., mainbg.jpg, size icons) are assumed to be in the assets/ directory and listed in pubspec.yaml.


Dependencies:
All listed dependencies in pubspec.yaml are assumed to be compatible and up-to-date.




Dependencies
The app uses the following key dependencies (see pubspec.yaml for full list):

flutter_riverpod: ^2.6.1 - For state management.
intl_phone_field: ^3.2.0 - For phone number input with country codes.
google_maps_flutter: ^2.12.2 - For displaying maps and markers.
geolocator: ^14.0.1 & geocoding: ^4.0.0 - For location services.
http: ^1.4.0 - For future API integration (not used in current mock setup).
flutter_dotenv: ^5.2.1 - For managing environment variables.



Email: aminebenkhoud@gmail.com
GitHub: amine04bk


Last Updated: June 06, 2025
