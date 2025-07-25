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
    apiKey: 'AIzaSyAdE_BQcNrBNnejfllQhs6VXi3cnfKNcoA',
    appId: '1:791263528694:web:64318748652b2d7d564ed7',
    messagingSenderId: '791263528694',
    projectId: 'faith-path-m0fng',
    authDomain: 'faith-path-m0fng.firebaseapp.com',
    storageBucket: 'faith-path-m0fng.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBaIgUzxwYOLPq_5sTarh6L2LCgKUj9knw',
    appId: '1:791263528694:android:37ca58207484f48a564ed7',
    messagingSenderId: '791263528694',
    projectId: 'faith-path-m0fng',
    storageBucket: 'faith-path-m0fng.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDO-cBGQF1IelCQetlHFYtVI8GX0HYHcQ4',
    appId: '1:791263528694:ios:0b8f112a5eb1493a564ed7',
    messagingSenderId: '791263528694',
    projectId: 'faith-path-m0fng',
    storageBucket: 'faith-path-m0fng.firebasestorage.app',
    iosBundleId: 'com.example.ttiApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDO-cBGQF1IelCQetlHFYtVI8GX0HYHcQ4',
    appId: '1:791263528694:ios:0b8f112a5eb1493a564ed7',
    messagingSenderId: '791263528694',
    projectId: 'faith-path-m0fng',
    storageBucket: 'faith-path-m0fng.firebasestorage.app',
    iosBundleId: 'com.example.ttiApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAdE_BQcNrBNnejfllQhs6VXi3cnfKNcoA',
    appId: '1:791263528694:web:ad5bf79e0be4a083564ed7',
    messagingSenderId: '791263528694',
    projectId: 'faith-path-m0fng',
    authDomain: 'faith-path-m0fng.firebaseapp.com',
    storageBucket: 'faith-path-m0fng.firebasestorage.app',
  );
}
