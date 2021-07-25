import 'package:flutter/material.dart';

class ResultSection extends StatelessWidget {
  // ignore: deprecated_member_use
  List<String> _result = List.generate(0, (index) => "");
  bool _imgLoaded = false;

  ResultSection(this._imgLoaded, this._result);

  @override
  Widget build(BuildContext context) {
    if (_imgLoaded == true) {
      return Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _result.length,
              itemBuilder: (context, index) {
                return ListTile(title: Center(child: Text(_result[index])));
              }));
    } else {
      return Container(
        child: Text('NO IMAGE AVAILABE'),
      );
    }
  }
}
