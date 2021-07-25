import 'package:flutter/material.dart';

class TextSection extends StatelessWidget {
  Color _color;
  var _text;

  TextSection(this._color, this._text);
  // TextSection(Color color, var text) {
  //   this._color = color;
  //   this._text = text;
  // }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _color),
      child: Text(
        _text,
      ),
    );
  }
}
