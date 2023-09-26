
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:FaceDetectorLocal() ,
    );
  }
}


class FaceDetectorLocal extends StatefulWidget {
  const FaceDetectorLocal({Key? key}) : super(key: key);

  @override
  _FaceDetectorState createState() => _FaceDetectorState();
}



class _FaceDetectorState extends State<FaceDetectorLocal> {

  final ImagePicker picker = ImagePicker();
  List<XFile> imageFiles = [];
  bool isFaceAlreadyRegistered =false;
  late final InputImage inputImage;

  final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate
  );
  final faceDetector = FaceDetector(options: options);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await getImageFromCameraAndAddInImageFiles();
                //print(imageFiles.length.toString()+"imageFiles"+imageFiles[0].toString());

              },
              child: Container(
                height: 100,
                width: 150,
                child: Text("RegisterFace"),

              ),
            ),

            GestureDetector(
              onTap: (){


              },
              child: Container(
                height: 100,
                width: 150,
                child: Text("CheckFace"),

              ),
            )

          ],


        ),
      ),
    );



  }



   getImageFromCameraAndAddInImageFiles() async {
    try{
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if(photo!=null){
        imageFiles.add(photo);
      }
    }catch(e){
       print(e.toString());
    }

  }

  getImageAndCheckFaceIsRegisteredOrNot() async{

    try{
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if(photo!=null){
         final inputImage = InputImage.fromFile( File(photo.path));

         final List<Face> faces = await faceDetector.processImage(inputImage);

         for (Face face in faces) {
           final Rect boundingBox = face.boundingBox;

           final double? rotX = face.headEulerAngleX; // Head is tilted up and down rotX degrees
           final double? rotY = face.headEulerAngleY; // Head is rotated to the right rotY degrees
           final double? rotZ = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

           // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
           // eyes, cheeks, and nose available):
           final FaceLandmark? leftEar = face.landmarks[FaceLandmarkType.leftEar];
           if (leftEar != null) {
             final Point<int> leftEarPos = leftEar.position;
           }

           // If classification was enabled with FaceDetectorOptions:
           if (face.smilingProbability != null) {
             final double? smileProb = face.smilingProbability;
           }

           // If face tracking was enabled with FaceDetectorOptions:
           if (face.trackingId != null) {
             final int? id = face.trackingId;
           }
         }


      }
    }catch(e){
      print(e.toString());
    }

  }


}



