# Android Build Guide

This guide provides detailed steps for building and deploying an Android APK from the source code of the project.

## Prerequisites

Before you start, ensure you have the following installed:
- JDK (Java Development Kit) 8 or later
- Android Studio
- Gradle (if not included with Android Studio)

## Steps to Build the APK

1. **Clone the Repository**  
   If you haven't already, clone the repository to your local machine:
   ```bash
   git clone https://github.com/tijanikarim-blip/shifor.git
   cd shifor
   ```

2. **Open the Project in Android Studio**  
   Launch Android Studio and open the project by navigating to the cloned folder.

3. **Build the Project**  
   - Select `Build` from the top menu.
   - Choose `Make Project` or use the shortcut `Ctrl + F9` (Windows/Linux) or `Cmd + F9` (macOS).

4. **Generate the APK**  
   - Go to `Build` -> `Build Bundle(s)/APK` -> `Build APK(s)`.
   - Wait for the build process to finish.
   - A notification will appear once the APK is generated, click on it to locate the APK file.

5. **Locate the APK**  
   By default, the APK can be found in:
   ```plaintext
   <project-dir>/app/build/outputs/apk/debug/app-debug.apk
   ```

## Steps to Deploy the APK

There are multiple ways to deploy your APK:

### 1. **Deploy to a Physical Device**
   - Connect your Android device to your computer via USB.
   - Enable `USB Debugging` on your device in `Settings` -> `Developer Options`.
   - Run the following command in the terminal:
   ```bash
   adb install -r app/build/outputs/apk/debug/app-debug.apk
   ```

### 2. **Deploy to an Emulator**
   - Start an Android Emulator using Android Studio.
   - Run the same `adb install` command:
   ```bash
   adb install -r app/build/outputs/apk/debug/app-debug.apk
   ```

### 3. **Distributing APK**
   - Share the APK file generated in the `outputs` directory with users directly, or use platforms like Google Play for distribution.

## Troubleshooting

- **Build Errors**: Make sure all dependencies are correctly defined in the `build.gradle` files.
- **Installation Errors**: Ensure that your device allows installations from unknown sources if the APK is not from Google Play.

## Conclusion

You have successfully built and deployed your Android APK! For further assistance, refer to the [Android Developer Documentation](https://developer.android.com/docs).