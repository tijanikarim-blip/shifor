import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  final FirebaseStorage _storage;
  
  StorageRepository({FirebaseStorage? storage}) 
      : _storage = storage ?? FirebaseStorage.instance;
  
  static const _bucket = 'gs://shifor.appspot.com';
  
  Future<String> uploadProfileImage(String userId, File file) async {
    final ref = _storage.ref().child('profiles').child('$userId.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }
  
  Future<String> uploadLicenseImage(String userId, File file) async {
    final ref = _storage.ref().child('licenses').child('$userId.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }
  
  Future<String> uploadAttestation(String userId, int index, File file) async {
    final ref = _storage.ref().child('attestations').child('${userId}_$index.pdf');
    await ref.putFile(file, SettableMetadata(contentType: 'application/pdf'));
    return await ref.getDownloadURL();
  }
  
  Future<String> uploadCompanyLogo(String userId, File file) async {
    final ref = _storage.ref().child('logos').child('$userId.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    return await ref.getDownloadURL();
  }
  
  Future<String> uploadDriverDocument(String userId, String docType, File file) async {
    final ref = _storage.ref().child('documents').child('${userId}_$docType');
    final ext = file.path.split('.').last;
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
  
  Future<void> deleteFile(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (_) {}
  }
  
  Future<void> deleteProfileImage(String userId) async {
    try {
      await _storage.ref().child('profiles').child('$userId.jpg').delete();
    } catch (_) {}
  }
}