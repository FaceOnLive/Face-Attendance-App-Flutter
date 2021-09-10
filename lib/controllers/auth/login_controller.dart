import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Rxn<User> _firebaseUser = Rxn<User>();

  /// Login User With Email
  Future<void> loginWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential _userCredintial = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      _firebaseUser.value = _userCredintial.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}
