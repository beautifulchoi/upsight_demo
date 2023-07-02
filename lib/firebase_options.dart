// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA-FxTV0r3Nb5iI5RY6LUV9_QeYg7examE',
    appId: '1:193431955629:web:e1ddafa7afacd9500e3e24',
    messagingSenderId: '193431955629',
    projectId: 'flutter-board-firebase-fcbbf',
    authDomain: 'flutter-board-firebase-fcbbf.firebaseapp.com',
    storageBucket: 'flutter-board-firebase-fcbbf.appspot.com',
    measurementId: 'G-BKJ56YV86Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTbWyogkR19NixVBO_pOc3ynytIAgHToM',
    appId: '1:193431955629:android:9757f0a8daf290090e3e24',
    messagingSenderId: '193431955629',
    projectId: 'flutter-board-firebase-fcbbf',
    storageBucket: 'flutter-board-firebase-fcbbf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcmoujCSgt5Rl-WBFUNRTNItLygYEYrBA',
    appId: '1:193431955629:ios:9943eaf8e8b95ca60e3e24',
    messagingSenderId: '193431955629',
    projectId: 'flutter-board-firebase-fcbbf',
    storageBucket: 'flutter-board-firebase-fcbbf.appspot.com',
    iosClientId: '193431955629-tjbmscs139j2ck95iup3blqr0jq9slbf.apps.googleusercontent.com',
    iosBundleId: 'com.example.boardProject',
  );
}
