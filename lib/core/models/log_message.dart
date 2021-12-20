import 'package:cloud_firestore/cloud_firestore.dart';

class LogMessage {
  String message;
  bool isAnError;
  String? thumbnail;
  LogMessage({
    required this.message,
    required this.isAnError,
    this.thumbnail,
  });

  factory LogMessage.fromDocumentSnap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return LogMessage(
      message: map['message'],
      isAnError: map['isAnError'],
      thumbnail: map['thumbnail'],
    );
  }
}
