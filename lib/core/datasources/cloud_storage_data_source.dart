import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/core/constants/folders.dart';

abstract class CloudStorageDataSource {
  Future<String> uploadUserImage(File image);

  Future<String> uploadPostImage(File image);
}

class CloudStorageDataSourceImpl implements CloudStorageDataSource {
  final Reference cloud;

  CloudStorageDataSourceImpl({required this.cloud});

  @override
  Future<String> uploadUserImage(File image) async =>
      await _uploadImage(image, folderUserImg);

  @override
  Future<String> uploadPostImage(File image) async =>
      await _uploadImage(image, folderPostImg);

  Future<String> _uploadImage(File image, String folder) async {
    String imgName = "image_${DateTime.now()}";
    Reference storageRef = cloud.child(folder).child(imgName);
    UploadTask uploadTask = storageRef.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;

    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
