import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lanerope/globals.dart' as globals;
import 'package:path/path.dart' as path;

import 'Message.dart';

final CollectionReference messages =
    FirebaseFirestore.instance.collection('messages');
FirebaseStorage storage = FirebaseStorage.instance;

final key = new GlobalKey<ScaffoldState>();

class MessageView extends StatefulWidget {
  final String convoName;
  final String chatID;

  MessageView({required this.convoName, required this.chatID});

  @override
  State<StatefulWidget> createState() {
    return MsgViewState();
  }
}

class MsgViewState extends State<MessageView> {
  // not really sure why this needs to be stateful
  final FocusNode _focus = new FocusNode();
  final _sCtrl = ScrollController();
  // controllers are helpful for UX
  final TextEditingController msgCtrl = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final picker = ImagePicker();
  dynamic image;
  Widget imageIcon = Icon(Icons.image); // show small image upon upload before sending
  final FirebaseMessaging notis = FirebaseMessaging.instance;

  @override
  void dispose() {
    _sCtrl.dispose();
    msgCtrl.dispose();
    super.dispose();
  }

  Future getImage() async {
    // get image from gallery
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    final croppedFile =
        await ImageCropper.cropImage(sourcePath: pickedFile!.path);
    // crop it

    setState(() {
      if (croppedFile != null) {
        image = croppedFile;
        imageIcon = Image.file(image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> saveImage() async {
    String imageURL = await uploadFile(image);
    return imageURL;
  }

  Future<String> uploadFile(File image) async {
    print("THE PATH");
    print(image.path);
    final String fileName = path.basename(image.path);
    File imageFile = File(image.path);
    // upload the image to firebase cloud storage
    await storage
        .ref(fileName)
        .putFile(imageFile, SettableMetadata(customMetadata: {}));
    String downloadURL = await storage.ref(fileName).getDownloadURL();
    return downloadURL;
    // get the url it is stored at
    // this url will effectively be sent as a "message" to the db
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // used to dismiss keyboard when tapping elsewhere on screen
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          key: key,
          appBar: AppBar(title: Text(widget.convoName)),
          body: StreamBuilder<DocumentSnapshot>(
            stream: messages.doc(widget.chatID).snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return SizedBox.shrink();
              } else {
                var ds = snap.data;
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  // move to bottom of screen upon sending/receiving new message
                  // animation not working for some reason
                  _sCtrl.animateTo(
                    _sCtrl.position.minScrollExtent,
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.fastOutSlowIn,
                  );
                });
                int num = ds!['messages'].length;
                if (ds['messages'][num - 1].split(globals.splitSeq)[2] !=
                    globals.currentUID) {
                  messages.doc(widget.chatID).update({"status": "received"});
                  // update message status as received
                }
                return ListView.builder(
                  // show all the messages
                  // can use lazy builder since images use keep-alives and text renders quickly
                    reverse: true,
                    controller: _sCtrl,
                    itemCount: num,
                    itemBuilder: (context, i) {
                      if (ds['messages'].length != 0) {
                        List info =
                            ds['messages'][num - i - 1].split(globals.splitSeq);
                        // parse info using split sequence
                        // has the potential to go buggy but makes db wayyyyyy simpler
                        if (info[0].toString().startsWith(
                          // if it's an image it is stored in firebase and will therefore start with this sequence
                            "https://firebasestorage.googleapis.com/v0/b/lanerope-nb.appspot.com/o/image_cropper")) {
                          return ImageMessage(
                              imgSrc: info[0],
                              timestamp: info[1],
                              user: info[2] == globals.currentUID
                                  ? Participant.you
                                  : Participant.them,
                              chatID: widget.chatID);
                        } else {
                          return Message(
                              text: info[0],
                              timestamp: info[1],
                              user: info[2] == globals.currentUID
                                  ? Participant.you
                                  : Participant.them,
                              chatID: widget.chatID);
                        }
                      } else {
                        return SizedBox.shrink();
                      }
                    });
              }
            },
          ),
          // using bottom navigation bar for textfield bar
          // similar UI to instagram
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        color: Colors.grey[200]),
                    child: Row(children: [
                      SizedBox(width: 5),
                      Material(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(100),
                          child: InkWell(
                            customBorder: CircleBorder(),
                            radius: 80,
                            onTap: getImage,
                            splashColor:
                                Colors.lightBlueAccent.withOpacity(0.5),
                            highlightColor:
                                Colors.lightBlueAccent.withOpacity(0.5),
                            child: Container(
                              width: 42,
                              height: 42,
                              child: imageIcon,
                            ),
                          )),
                      SizedBox(width: 4),
                      Expanded(
                          child: TextField(
                        focusNode: _focus,
                        controller: msgCtrl,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 10,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                        ),
                      )),
                      // could add condition here for empty textfield
                      // but need state management of some kind
                      _focus.hasFocus
                          ? Material(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(100),
                              child: InkWell(
                                customBorder: CircleBorder(),
                                radius: 80,
                                onTap: () async {
                                  // should so something to indicate picture message is sending
                                  // as it is a bit slow right now
                                  while (msgCtrl.text.endsWith('\n')) {
                                    msgCtrl.text = msgCtrl.text
                                        .substring(0, msgCtrl.text.length - 1);
                                    // newline removal
                                  }
                                  if (msgCtrl.text.isEmpty) {
                                    // don't send a blank message with an image!
                                    if (image != null) {
                                      String url = await saveImage();
                                      // push image and data to database
                                      messages
                                          .doc(widget.chatID)
                                          .update({
                                            'messages': FieldValue.arrayUnion([
                                              url +
                                                  globals.splitSeq +
                                                  DateTime.now().toString() +
                                                  globals.splitSeq +
                                                  globals.currentUID,
                                            ]),
                                            'status': "sent"
                                          })
                                          .then((value) => messages
                                              .doc(widget.chatID)
                                              .update({'status': 'sent'}))
                                          .catchError((error) => print(error));
                                      setState(() {
                                        // reset right-side icon and clear old image
                                        imageIcon = Icon(Icons.image);
                                        image = null;
                                      });
                                    }
                                  }
                                  else{
                                    // send both the image and the text message
                                    messages
                                        .doc(widget.chatID)
                                        .update({
                                      'messages': FieldValue.arrayUnion([
                                        msgCtrl.text +
                                            globals.splitSeq +
                                            DateTime.now().toString() +
                                            globals.splitSeq +
                                            globals.currentUID,
                                      ]),
                                      'status': "sent"
                                    })
                                        .then((value) => messages
                                        .doc(widget.chatID)
                                        .update({'status': 'sent'}))
                                        .catchError((error) => print(error));
                                    msgCtrl.clear();
                                    if (image != null) {
                                      String url = await saveImage();
                                      // push image and data to database
                                      messages
                                          .doc(widget.chatID)
                                          .update({
                                        'messages': FieldValue.arrayUnion([
                                          url +
                                              globals.splitSeq +
                                              DateTime.now().toString() +
                                              globals.splitSeq +
                                              globals.currentUID,
                                        ]),
                                        'status': "sent"
                                      })
                                          .then((value) => messages
                                          .doc(widget.chatID)
                                          .update({'status': 'sent'}))
                                          .catchError((error) => print(error));
                                      setState(() {
                                        // reset right-side icon and clear old image
                                        imageIcon = Icon(Icons.image);
                                        image = null;
                                      });
                                    }
                                  }
                                  // push message and data to database
                                },
                                splashColor: Colors.redAccent.withOpacity(0.5),
                                highlightColor:
                                    Colors.redAccent.withOpacity(0.5),
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  child: Icon(Icons.send_rounded),
                                ),
                              ))
                          : SizedBox.shrink(),
                      SizedBox(width: 4)
                    ]),
                  )),
              SizedBox(height: 4.0)
            ],
          )),
    );
  }
}
