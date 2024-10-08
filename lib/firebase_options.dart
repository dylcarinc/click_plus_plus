// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC1_ixtNObUjzye9zSLlPtuXjLyPv4Oybo',
    appId: '1:1079471952758:web:a9f3faec5bc1d7d721a057',
    messagingSenderId: '1079471952758',
    projectId: 'clickplusplus-75d64',
    authDomain: 'clickplusplus-75d64.firebaseapp.com',
    storageBucket: 'clickplusplus-75d64.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAxG0gL2A_Bthf949TZ0iI8jQWIB5WHQ74',
    appId: '1:1079471952758:android:29b4e13011883c9a21a057',
    messagingSenderId: '1079471952758',
    projectId: 'clickplusplus-75d64',
    storageBucket: 'clickplusplus-75d64.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0wITGmFeQlNpU2Qpa_O5TW_Cd-Lf5Qzo',
    appId: '1:1079471952758:ios:a080e0fac01f45eb21a057',
    messagingSenderId: '1079471952758',
    projectId: 'clickplusplus-75d64',
    storageBucket: 'clickplusplus-75d64.appspot.com',
    iosBundleId: 'com.example.clickPlusPlus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD0wITGmFeQlNpU2Qpa_O5TW_Cd-Lf5Qzo',
    appId: '1:1079471952758:ios:a080e0fac01f45eb21a057',
    messagingSenderId: '1079471952758',
    projectId: 'clickplusplus-75d64',
    storageBucket: 'clickplusplus-75d64.appspot.com',
    iosBundleId: 'com.example.clickPlusPlus',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC1_ixtNObUjzye9zSLlPtuXjLyPv4Oybo',
    appId: '1:1079471952758:web:baf9f1ecbce345c521a057',
    messagingSenderId: '1079471952758',
    projectId: 'clickplusplus-75d64',
    authDomain: 'clickplusplus-75d64.firebaseapp.com',
    storageBucket: 'clickplusplus-75d64.appspot.com',
  );
}
