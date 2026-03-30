import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototype_sagip/authenticate.dart';
import 'package:prototype_sagip/screen/new_download_user_screen.dart';

class UserScreen extends StatelessWidget {
  UserScreen({Key? key}) : super(key: key);

  final User? user = Authenticate().currentUser;

  Widget _title(){
    return const Text('Profile');
  }

  Widget _userID(){
    return Text(user?.email ?? 'User email');
  }

  //For Sign Out
  //Grabs the signOut() from Authenticate.dart and clears the navigation stack
  Future<void> signOut(BuildContext context) async{
    await Authenticate().signOut();
    
    // Clear navigation stack and move directly to NewDownloadUserScreen
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const NewDownloadUserScreen()),
        (route) => false,
      );
    }
  }

  Widget _signOutButton(BuildContext context){
    return ElevatedButton(
      onPressed: () => signOut(context), 
      child: const Text('Sign out'),
    );
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
            _signOutButton(context),
          ],
        ),
      ),
    );
  }
}
