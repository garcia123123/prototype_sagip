import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prototype_sagip/authenticate.dart';
import 'package:prototype_sagip/screen/new_download_user_screen.dart';
import 'package:prototype_sagip/screen/rescuer_screen.dart';
import 'package:prototype_sagip/screen/admin_screen.dart';
import 'package:prototype_sagip/main.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Authenticate().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          //Fetching the logged in user's role
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {

              //Show a loading screen while fetching the role
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              //If there's an error fetching the user document, default to main.dart
              if (userSnapshot.hasError || !userSnapshot.hasData || !userSnapshot.data!.exists) {
                return const MyHomePage();
              }

              final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
              final String role = userData?['role'] ?? 'user';

              //Role-based navigation
              if (role == 'admin') {
                return const AdminScreen();
              } else if (role == 'rescuer') {
                return const RescuerScreen();
              } else {
                return const MyHomePage();
              }
            },
          );
        } else {

          //If the user is not logged in, show the login/onboarding screen
          return const NewDownloadUserScreen();
        }
      },
    );
  }
}
