[![Download](https://img.shields.io/github/v/release/sb745/VocaDB-X)](https://github.com/sb745/VocaDB-X/releases)
![Maintenance](https://img.shields.io/maintenance/yes/2025)

# VocaDB X
Fork of the original [VocaDB mobile app](https://github.com/VocaDB/VocaDB-App). Runs on Android 5.0 and above.

![Screenshot](/assets/store/VocaDB/android/vocadb_x_demo.gif)

## What's changed in the fork
 - Updated from Flutter 2 to 3
 - Updated all dependencies
 - Updated target SDK version
 - Properly implemented login
 - Added comments page
 - Many other small fixes and improvements

## Download

You can find the latest version on the [release page](https://github.com/sb745/VocaDB-X/releases).

## Build
### Setup for development
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio)
```shell
flutter pub get
flutter build apk --release
```

## UI Translation

Translation files in are located `lib/src/i18n`. File should be named `{language code}.dart` or `{language_code}_{country_code}.dart`.

Feel free to pull request more languages if you'd like to contribute!

## License
Code is licensed under the [MIT License](LICENSE). Assets are licensed under [CC-BY 4.0](LICENSE-ASSETS).

Please check the [VocaDB Wiki](https://wiki.vocadb.net/docs/license) for more info regarding licensing.