import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_filter_app/filter.dart';
import 'package:flutter_image_filter_app/secondColorSrc.dart';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _globalKey = GlobalKey();
  final List<List<double>> filters = [
    NO_FILTER,
    SEPIA_MATRIX,
    GREYSCALE_MATRIX,
    VINTAGE_MATRIX,
    SWEET_MATRIX,
    SEPIUM_MATRIX,
    COLDLIFE_MATRIX,
    OLDTIME_MATRIX,
    REDSUN_MATRIX,
  ];

  List<String> matrixName = [
    "No filter",
    "Sepia",
    "Grey Scale",
    "Vintage",
    "Sweet",
    'Sepium',
    'Cold Life',
    'Old Time',
    'Red Sun',
  ];
  File imageFile;
  int i;
  bool isSelected = false;
  void convertWidgetToImage() async {
    RenderRepaintBoundary repaintBoundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 1);
    ByteData byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData.buffer.asUint8List();
    Navigator.of(_globalKey.currentContext).push(MaterialPageRoute(
        builder: (context) => SecondScreen(
              imageData: uint8list,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Image image = Image.asset(
      "assets/splash.png",
      width: size.width,
      fit: BoxFit.fill,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: size.height * .5,
                color: Colors.white,
                child: imageFile == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              onPressed: () {
                                _getFromGallery();
                              },
                              child: Text('Chọn ảnh từ bộ nhớ'),
                              color: Colors.blue,
                            ),
                            RaisedButton(
                              onPressed: () {
                                _getFromCamera();
                              },
                              child: Text('Chụp ảnh'),
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: size.width * .3,
                        height: size.height * .3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: ColorFiltered(
                                    colorFilter: i != null
                                        ? ColorFilter.matrix(filters[i])
                                        : ColorFilter.matrix(filters[0]),
                                    child: Image.file(imageFile,
                                        fit: BoxFit.cover))),
                            SizedBox(
                              height: size.height * .01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    _getFromGallery();
                                  },
                                  color: Colors.blue,
                                  child: Text('Chọn ảnh',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    _getFromCamera();
                                  },
                                  color: Colors.blue,
                                  child: Text('Chụp ảnh',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * .01,
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            imageFile != null
                ? RepaintBoundary(
                    key: _globalKey,
                    child: Container(
                      width: size.width * .9,
                      height: size.height * .15,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filters.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    i = index;
                                    isSelected = true;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ColorFiltered(
                                        colorFilter:
                                            ColorFilter.matrix(filters[index]),
                                        child: Container(
                                          width: size.height * .1,
                                          height: size.height * .1,
                                          child: image,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * .01,
                                    ),
                                    Container(
                                      width: size.width * .2,
                                      decoration: BoxDecoration(
                                          color: isSelected && i == index
                                              ? Colors.blue
                                              : Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          matrixName[index],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
