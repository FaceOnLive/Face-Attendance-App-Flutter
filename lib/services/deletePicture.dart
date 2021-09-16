import 'package:firebase_storage/firebase_storage.dart';

class DeletePicture {
  static Future<void> ofMember({required String memberID}) async {
    FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    try {
      Reference imageRef = _firebaseStorage.ref('members/$memberID');
      imageRef.delete();
      print('Deleted Succesfully $memberID picture');
    } on FirebaseException catch (e) {
      print("There is no old picture found of this user ${e.message}");
    }
  }
}
