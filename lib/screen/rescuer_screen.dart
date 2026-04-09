import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototype_sagip/authenticate.dart';
import 'package:prototype_sagip/screen/user_screen.dart';

class RescuerScreen extends StatefulWidget {
  const RescuerScreen({super.key});

  @override
  State<RescuerScreen> createState() => _RescuerScreenState();
}

class _RescuerScreenState extends State<RescuerScreen> {
  final MapController _mapController = MapController();
  bool _showMap = false;

  void _showUserDetails(Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(userData['displayName'] ?? 'Unknown User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${userData['email'] ?? 'N/A'}'),
            Text('Role: ${userData['role'] ?? 'user'}'),
            const SizedBox(height: 10),
            if (userData.containsKey('last_known_location') && userData['last_known_location'] != null) ...[
              Text('Latitude: ${userData['last_known_location']['latitude']}'),
              Text('Longitude: ${userData['last_known_location']['longitude']}'),
            ] else
              const Text('Location: Not available'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

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
                child: Text('Rescuer Dashboard'),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user?.displayName ?? 'Rescuer',
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
      body: _showMap 
          ? _buildMap()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome, Rescuer!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showMap = true;
                      });
                    },
                    icon: const Icon(Icons.map),
                    label: const Text('Show Map View'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: _showMap 
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showMap = false;
                });
              },
              child: const Icon(Icons.close),
            )
          : null,
    );
  }

  Widget _buildMap() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<Marker> markers = [];
        
        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            if (data.containsKey('last_known_location') && data['last_known_location'] != null) {
              final location = data['last_known_location'];
              final lat = (location['latitude'] as num?)?.toDouble();
              final lng = (location['longitude'] as num?)?.toDouble();

              if (lat != null && lng != null) {
                markers.add(
                  Marker(
                    point: LatLng(lat, lng),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _showUserDetails(data),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
                );
              }
            }
          }
        }

        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(14.5995, 120.9842), // Default to Manila
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.prototype_sagip',
            ),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }
}
