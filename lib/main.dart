import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screen/login_register.dart';
import 'screen/user_screen.dart';
import 'package:prototype_sagip/widget_tree.dart';
import 'package:prototype_sagip/authenticate.dart';

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
    final User? user = Authenticate().currentUser;

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

            //Name of the User
            //Profile of the User icon button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    user?.displayName ?? 'Guest',
                    style: const TextStyle(fontSize: 16)
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserScreen()),
                    );
                  },
                  icon: const Icon(Icons.person),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Center(
        child: const Text('Body Content Hereee'),
      ),
    );
  }
}
