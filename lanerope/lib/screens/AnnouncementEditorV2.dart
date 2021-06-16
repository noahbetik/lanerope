import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


enum SmartTextType { H1, T, QUOTE, BULLET }

extension SmartTextStyle on SmartTextType {
  TextStyle get textStyle {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextStyle(
            fontSize: 16.0,
            fontStyle: FontStyle.italic,
            color: Colors.black54
        );
      case SmartTextType.H1:
        return TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black);
      default:
        return TextStyle(fontSize: 16.0, color: Colors.black);
    }
  }

  EdgeInsets get padding {
    switch (this) {
      case SmartTextType.H1:
        return EdgeInsets.fromLTRB(16, 24, 16, 8);
      case SmartTextType.BULLET:
        return EdgeInsets.fromLTRB(24, 8, 16, 8);
      default:
        return EdgeInsets.fromLTRB(16, 8, 16, 8);
    }
  }

  TextAlign get align {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextAlign.center;
      default:
        return TextAlign.start;
    }
  }

  String get prefix {
    switch (this) {
      case SmartTextType.BULLET:
        return '\u2022 ';
      default:
        return '';
    }
  }
}

class SmartTextField extends StatelessWidget {
  const SmartTextField({this.type = SmartTextType.T, required this.controller, required this.focusNode});

  final SmartTextType type;
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: Colors.teal,
        textAlign: type.align,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixText: type.prefix,
            prefixStyle: type.textStyle,
            isDense: true,
            contentPadding: type.padding
        ),
        style: type.textStyle
    );
  }
}

class Toolbar extends StatelessWidget {
  const Toolbar({required this.onSelected, this.selectedType = SmartTextType.T});

  final SmartTextType selectedType;
  final ValueChanged<SmartTextType> onSelected;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: Material(
          elevation: 4.0,
          color: Colors.white,
          child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                        CommunityMaterialIcons.format_size,
                        color: selectedType == SmartTextType.H1
                            ? Colors.teal
                            : Colors.black
                    ),
                    onPressed: () => onSelected(SmartTextType.H1)
                ),
                IconButton(
                    icon: Icon(
                        CommunityMaterialIcons.format_quote_open,
                        color: selectedType == SmartTextType.QUOTE
                            ? Colors.teal
                            : Colors.black
                    ),
                    onPressed: () => onSelected(SmartTextType.QUOTE)
                ),
                IconButton(
                    icon: Icon(
                        CommunityMaterialIcons.format_list_bulleted,
                        color: selectedType == SmartTextType.BULLET
                            ? Colors.teal
                            : Colors.black
                    ),
                    onPressed: () => onSelected(SmartTextType.BULLET)
                )
              ]
          )
      ),
    );
  }
}

class EditorProvider extends ChangeNotifier {
  List<FocusNode> _nodes = [];
  List<TextEditingController> _text = [];
  List<SmartTextType> _types = [];
  SmartTextType selectedType = SmartTextType.T;

  EditorProvider(){
    selectedType = SmartTextType.T;
    insert(index: 0, text: '', type: SmartTextType.H1);
  }

  int get length => _text.length;
  int get focus => _nodes.indexWhere((node) => node.hasFocus);
  FocusNode nodeAt(int index) => _nodes.elementAt(index);
  TextEditingController textAt(int index) => _text.elementAt(index);
  SmartTextType typeAt(int index) => _types.elementAt(index);

  void setType(SmartTextType type) {
    if (selectedType == type) {
      selectedType = SmartTextType.T;
    } else {
      selectedType = type;
    }
    _types.removeAt(focus);
    _types.insert(focus, selectedType);
    notifyListeners();
  }

  void setFocus(SmartTextType type) {
    selectedType = type;
    notifyListeners();
  }

  void insert({required int index, required String text, SmartTextType type = SmartTextType.T}) {
    final TextEditingController controller = TextEditingController(
        text: '\u200B' + (text)
    );
    controller.addListener(() {
      if (!controller.text.startsWith('\u200B')) {
        final int index = _text.indexOf(controller);
        if (index > 0) {
          textAt(index-1).text += controller.text;
          textAt(index-1).selection= TextSelection.fromPosition(TextPosition(
              offset: textAt(index-1).text.length - controller.text.length
          ));
          nodeAt(index-1).requestFocus();
          _text.removeAt(index);
          _nodes.removeAt(index);
          _types.removeAt(index);
          notifyListeners();
        }
      }
      if(controller.text.contains('\n')) {
        final int index = _text.indexOf(controller);
        List<String> _split = controller.text.split('\n');
        controller.text = _split.first;
        insert(
            index: index+1,
            text: _split.last,
            type: typeAt(index) == SmartTextType.BULLET
                ? SmartTextType.BULLET
                : SmartTextType.T
        );
        textAt(index+1).selection = TextSelection.fromPosition(
            TextPosition(offset: 1)
        );
        nodeAt(index+1).requestFocus();
        notifyListeners();
      }
    });
    _text.insert(index, controller);
    _types.insert(index, type);
    _nodes.insert(index, FocusNode());
  }
}

class TextEditor extends StatefulWidget {

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditorProvider>(
        create: (context) => EditorProvider(),
        builder: (context, child) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
                appBar: AppBar(title: Text("Editor Yuh")),
                body: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 16,
                      left: 0,
                      right: 0,
                      bottom: 56,
                      child: Consumer<EditorProvider>(
                          builder: (context, state, _) {
                            return ListView.builder(
                                itemCount: state.length,
                                itemBuilder: (context, index) {
                                  return Focus(
                                      onFocusChange: (hasFocus) {
                                        if (hasFocus) state.setFocus(state.typeAt(index));
                                      },
                                      child: SmartTextField(
                                        type: state.typeAt(index),
                                        controller: state.textAt(index),
                                        focusNode: state.nodeAt(index),
                                      )
                                  );
                                }
                            );
                          }
                      )
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Selector<EditorProvider, SmartTextType>(
                        selector: (buildContext, state) => state.selectedType,
                        builder: (context, selectedType, _) {
                          return Toolbar(
                            selectedType: selectedType,
                            onSelected: Provider.of<EditorProvider>(context,
                                listen: false).setType,
                          );
                        },
                      ),
                    )
                  ],
                )
            ),
          );
        }
    );
  }
}

