import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

abstract class FirebaseInterface {
  auth.FirebaseAuth get authInstance;
  firestore.FirebaseFirestore get firestoreInstance;
}

class RealFirebase implements FirebaseInterface {
  @override
  auth.FirebaseAuth get authInstance => auth.FirebaseAuth.instance;

  @override
  firestore.FirebaseFirestore get firestoreInstance =>
      firestore.FirebaseFirestore.instance;
}

late FirebaseInterface firebase;

void initializeFirebase({bool isTestMode = false}) {
  if (isTestMode) {
    firebase = MockFirebase();
  } else {
    firebase = RealFirebase();
  }
}

// This class will be implemented in your test folder
class MockFirebase implements FirebaseInterface {
  @override
  auth.FirebaseAuth get authInstance => throw UnimplementedError();

  @override
  firestore.FirebaseFirestore get firestoreInstance =>
      throw UnimplementedError();
}
