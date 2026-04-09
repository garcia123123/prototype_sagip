//Screen for user who just downloaded the app
//Shows scrollable static information with images about the application

import 'package:flutter/material.dart';
import 'login_register.dart';

class NewDownloadUserScreen extends StatelessWidget{
  const NewDownloadUserScreen ({super.key});

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
                child: const Text('New User'),
              ),
            ),

            //Login/ Register button
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

      body: const SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
                children: [
                  const Text('text 1'),
                  const SizedBox(width: 20), // Adjustable space between texts
                  const Text('text 2'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
                children: [
                  const Text('Populate later about what the app is about (Infograph)'),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
}
