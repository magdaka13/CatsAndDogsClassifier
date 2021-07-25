import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:image/image.dart' as img;

class Classifier2 {
    Interpreter _interpreter;
    List<String> _labelList;

  Classifier2() {
    _loadModel();
    _loadLabels();
  }

  void _loadModel() async {
    _interpreter = await Interpreter.fromAsset('inception/cats_dogs.tflite');
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
        //Formula: normalized_input = (input - mean) / std
        .add(NormalizeOp(0.0, 255.0))
        .build();

    TensorImage tensorImg = TensorImage(TfLiteType.float32);
    var myImage = img.decodeImage(await imgFile.readAsBytes());

    tensorImg.loadImage(myImage);
    tensorImg = imageProcessor.process(tensorImg);

    print("Image from Tfile loaded");
    return tensorImg;
  }

  Future<List<dynamic>> runTModel(TensorImage loadImage) async {
    TensorBuffer probabilityBuffer =
        TensorBuffer.createFixedSize([1, 1], TfLiteType.uint8);

    SequentialProcessor<TensorBuffer> probabilityProcessor =
        TensorProcessorBuilder().add(DequantizeOp(0, 1 / 255.0)).build();
    TensorBuffer dequantizedBuffer =
        probabilityProcessor.process(probabilityBuffer);

    try {
      _interpreter.run(loadImage.buffer, dequantizedBuffer.buffer);
      _interpreter.run(loadImage.buffer, probabilityBuffer.buffer);
    } catch (e) {
      print('Error loading model: ' + e.toString());
    }

    print("dequantizedBuffer");
    print(dequantizedBuffer.getDoubleList());

    List<dynamic> pred = dequantizedBuffer.getDoubleList();

    print("Prediction");
    //print(result);
    print(pred[0]);
    print(pred.length);
    print(probabilityBuffer.getBuffer());
    return pred;
  }
}
