import 'package:flutter/material.dart';
import 'screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sagip_App_Prototype',
      home: const MyHomePage(),
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
                child: Text('SAGIP app'),
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

//Logger
// import 'package:logger/logger.dart';
//final logger = logger();
// debug (logger.d()): Detailed information mainly for debugging.
// info (logger.i()): General informational messages about the application's running state.
// warning (logger.w()): Indications that something unexpected happened, but the app can continue running.
// error (logger.e()): Serious issues that might cause parts of the app to fail.
// verbose (logger.v()): More verbose logs, often very detailed.