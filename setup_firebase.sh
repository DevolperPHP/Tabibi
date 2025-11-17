#!/bin/bash

# Firebase Setup Script
# This script will automatically configure Firebase for your project

echo "🔥 Firebase Setup Script"
echo "========================"
echo ""

# Check if required files exist
if [ ! -f "google-services.json" ]; then
    echo "❌ Error: google-services.json not found!"
    echo "Please download it from Firebase Console → Android app → google-services.json"
    exit 1
fi

if [ ! -f "GoogleService-Info.plist" ]; then
    echo "❌ Error: GoogleService-Info.plist not found!"
    echo "Please download it from Firebase Console → iOS app → GoogleService-Info.plist"
    exit 1
fi

if [ ! -f "serviceAccountKey.json" ]; then
    echo "❌ Error: serviceAccountKey.json not found!"
    echo "Please download it from Firebase Console → Settings → Service Accounts → Generate Key"
    exit 1
fi

echo "✅ All required files found!"
echo ""

# Place Android config
echo "📱 Configuring Android..."
cp google-services.json android/app/
echo "✅ google-services.json placed in android/app/"
echo ""

# Place iOS config
echo "🍎 Configuring iOS..."
cp GoogleService-Info.plist ios/Runner/
echo "✅ GoogleService-Info.plist placed in ios/Runner/"
echo ""

# Place backend service account
echo "🔧 Configuring Backend..."
mkdir -p tabibi-backend/config
cp serviceAccountKey.json tabibi-backend/config/
echo "✅ serviceAccountKey.json placed in tabibi-backend/config/"
echo ""

# Add to gitignore
echo "📝 Adding to .gitignore..."
if [ -f "tabibi-backend/.gitignore" ]; then
    if ! grep -q "serviceAccountKey.json" tabibi-backend/.gitignore; then
        echo "config/serviceAccountKey.json" >> tabibi-backend/.gitignore
        echo "✅ Added to .gitignore"
    fi
fi

# Install Flutter dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get
echo ""

# Install backend dependencies
echo "📦 Installing backend dependencies..."
cd tabibi-backend
npm install
cd ..
echo ""

# Build app
echo "🔨 Building Flutter app..."
flutter build apk --release
echo ""

echo "✅ Firebase setup complete!"
echo ""
echo "Next steps:"
echo "1. Deploy backend: cd tabibi-backend && npm start"
echo "2. Test app: flutter run"
echo ""
