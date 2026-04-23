import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../models/data_models.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  
  UserRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;
  
  CollectionReference get _usersRef => _firestore.collection(FirestoreCollections.users);
  
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _usersRef.doc(userId).get();
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>?;
      return data != null ? UserModel.fromMap(data, doc.id) : null;
    } catch (e) {
      return null;
    }
  }
  
  Stream<UserModel?> getUserStream(String userId) {
    return _usersRef.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>?;
      return data != null ? UserModel.fromMap(data, doc.id) : null;
    });
  }
  
  Future<void> createUser(String userId, Map<String, dynamic> data) async {
    await _usersRef.doc(userId).set(data);
  }
  
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _usersRef.doc(userId).update(data);
  }
  
  Future<void> deleteUser(String userId) async {
    await _usersRef.doc(userId).delete();
  }
  
  Future<void> createDriverProfile(String userId, Map<String, dynamic> data) async {
    await _firestore.collection(FirestoreCollections.drivers).doc(userId).set(data);
  }
  
  Future<bool> emailExists(String email) async {
    final result = await _usersRef
        .where('email', isEqualTo: email.toLowerCase())
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }
}

class DriverRepository {
  final FirebaseFirestore _firestore;
  
  DriverRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;
  
  CollectionReference get _driversRef => _firestore.collection(FirestoreCollections.drivers);
  
Future<DriverProfileModel?> getDriverProfile(String userId) async {
    try {
      final doc = await _driversRef.doc(userId).get();
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>?;
      return data != null ? DriverProfileModel.fromMap(data, doc.id) : null;
    } catch (e) {
      return null;
    }
  }

  Stream<DriverProfileModel?> getDriverProfileStream(String userId) {
    return _driversRef.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>?;
      return data != null ? DriverProfileModel.fromMap(data, doc.id) : null;
    });
  }
  
  Future<void> createDriverProfile(String userId, Map<String, dynamic> data) async {
    await _driversRef.doc(userId).set(data);
  }
  
  Future<void> updateDriverProfile(String userId, Map<String, dynamic> data) async {
    await _driversRef.doc(userId).update(data);
  }
  
  Future<void> toggleAvailability(String userId, bool isAvailable) async {
    await _driversRef.doc(userId).update({
      'isAvailable': isAvailable,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
  
  Future<void> updateLocation(String userId, Map<String, dynamic> location) async {
    await _driversRef.doc(userId).update({
      'location': location,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
  
  Stream<List<DriverProfileModel>> getAvailableDrivers() {
    return _driversRef
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return DriverProfileModel.fromMap(data, doc.id);
            })
            .toList());
  }
}

class CompanyRepository {
  final FirebaseFirestore _firestore;
  
  CompanyRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;
  
  CollectionReference get _companiesRef => _firestore.collection(FirestoreCollections.companies);
  
  Future<CompanyProfileModel?> getCompanyProfile(String userId) async {
    try {
      final doc = await _companiesRef.doc(userId).get();
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>?;
      return data != null ? CompanyProfileModel.fromMap(data, doc.id) : null;
    } catch (e) {
      return null;
    }
  }
  
  Future<void> createCompanyProfile(String userId, Map<String, dynamic> data) async {
    await _companiesRef.doc(userId).set(data);
  }
  
  Future<void> updateCompanyProfile(String userId, Map<String, dynamic> data) async {
    await _companiesRef.doc(userId).update(data);
  }
}

class JobRepository {
  final FirebaseFirestore _firestore;
  
  JobRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;
  
  CollectionReference get _jobsRef => _firestore.collection(FirestoreCollections.jobs);
  
  Future<List<JobModel>> getJobs({int limit = 20}) async {
    final snapshot = await _jobsRef
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return JobModel.fromMap(data, doc.id);
    }).toList();
  }

  Stream<List<JobModel>> getJobsStream({int limit = 20}) {
    return _jobsRef
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return JobModel.fromMap(data, doc.id);
            })
            .toList());
  }

  Future<List<JobModel>> getJobsByCompany(String companyId) async {
    final snapshot = await _jobsRef
        .where('companyId', isEqualTo: companyId)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return JobModel.fromMap(data, doc.id);
    }).toList();
  }

  Future<List<JobModel>> getJobsByCountry(String country) async {
    final snapshot = await _jobsRef
        .where('country', isEqualTo: country)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return JobModel.fromMap(data, doc.id);
    }).toList();
  }
  
  Future<String> createJob(Map<String, dynamic> data) async {
    final docRef = await _jobsRef.add(data);
    return docRef.id;
  }
  
  Future<void> updateJob(String jobId, Map<String, dynamic> data) async {
    await _jobsRef.doc(jobId).update(data);
  }
  
  Future<void> deleteJob(String jobId) async {
    await _jobsRef.doc(jobId).delete();
  }
}

class ApplicationRepository {
  final FirebaseFirestore _firestore;
  
  ApplicationRepository({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance;
  
  CollectionReference get _applicationsRef => _firestore.collection(FirestoreCollections.applications);
  
  Future<List<ApplicationModel>> getApplicationsByDriver(String driverId) async {
    final snapshot = await _applicationsRef
        .where('driverId', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ApplicationModel.fromMap(data, doc.id);
    }).toList();
  }
  
Stream<List<ApplicationModel>> getApplicationsByDriverStream(String driverId) {
    return _applicationsRef
        .where('driverId', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ApplicationModel.fromMap(data, doc.id);
            })
            .toList());
  }

  Future<List<ApplicationModel>> getApplicationsByJob(String jobId) async {
    final snapshot = await _applicationsRef
        .where('jobId', isEqualTo: jobId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ApplicationModel.fromMap(data, doc.id);
    }).toList();
  }
  
  Future<String> createApplication(Map<String, dynamic> data) async {
    final docRef = await _applicationsRef.add(data);
    return docRef.id;
  }
  
  Future<void> updateApplicationStatus(String applicationId, String status) async {
    await _applicationsRef.doc(applicationId).update({
      'status': status,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
  
  Future<void> deleteApplication(String applicationId) async {
    await _applicationsRef.doc(applicationId).delete();
  }
}