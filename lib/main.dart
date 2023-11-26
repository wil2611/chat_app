import 'package:chat_app/config/configuration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';

import 'ui/my_app.dart';

Future<void> main() async {
  // this is the key
  WidgetsFlutterBinding.ensureInitialized();
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: Configuration.apiKey,
      authDomain: Configuration.authDomain,
      databaseURL: Configuration.databaseURL,
      projectId: Configuration.projectId,
      storageBucket: Configuration.storageBucket,
      messagingSenderId: Configuration.messagingSenderId,
      appId: Configuration.appId,
    ),
  );
  runApp(MyApp());
}
