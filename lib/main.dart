import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellupadmin/providers/app_states.dart';
import 'package:sellupadmin/providers/product_provider.dart';
import 'package:sellupadmin/screens/admin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sellupadmin/screens/sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AppState()),
      ChangeNotifierProvider.value(value: ProductProvider()),

    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignIn(),
    ),
  ));
}

