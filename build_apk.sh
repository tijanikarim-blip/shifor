#!/bin/bash
set -e

echo "🚀 Shifor Android APK Build Script"
echo "=================================="

echo "📝 Step 1: Cleaning previous builds..."
flutter clean

echo "📦 Step 2: Getting dependencies..."
flutter pub get

echo "🔨 Step 3: Building APK in release mode..."
flutter build apk --release

echo ""
echo "✅ BUILD SUCCESSFUL!"
echo "=================================="
echo "📍 APK Location: build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "📱 Install on device: adb install build/app/outputs/flutter-apk/app-release.apk"
echo "🎯 Or: flutter install --release"
echo ""