import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuardActivityPage extends StatefulWidget {
  @override
  _GuardActivityPageState createState() => _GuardActivityPageState();
}

class _GuardActivityPageState extends State<GuardActivityPage> {
  Widget _buildActiveGuardsList() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('activeGuards').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final documents = snapshot.data!.docs;
          // Check if all guards are inactive
          bool allInactive = documents.every((doc) => !(doc['isActive'] ?? false));

          if (allInactive) {
            return Center(child: Text('No guards are active currently.'));
          } else {
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('userProfile').doc(doc['guardUID']).get(),
                  builder: (context, userProfileSnapshot) {
                    if (userProfileSnapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text('Loading...'),
                        subtitle: Text(doc['guardUID']),
                        trailing: CircleAvatar(
                          backgroundColor: doc['isActive'] ?? false ? Colors.green : Colors.grey,
                          radius: 8,
                        ),
                      );
                    } else if (userProfileSnapshot.hasError) {
                      return ListTile(
                        title: Text('Error loading name'),
                        subtitle: Text(doc['guardUID']),
                        trailing: CircleAvatar(
                          backgroundColor: doc['isActive'] ?? false ? Colors.green : Colors.grey,
                          radius: 8,
                        ),
                      );
                    } else {
                      final userProfileData = userProfileSnapshot.data!.data() as Map<String, dynamic>?;
                      final guardName = userProfileData != null ? userProfileData['name'] : 'Unknown';
                      return ListTile(
                        title: Text(guardName),
                        subtitle: Text(doc['guardUID']),
                        trailing: CircleAvatar(
                          backgroundColor: doc['isActive'] ?? false ? Colors.green : Colors.grey,
                          radius: 8,
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guard Activity'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Guards',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _buildActiveGuardsList(),
            ),
          ],
        ),
      ),
    );
  }
}
