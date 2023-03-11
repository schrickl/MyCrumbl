import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_crumbl/models/user_data_model.dart';
import 'package:my_crumbl/shared/auth_exception_handler.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late AuthResultStatus _status = AuthResultStatus.successful;

  // create user obj based on firebase user
  UserModel? _userModelFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserModel?> get currentUser {
    return _auth.authStateChanges().map(_userModelFromFirebaseUser);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _status = AuthResultStatus.successful;
        await createUserDataRecord(credential.user?.uid);
      } else {
        _status = AuthResultStatus.undefined;
      }
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _status = AuthResultStatus.successful;
        await createUserDataRecord(credential.user?.uid);
      } else {
        _status = AuthResultStatus.undefined;
      }
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<void> createUserDataRecord(String? uid) async {
    final userRef = _firestore.collection('user_data').doc(uid);
    final user = await userRef.get();

    if (user.data() == null) {
      final model = UserDataModel(
        uid: uid,
        defaultView: UserDataModel.defaultViewAll,
        myCookies: const [],
      );
      try {
        await FirebaseFirestore.instance.collection('user_data').doc(uid).set(
              model.toJson(),
              SetOptions(merge: true),
            );
      } on FirebaseException catch (e) {
        print(e);
      }
    } else {
      print('User already exists');
    }
  }
}
