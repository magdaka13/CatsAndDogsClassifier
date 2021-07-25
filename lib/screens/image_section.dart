import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  var _locFile;
  bool _imgLoaded = false;

  ImageSection(this._imgLoaded, this._locFile);

  @override
  Widget build(BuildContext context) {
    if (_imgLoaded == true) {
      return Container(
        constraints: BoxConstraints.expand(height: 300.0),
        decoration: BoxDecoration(color: Colors.green),
        child: Image.file(_locFile, fit: BoxFit.scaleDown),
      );
    } else {
      return Container(
        constraints: BoxConstraints.expand(height: 300.0),
        decoration: BoxDecoration(color: Colors.green),
        child: Text('NO IMAGE AVAILABE'),
      );
    }
  }
}
