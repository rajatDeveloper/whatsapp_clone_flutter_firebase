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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZYZctQ__dXsLWcbrljmRb9PBsOmNriIs',
    appId: '1:618226115239:android:4a6d8f8399d7c957813182',
    messagingSenderId: '618226115239',
    projectId: 'whatsapp-backend-2adca',
    storageBucket: 'whatsapp-backend-2adca.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAv0ZA7ALUg2xrJQIFg3_oBKXpxbVRcKGI',
    appId: '1:618226115239:ios:95d2d70fe1312161813182',
    messagingSenderId: '618226115239',
    projectId: 'whatsapp-backend-2adca',
    storageBucket: 'whatsapp-backend-2adca.appspot.com',
    androidClientId: '618226115239-g7f81vm8bi381fka7vnnlap046dlujok.apps.googleusercontent.com',
    iosClientId: '618226115239-s3p1t0jk2lkjta1cqa33l1he0qhujebh.apps.googleusercontent.com',
    iosBundleId: 'com.rdsoftware.whatschat',
  );
}
