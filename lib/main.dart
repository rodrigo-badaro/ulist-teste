import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ulist/app.dart';
import 'package:ulist/get_it.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupProviders();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

