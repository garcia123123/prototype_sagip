import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototype_sagip/authenticate.dart';

class TestScreen extends StatelessWidget {
  TestScreen({Key? key}) : super(key: key);

  final User? user = Authenticate().currentUser;

  Widget _title(){
    return const Text('Firebase Authentication');
  }

  Widget _userID(){
    return Text(user?.email ?? 'User email');
  }

  //For Sign Out
  //Grabs the signOut() from Authenticate.dart
  Future<void> signOut() async{
    await Authenticate().signOut();
  }

  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut, child: const Text('Sign out'),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title(),),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userID(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}