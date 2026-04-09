import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'screen/login_register.dart';
import 'screen/user_screen.dart';
import 'package:prototype_sagip/widget_tree.dart';
import 'package:prototype_sagip/authenticate.dart';
import 'package:prototype_sagip/grab_geolocation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sagip_App_Prototype',
      home: const WidgetTree(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  bool _isTracking = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _toggleLocationTracking() {
    if (_isTracking) {
      _timer?.cancel();
      _controller.stop();
      setState(() {
        _isTracking = false;
        _isSending = false;
      });
    } else {
      setState(() {
        _isTracking = true;
      });
      
      //Send first location immediately
      _sendLocationPulse();
      
      //Set up timer to send every 10 seconds
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        _sendLocationPulse();
      });
    }
  }

  Future<void> _sendLocationPulse() async {
    if (!mounted || !_isTracking) return;

    setState(() {
      _isSending = true;
    });
    _controller.repeat();

    final result = await GrabGeolocation().sendLocationToDatabase();

    if (mounted && _isTracking) {
      setState(() {
        _isSending = false;
      });
      _controller.stop();
      
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Authenticate().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            //Title
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Text('SAGIP app'),
              ),
            ),

            //Name of the User & Profile Button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user?.displayName ?? 'Guest',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Body Content Hereee'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _toggleLocationTracking,
              icon: Icon(_isTracking ? Icons.stop : Icons.location_on),
              label: Text(_isTracking ? 'Stop Sending Location' : 'Start Sending Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isTracking ? Colors.grey : Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            if (_isSending) ...[
              const SizedBox(height: 20),
              RotationTransition(
                turns: _controller.drive(Tween(begin: 0.0, end: -1.0)),
                child: const Icon(
                  Icons.sync,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ],
            if (_isTracking && !_isSending) ...[
               const SizedBox(height: 20),
               const Text('Tracking Active...', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ]
          ],
        ),
      ),
    );
  }
}
