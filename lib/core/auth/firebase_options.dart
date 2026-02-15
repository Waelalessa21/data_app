import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError('Unsupported platform');
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBH4XPgmGdNhxSIf8_XNrXOrBtfMEXQiRA',
    appId: '1:819330709409:web:e7602ba913d230bcc3fde0',
    messagingSenderId: '819330709409',
    projectId: 'text-to-sql-409da',
    authDomain: 'text-to-sql-409da.firebaseapp.com',
    storageBucket: 'text-to-sql-409da.firebasestorage.app',
    measurementId: 'G-1E2Z2EH4VE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBH4XPgmGdNhxSIf8_XNrXOrBtfMEXQiRA',
    appId: '1:819330709409:android:placeholder',
    messagingSenderId: '819330709409',
    projectId: 'text-to-sql-409da',
    storageBucket: 'text-to-sql-409da.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBH4XPgmGdNhxSIf8_XNrXOrBtfMEXQiRA',
    appId: '1:819330709409:ios:placeholder',
    messagingSenderId: '819330709409',
    projectId: 'text-to-sql-409da',
    storageBucket: 'text-to-sql-409da.firebasestorage.app',
    iosBundleId: 'com.example.dataApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBH4XPgmGdNhxSIf8_XNrXOrBtfMEXQiRA',
    appId: '1:819330709409:ios:placeholder',
    messagingSenderId: '819330709409',
    projectId: 'text-to-sql-409da',
    storageBucket: 'text-to-sql-409da.firebasestorage.app',
    iosBundleId: 'com.example.dataApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBH4XPgmGdNhxSIf8_XNrXOrBtfMEXQiRA',
    appId: '1:819330709409:web:e7602ba913d230bcc3fde0',
    messagingSenderId: '819330709409',
    projectId: 'text-to-sql-409da',
    authDomain: 'text-to-sql-409da.firebaseapp.com',
    storageBucket: 'text-to-sql-409da.firebasestorage.app',
  );
}
