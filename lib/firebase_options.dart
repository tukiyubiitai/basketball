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
        return macos;
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
    apiKey: 'AIzaSyDe9Ov99yromnwTxztEOFFXoxeE_rxtFZQ',
    appId: '1:1007612328339:web:bc28ea9deac99914659066',
    messagingSenderId: '1007612328339',
    projectId: 'basketball-app-d033d',
    authDomain: 'basketball-app-d033d.firebaseapp.com',
    storageBucket: 'basketball-app-d033d.appspot.com',
    measurementId: 'G-SG4DX364T9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtNWT2aEtnVFKl00NeFavQMf_YTSaNi2w',
    appId: '1:1007612328339:android:fcc5f3ce53b8c0b5659066',
    messagingSenderId: '1007612328339',
    projectId: 'basketball-app-d033d',
    storageBucket: 'basketball-app-d033d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDzGNu5FsyDv0x0ef8xgjwgMXTq6SYKzs8',
    appId: '1:1007612328339:ios:8b300be20fa1584c659066',
    messagingSenderId: '1007612328339',
    projectId: 'basketball-app-d033d',
    storageBucket: 'basketball-app-d033d.appspot.com',
    iosBundleId: 'com.Basket.link',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDzGNu5FsyDv0x0ef8xgjwgMXTq6SYKzs8',
    appId: '1:1007612328339:ios:434d6af85b2054bc659066',
    messagingSenderId: '1007612328339',
    projectId: 'basketball-app-d033d',
    storageBucket: 'basketball-app-d033d.appspot.com',
    iosBundleId: 'com.example.searchMassage',
  );
}
