import 'dart:io';
import '/screens/results_section.dart';
import 'package:flutter/material.dart';
import '/screens/text_section.dart';
import 'image_section.dart';
import 'package:image_picker/image_picker.dart';
import '/screens/classifier.dart';
import '/screens/classifier2.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,  this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//MOBILENET
//  Classifier _classifier;

  //CATS_DOGS
   Classifier2 _classifier;

  File _img;
  bool _imgPicked = false;
  var _fileLoc;
  final imgPicker = ImagePicker();

  // ignore: deprecated_member_use
  List<String> result = List<String>();

  //tu definiujemy funckje naszej klasy

  @override
  void initState() {
    super.initState();
    //MOBILENET
    //_classifier = Classifier();

    //CATS_DOGS CUSTOMNET
    _classifier = Classifier2();
  }

  void _runModel(path) async {
    try {
      var loadImage = await _classifier.loadTImage(path);
      var loadResults = await _classifier.runTModel(loadImage);
      print('Classification: $loadResults');
      result.clear();
      loadResults.forEach((item) {
        print(item.toString());
        result.add(item.toString());
      });
    } catch (e) {
      print(e);
    }
  }

  void pickImageFromCamera() async {
    final pickImg = await imgPicker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickImg != null) {
        _img = File(pickImg.path);
        _runModel(_img);
        _imgPicked = true;
        _fileLoc = File(pickImg.path);
      } else {
        _imgPicked = false;
        print("NO IMAGE SELECTED");
      }
    });
  }

  void pickImageFromGallery() async {
    final pickImg = await imgPicker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickImg != null) {
        _imgPicked = true;
        _img = File(pickImg.path);
        _fileLoc = File(pickImg.path);
        _runModel(_img);
        print(pickImg.path);
      } else {
        _imgPicked = false;
        print("NO IMAGE SELECTED");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ImageSection(_imgPicked, _fileLoc),
            //TextSection(Colors.white, 'COS'),
            ResultSection(_imgPicked, result),
            //TextSection(Colors.white, '$_counter'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt, size: 60),
                  onPressed: pickImageFromCamera,
                ),
                IconButton(
                  icon: Icon(Icons.folder, size: 60),
                  onPressed: pickImageFromGallery,
                ),
                // TextButton.icon(
                //     icon: Icon(Icons.camera_alt),
                //     label: Text('Camera'),
                //     onPressed: pickImageFromCamera,
                //     style: ButtonStyle(
                //         foregroundColor:
                //             MaterialStateProperty.all<Color>(Colors.white),
                //         backgroundColor:
                //             MaterialStateProperty.all<Color>(Colors.orange))),
                // TextButton.icon(
                //     icon: Icon(Icons.folder),
                //     label: Text('Gallery'),
                //     onPressed: pickImageFromGallery,
                //     style: ButtonStyle(
                //         foregroundColor:
                //             MaterialStateProperty.all<Color>(Colors.white),
                //         backgroundColor:
                //             MaterialStateProperty.all<Color>(Colors.orange))),
              ],
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
