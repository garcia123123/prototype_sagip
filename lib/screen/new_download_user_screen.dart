//Screen for user who just downloaded the app
//Shows scrollable static information with images about the application

import 'package:flutter/material.dart';

class NewDownloadUserScreen extends StatelessWidget{
  const NewDownloadUserScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
    );
  }
}