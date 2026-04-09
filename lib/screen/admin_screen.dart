import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototype_sagip/authenticate.dart';
import 'package:prototype_sagip/screen/user_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Authenticate().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Admin Dashboard'),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user?.displayName ?? 'Admin',
                  style: const TextStyle(fontSize: 16),
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
      body: const Center(
        child: Text('Welcome, Admin!'),
      ),
    );
  }
}
