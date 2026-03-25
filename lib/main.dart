import 'package:flutter/material.dart';
import 'screen/login_register.dart';
import 'screen/test.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:prototype_sagip/widget_tree.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sagip_App_Prototype',
      home: const WidgetTree(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [

            //Title
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('SAGIPP app'),
              ),
            ),

            //Login button
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text('Login'),
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TestScreen()),
                    );
                  },
                  child: const Text('Test Screen'),
                ),
              ),
            ),
          ],
        ),
          backgroundColor: Colors.lightBlue[100],
      ),
      body: Center(
        child: const Text('Body Content Here'),
      ),
    );
  }
}
