import 'dart:ffi';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class Classifier {
    Interpreter _interpreter;
    List<String> _labelList;

  Classifier() {
    _loadModel();
    _loadLabels();
  }

  void _loadModel() async {
    _interpreter = await Interpreter.fromAsset('mobilenet/mobilenet_v1.tflite');
    var inputShape = _interpreter.getInputTensor(0).shape;
    var outputShape = _interpreter.getOutputTensor(0).shape;

    print('Model in/out: $inputShape / $outputShape');
  }

  void _loadLabels() async {
    final labelData =
        await rootBundle.loadString('assets/mobilenet/labels.txt');
    final labelList = labelData.split('\n');
    labelList.removeLast();
    _labelList = labelList;

    print('Loaded');
  }

  Future<TensorImage> loadTImage(File imgFile) async {
    ImageProcessor imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
        .build();
    TensorImage tensorImg = TensorImage.fromFile(imgFile);
    tensorImg = imageProcessor.process(tensorImg);

    print("Image from Tfile loaded");
    return tensorImg;
  }

  Future<List<dynamic>> runTModel(TensorImage loadImage) async {
    TensorBuffer probabilityBuffer =
        TensorBuffer.createFixedSize(<int>[1, 1001], TfLiteType.uint8);

    try {
      _interpreter.run(loadImage.buffer, probabilityBuffer.buffer);
    } catch (e) {
      print('Error loading model: ' + e.toString());
    }
    List<int> pred = probabilityBuffer.getIntList();
    Map<String, int> map = Map.fromIterables(_labelList, pred);
    var sortedKeys = map.keys.toList()..sort();
    var sortL = (pred..sort()).reversed;
    var key = map.keys
        .firstWhere((k) => map[k] == sortL.elementAt(0), orElse: () => "");
    print(key);
    print(map[sortedKeys[0]]);

    List<dynamic> result = [];

    for (var i = 0; i < 2; i++) {
      var key = map.keys
          .firstWhere((k) => map[k] == sortL.elementAt(i), orElse: () => "");
      result.add({
        'label': key,
        'value': ((sortL.elementAt(i) / 255) * 100).round(),
      });
    }
    print("Results");
    print(result);
    return result;
  }
}
