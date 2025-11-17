# Firebase Setup Instructions

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project" and follow the wizard
3. Once created, you'll see "Get started by adding Firebase to your app"

## Step 2: Add Android App

1. Click on Android icon
2. Enter:
   - Android package name: `com.yourcompany.mydoctor` (or your actual package name)
   - App nickname: `My Doctor`
   - Debug signing certificate: Optional for now
3. Download `google-services.json`
4. Place it in: `android/app/` directory

## Step 3: Add iOS App

1. Click on iOS icon
2. Enter:
   - iOS bundle ID: `com.yourcompany.mydoctor` (or your actual bundle ID)
   - App nickname: `My Doctor`
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/` directory
5. In Xcode, right-click on Runner folder → Add files → select the plist file
6. Make sure "Copy items if needed" is checked

## Step 4: Install Dependencies

Run this command:
```bash
flutter pub get
```

## Step 5: Generate Firebase Options (Optional - for newer Flutter versions)

Run:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This will automatically generate the `firebase_options.dart` file and configure your apps.
