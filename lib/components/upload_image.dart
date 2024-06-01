import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<String> uploadProfileImageToStorage(String name, File image) async {
  String imageUrl = '';
  try {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    Reference ref = storage.ref().child('profileImages/$name/$fileName');
    UploadTask uploadTask = ref.putFile(image);
    await uploadTask.whenComplete(() async {
      imageUrl = await ref.getDownloadURL();
    });
  } catch (err) {
    print(err);
  }
  return imageUrl;
}
