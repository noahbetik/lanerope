import 'package:firebase_messaging/firebase_messaging.dart';

class NotiManager {

  NotiManager._();
  static final NotiManager _instance = NotiManager._();
  factory NotiManager() => _instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
      // For testing purposes print the Firebase Messaging token
      String? token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");
  }

}