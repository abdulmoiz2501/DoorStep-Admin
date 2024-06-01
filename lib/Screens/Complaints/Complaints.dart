import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminComplaintsPage extends StatefulWidget {
  @override
  _AdminComplaintsPageState createState() => _AdminComplaintsPageState();
}

class _AdminComplaintsPageState extends State<AdminComplaintsPage> {
  Future<void> _updateComplaintStatus(String docId, bool resolved) async {
    try {
      await FirebaseFirestore.instance.collection('complaints').doc(docId).update({
        'resolved': resolved,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint status updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update complaint status: $error')),
      );
    }
  }

  void _showComplaintDetails(BuildContext context, DocumentSnapshot doc) {
    final bool resolved = doc['resolved'] ?? false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(doc['title']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${doc['description']}'),
                SizedBox(height: 10),
                if (doc['image'] != null)
                  Image.network(
                    doc['image'],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 10),
                Text(
                  resolved ? 'Status: Resolved' : 'Status: Unresolved',
                  style: TextStyle(
                    color: resolved ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                SwitchListTile(
                  title: Text('Resolve Complaint'),
                  value: resolved,
                  onChanged: (value) {
                    _updateComplaintStatus(doc.id, value);
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Complaints'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('complaints').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No complaints found.'));
            } else {
              final documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final doc = documents[index];
                  final bool resolved = doc['resolved'] ?? false;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                      onTap: () => _showComplaintDetails(context, doc),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(doc['title']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc['description']),
                            SizedBox(height: 5),
                            Text(
                              resolved ? 'Resolved' : 'Unresolved',
                              style: TextStyle(
                                color: resolved ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: doc['image'] != null
                            ? Image.network(
                          doc['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
