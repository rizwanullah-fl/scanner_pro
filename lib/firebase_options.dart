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
    apiKey: 'AIzaSyDGXyD9nCVTOnbC8Zwu64xUA_4OyiSKZXM',
    appId: '1:167587454567:web:5cc44c4c5461828a3c3ec2',
    messagingSenderId: '167587454567',
    projectId: 'emailsigin-92905',
    authDomain: 'emailsigin-92905.firebaseapp.com',
    databaseURL: 'https://emailsigin-92905-default-rtdb.firebaseio.com',
    storageBucket: 'emailsigin-92905.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUqAf57rXkVDLrIyFRNvsbg8m0k9Rl0A4',
    appId: '1:167587454567:android:f4ceee72ce9d355c3c3ec2',
    messagingSenderId: '167587454567',
    projectId: 'emailsigin-92905',
    databaseURL: 'https://emailsigin-92905-default-rtdb.firebaseio.com',
    storageBucket: 'emailsigin-92905.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDc8d--hwiH2XnbxSir3e4-6ryJ52sAgV0',
    appId: '1:167587454567:ios:a54af829dbe09ff63c3ec2',
    messagingSenderId: '167587454567',
    projectId: 'emailsigin-92905',
    databaseURL: 'https://emailsigin-92905-default-rtdb.firebaseio.com',
    storageBucket: 'emailsigin-92905.appspot.com',
    iosBundleId: 'com.example.scanner',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDc8d--hwiH2XnbxSir3e4-6ryJ52sAgV0',
    appId: '1:167587454567:ios:593fb3305433b1cf3c3ec2',
    messagingSenderId: '167587454567',
    projectId: 'emailsigin-92905',
    databaseURL: 'https://emailsigin-92905-default-rtdb.firebaseio.com',
    storageBucket: 'emailsigin-92905.appspot.com',
    iosBundleId: 'com.example.scanner.RunnerTests',
  );
}