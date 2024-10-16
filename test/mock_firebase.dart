import 'package:click_plus_plus/firebase_interface.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class MockUser implements auth.User {
  final String uid;
  MockUser(this.uid);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockFirebaseAuth implements auth.FirebaseAuth {
  MockUser? _currentUser;

  @override
  MockUser? get currentUser => _currentUser;

  @override
  Future<auth.UserCredential> signInAnonymously() async {
    _currentUser = MockUser('mock-uid');
    return MockUserCredential(_currentUser!);
  }

  @override
  Stream<MockUser?> authStateChanges() {
    return Stream.value(_currentUser);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockUserCredential implements auth.UserCredential {
  final MockUser user;
  MockUserCredential(this.user);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockDocumentReference
    implements firestore.DocumentReference<Map<String, dynamic>> {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockCollectionReference
    implements firestore.CollectionReference<Map<String, dynamic>> {
  @override
  MockDocumentReference doc([String? path]) => MockDocumentReference();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockFirebaseFirestore implements firestore.FirebaseFirestore {
  @override
  MockCollectionReference collection(String path) {
    return MockCollectionReference();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestFirebase implements FirebaseInterface {
  @override
  final authInstance = MockFirebaseAuth();

  @override
  final firestoreInstance = MockFirebaseFirestore();
}
