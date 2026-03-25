import 'package:flutter/material.dart';
import 'package:prototype_sagip/authenticate.dart';
import 'package:prototype_sagip/screen/login_register.dart';
import 'package:prototype_sagip/screen/new_download_user_screen.dart';
import 'package:prototype_sagip/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WidgetTree extends StatefulWidget{
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree>{

  @override
  Widget build(BuildContext context){
    return StreamBuilder(
      stream: Authenticate().authStateChanges,
      builder: (context, snapshot){

        if (snapshot.hasData) {
          return const MyHomePage();
        } else {
          return const NewDownloadUserScreen();
        }

      }
    );
  }
}
