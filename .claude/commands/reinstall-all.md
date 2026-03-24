# Reinstall and Launch App on All Platforms

Clean reinstall and launch the StreamShaala app on all available platforms, emulators, and connected devices:

## Steps to Execute:

1. **Kill all running Flutter processes and app instances**
   - Kill all Flutter processes
   - Kill all iOS simulator Runner processes
   - Stop Android app on all connected devices
   - Close any Chrome instances if needed

2. **Clean the Flutter project**
   - Run `flutter clean` to remove build artifacts
   - Run `flutter pub get` to fetch dependencies

3. **Discover available devices**
   - Run `flutter devices` to list all available platforms
   - Identify: iOS simulators, Android emulators, connected physical devices, macOS, Chrome

4. **Uninstall from all devices**
   - Android devices: `adb uninstall com.streamshaala.streamshaala`
   - iOS simulators: `xcrun simctl uninstall [device-id] com.streamshaala.streamshaala`
   - Clean uninstall for each discovered device

5. **Install and launch on all platforms in parallel**
   - For each Android device/emulator: `flutter run -d [device-id] --uninstall-first` in background
   - For each iOS simulator: Clean uninstall then `flutter run -d [device-id]` in background
   - For macOS (if available): `flutter run -d macos` in background
   - For Chrome (if available): `flutter run -d chrome` in background

6. **Monitor installation progress**
   - Report success/failure for each device
   - Provide list of devices where app is running
   - Show any errors encountered

## Requirements:
- Use background processes for parallel installation
- Handle errors gracefully for unavailable platforms
- Provide clear progress updates
- Return summary of successful installations

## Success Criteria:
- App is cleanly uninstalled from all devices
- App is freshly installed and running on all available platforms
- All build artifacts are cleaned
- Dependencies are up to date
