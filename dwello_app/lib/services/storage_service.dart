import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  // Upload profile image
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      String fileName = '${userId}_${_uuid.v4()}.jpg';
      Reference ref = _storage
          .ref()
          .child(AppConstants.profileImagesPath)
          .child(fileName);

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: ${e.toString()}');
    }
  }

  // Upload verification documents
  Future<String> uploadVerificationDocument(
    File documentFile,
    String userId,
    String documentType, // 'ghana_card' or 'driver_license'
  ) async {
    try {
      String fileName = '${userId}_${documentType}_${_uuid.v4()}.jpg';
      Reference ref = _storage
          .ref()
          .child(AppConstants.verificationDocsPath)
          .child(fileName);

      UploadTask uploadTask = ref.putFile(documentFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload verification document: ${e.toString()}');
    }
  }

  // Upload chat image
  Future<String> uploadChatImage(File imageFile, String chatId) async {
    try {
      String fileName = '${chatId}_${_uuid.v4()}.jpg';
      Reference ref = _storage
          .ref()
          .child(AppConstants.chatImagesPath)
          .child(fileName);

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload chat image: ${e.toString()}');
    }
  }

  // Upload request images
  Future<List<String>> uploadRequestImages(
    List<File> imageFiles,
    String requestId,
  ) async {
    try {
      List<String> downloadUrls = [];

      for (int i = 0; i < imageFiles.length; i++) {
        String fileName = '${requestId}_${i}_${_uuid.v4()}.jpg';
        Reference ref = _storage
            .ref()
            .child('request_images')
            .child(fileName);

        UploadTask uploadTask = ref.putFile(imageFiles[i]);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } catch (e) {
      throw Exception('Failed to upload request images: ${e.toString()}');
    }
  }

  // Delete file from storage
  Future<void> deleteFile(String downloadUrl) async {
    try {
      Reference ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: ${e.toString()}');
    }
  }

  // Get file metadata
  Future<FullMetadata> getFileMetadata(String downloadUrl) async {
    try {
      Reference ref = _storage.refFromURL(downloadUrl);
      return await ref.getMetadata();
    } catch (e) {
      throw Exception('Failed to get file metadata: ${e.toString()}');
    }
  }

  // Upload file with progress tracking
  Future<String> uploadFileWithProgress(
    File file,
    String path,
    Function(double)? onProgress,
  ) async {
    try {
      String fileName = '${_uuid.v4()}_${file.path.split('/').last}';
      Reference ref = _storage.ref().child(path).child(fileName);

      UploadTask uploadTask = ref.putFile(file);

      // Listen to progress if callback provided
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: ${e.toString()}');
    }
  }

  // Compress and upload image
  Future<String> compressAndUploadImage(
    File imageFile,
    String path, {
    int quality = 80,
    int maxWidth = 1024,
    int maxHeight = 1024,
  }) async {
    try {
      // Note: In a real implementation, you would use image compression library
      // like flutter_image_compress to compress the image before uploading
      
      String fileName = '${_uuid.v4()}.jpg';
      Reference ref = _storage.ref().child(path).child(fileName);

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to compress and upload image: ${e.toString()}');
    }
  }

  // Get download URL from reference path
  Future<String> getDownloadUrl(String refPath) async {
    try {
      Reference ref = _storage.ref().child(refPath);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: ${e.toString()}');
    }
  }

  // List files in a directory
  Future<List<Reference>> listFiles(String path) async {
    try {
      Reference ref = _storage.ref().child(path);
      ListResult result = await ref.listAll();
      return result.items;
    } catch (e) {
      throw Exception('Failed to list files: ${e.toString()}');
    }
  }

  // Check if file exists
  Future<bool> fileExists(String downloadUrl) async {
    try {
      Reference ref = _storage.refFromURL(downloadUrl);
      await ref.getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }
}