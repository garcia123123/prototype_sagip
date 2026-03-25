import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototype_sagip/authenticate.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen ({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen>{
  String? errorMessage = '';
  bool isLogin = true;
  bool _isPasswordVisible = false; // Added to track password visibility

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async{
    try{
      await Authenticate().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async{
    try{
      await Authenticate().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      
      // Sign out immediately after registration to prevent automatic login
      // Firebase automatically logs in the user after a registration success
      await Authenticate().signOut();
      
      setState(() {
        isLogin = true; // Switch back to login view (this changes the button text to "Log in")
        errorMessage = 'Account created successfully. Please log in.';
      });
      
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title(){
    return const Text('Login / Register');
  }

  Widget _entryField(
      String title,
      TextEditingController controller,
      ){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  // New method specifically for the password field
  Widget _passwordField(
      String title,
      TextEditingController controller,
      ){
    return TextField(
      controller: controller,
      obscureText: !_isPasswordVisible, // Toggles between asterisks and text
      decoration: InputDecoration(
        labelText: title,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _errorMessage(){
    return Text(errorMessage == '' ? '' : 'Humm? $errorMessage');
  }

  
  //Button to submit the email / password
  Widget _submitButton(){
    return ElevatedButton(
      onPressed: () {
        if (isLogin) {
          signInWithEmailAndPassword();
        } else {
          createUserWithEmailAndPassword();
        }
      },
      child: Text(isLogin ? 'Log in' : 'Register'),
    );
  }

  //Button to switch between login and register
  Widget _loginOrRegisterButton(){
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register instead' : 'Login instead'),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('Email', _controllerEmail),
            _passwordField('Password', _controllerPassword), // Using the new password field
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ]
        )
      ),
    );
  }
}
