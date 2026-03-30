import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototype_sagip/authenticate.dart';
import 'package:prototype_sagip/widget_tree.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen ({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? errorMessage = '';
  bool isLogin = true;
  bool _isPasswordVisible = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerMiddleInitial = TextEditingController();

  Future<void> signInWithEmailAndPassword() async{
    if (!_formKey.currentState!.validate()) return;

    try{
      await Authenticate().signInWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text,
      );

      //if (mounted) checks if the widget/ screen is still active..
      //..on the screen or not before executing the command
      //Resets the stack
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WidgetTree()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async{
    if (!_formKey.currentState!.validate()) return;

    try{
      String firstName = _controllerFirstName.text.trim();
      String lastName = _controllerLastName.text.trim();
      String middleInitial = _controllerMiddleInitial.text.trim().toUpperCase();
      
      String fullName = "$firstName ${middleInitial.isNotEmpty ? "$middleInitial. " : ""}$lastName".trim();
      
      await Authenticate().createUserWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text,
        displayName: fullName,
      );

      //Sign out new registered user
      await Authenticate().signOut();

      //Move to login screen after registration
      setState(() {
        isLogin = true;
        errorMessage = 'Account created successfully. Please log in.';
        _controllerFirstName.clear();
        _controllerLastName.clear();
        _controllerMiddleInitial.clear();
      });
      
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title(){
    return Text(isLogin ? 'Login' : 'Register');
  }

  Widget _entryField(
    String title, 
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }){
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator ?? (value) {
        if (value == null || value.trim().isEmpty) {
          return '$title is required';
        }
        return null;
      },
      decoration: InputDecoration(labelText: title),
    );
  }

  Widget _passwordField(String title, TextEditingController controller){
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      //Disabled suggestions and autocorrect for passwords
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: title,
        suffixIcon: IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
    );
  }

  Widget _errorMessage() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      errorMessage == '' ? '' : '$errorMessage',
      style: const TextStyle(color: Colors.red, fontSize: 14),
      textAlign: TextAlign.center,
    ),
  );

  Widget _submitButton(){
    return ElevatedButton(
      onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Log in' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton(){
    return TextButton(
      onPressed: () => setState(() {
        isLogin = !isLogin;
        errorMessage = '';
        _formKey.currentState?.reset();
      }),
      child: Text(isLogin ? 'Register instead' : 'Login instead'),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: _title()),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                if (!isLogin) ...[
                  _entryField('First Name', _controllerFirstName),
                  _entryField('Last Name', _controllerLastName),
                  _entryField(
                    'Middle Initial', 
                    _controllerMiddleInitial,
                    validator: (value) {
                      if (value != null && value.length > 2) {
                        return 'Too long';
                      }
                      return null;
                    }
                  ),
                ],
                _entryField(
                  'Email', 
                  _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Email is required';
                    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  }
                ),
                _passwordField('Password', _controllerPassword),
                _errorMessage(),
                _submitButton(),
                _loginOrRegisterButton(),
              ]
            ),
          ),
        )
      ),
    );
  }
}
