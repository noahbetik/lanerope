import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:lanerope/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './screens/home.dart';
import "./screens/login.dart";

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'lanerope_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("aight lets go");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(Lanerope());
}

Future<bool> loginState() async {
  final prefs = await SharedPreferences.getInstance();
  final bool _status =
      prefs.getBool("login") ?? false; // future bool is true if logged in
  print(_status);
  globals.role = prefs.getString("role") ?? "";
  return _status;
}

Future<void> lockedSubs() async {
  final prefs = await SharedPreferences.getInstance();
  globals.subLock =
      prefs.getBool("boxesLocked") ?? false; // future bool is true if logged in
}

Future<void> notiChannelSetup() async {
  print("noti setup");
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

class Lanerope extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _LaneropeState createState() {
    print("inside stateful widget");
    return _LaneropeState();
  }
}

class _LaneropeState extends State<Lanerope> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final Future<bool> _login = loginState();
  final Future<void> _subs = lockedSubs();
  final Future<void> _notis = notiChannelSetup();
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();

    // something is wrong so its not working
    // considering the use case it's not super necessary though
    // gonna leave it in in case i figure out how to fix it later
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print("we got something");
      if (notification != null && android != null) {
        print("kk we rolling");
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android.smallIcon,
                // other properties...
              ),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("inside build widget");
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Future.wait([_initialization, _login, _subs, _notis]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return CircularProgressIndicator.adaptive(); // do something better
        }
        print("waiting for future");

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print("database connected");
          bool login = false;
          globals.findRole(); // may make usage in homepage redundant
          globals.allGroups();
          globals.allInfo();
          globals.allEvents();
          globals.getContacts();
          globals.getConvos();
          var current = FirebaseAuth.instance.currentUser;
          if (snapshot.data![1] == true) {
            globals.currentUID = current!.uid;
            login = true;
            print("user already logged in");
          }
          messaging = FirebaseMessaging.instance;
          messaging.getToken().then((value){
            users.doc(globals.currentUID).update({"FCM" : value});
          });
          //update the user db with the local device FCM token

          return new MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Lanerope",
              theme: dc.appTheme,
              navigatorKey: navigatorKey,
              home: login == true ? Home() : Login(),
              routes: <String, WidgetBuilder>{
                '/home': (BuildContext context) => new Home(),
                '/login': (BuildContext context) => new Login()
              });
        }
        return CircularProgressIndicator
            .adaptive(); // great place to put a splash screen or something
      },
    );
  }
}
