import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SosListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS Alerts'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('generatedSos')
            .orderBy('timestamp', descending: true) // Order by timestamp in descending order
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final sosList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: sosList.length,
              itemBuilder: (context, index) {
                final sos = sosList[index];
                final residentName = sos['residentName'];
                final location = sos['currentLocation'];
                final timestamp = sos['timestamp'];
                final time = timestamp != null
                    ? (timestamp as Timestamp).toDate().toString()
                    : 'Unknown';
                bool solved = sos['resolved'] ?? false;

                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Text('SOS Alert Details'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Resident: $residentName'),
                                  SizedBox(height: 5),
                                  Text('Location: $location'),
                                  SizedBox(height: 5),
                                  Text('Time: $time'),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text('Status:'),
                                      SizedBox(width: 10),
                                      Switch(
                                        value: solved,
                                        onChanged: (value) {
                                          setState(() {
                                            solved = value;
                                          });
                                          // Update the 'resolved' field in Firestore
                                          FirebaseFirestore.instance
                                              .collection('generatedSos')
                                              .doc(sos.id)
                                              .update({'resolved': value});
                                        },
                                      ),
                                      Text(solved ? 'Resolved' : 'Unresolved'),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      _launchMap(location);
                                    },
                                    child: Text('View Location on Map'),
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  child: Text(
                                    'Close',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: solved
                          ? Colors.grey.withOpacity(0.5)
                          : Colors.white, // Adjust background color based on solved status
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resident: $residentName',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: solved
                                ? Colors.black.withOpacity(0.5)
                                : Colors.black, // Adjust text color based on solved status
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Location: $location',
                          style: TextStyle(
                            fontSize: 16,
                            color: solved
                                ? Colors.black.withOpacity(0.5)
                                : Colors.black, // Adjust text color based on solved status
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Time: $time',
                          style: TextStyle(
                            fontSize: 16,
                            color: solved
                                ? Colors.black.withOpacity(0.5)
                                : Colors.black, // Adjust text color based on solved status
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  _launchMap(String currentLocation) async {
    // Splitting the currentLocation string to extract latitude and longitude
    List<String> parts = currentLocation.split(', ');
    double latitude = double.parse(parts[0].split(': ')[1]);
    double longitude = double.parse(parts[1].split(': ')[1]);

    // Launching Google Maps with the extracted latitude and longitude
    String url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
