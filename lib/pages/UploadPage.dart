import 'dart:io';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fotoapp/AppRoutes.dart';
import 'package:fotoapp/datamodels/Photo.dart';
import 'package:fotoapp/datamodels/PhotoChallenge.dart';
//import 'package:google_ml_kit/google_ml_kit.dart';

import 'package:fotoapp/services/AuthService.dart';
import 'package:fotoapp/services/DatabaseService.dart';
import 'package:fotoapp/widgets/AppBarTop.dart';

import '../AppColors.dart';
import '../arguments/PhotoChallengeArguments.dart';
import '../arguments/PhotoChallengeGenreArguments.dart';
import '../widgets/Button1.dart';
import '../widgets/LoadingProgressIndicator.dart';

AuthService authService = AuthService();
DatabaseService service = DatabaseService();

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as PhotoChallengeGenreArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Foto hochladen",
            style: TextStyle(fontFamily: 'Sora-Bold', fontSize: 16)),
        backgroundColor: AppColors.backgroundColorWhite,
        foregroundColor: AppColors.textBlack,
        centerTitle: true,
        leading: Container(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(FeatherIcons.arrowLeft),
          ),
        ),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            if (pickedFile != null)
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Image.file(
                        File(pickedFile!.path!),
                        width: double.infinity,
                        fit: BoxFit.contain,
                      )),
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.backgroundColorYellow),
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StreamBuilder<TaskSnapshot>(
                                stream: uploadTask?.snapshotEvents,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final data = snapshot.data!;
                                    double progress =
                                        data.bytesTransferred / data.totalBytes;

                                    return SizedBox(
                                      height: 70,
                                      width: 70,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          CircularProgressIndicator(
                                              strokeWidth: 5,
                                              value: progress,
                                              backgroundColor:
                                                  AppColors.primaryColor,
                                              color: AppColors
                                                  .backgroundColorWhite),
                                          Center(
                                              child: Text(
                                                  '${(100 * progress).round()}%')),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                      height: 0,
                                    );
                                  }
                                }),
                            Text(pickedFile!.name),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColorWhite,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      pickedFile = null;
                                    });
                                  },
                                  icon: Icon(FeatherIcons.x)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 20),
                        child: Button1(
                          width: double.infinity,
                          text: 'hochladen',
                          onPressed: () async {
                            final path =
                                'uploadedPhotos/${args.photoChallengeId}_${authService.getCurrentUserEmail()}';
                            final file = File(pickedFile!.path!);

                            final ref =
                                FirebaseStorage.instance.ref().child(path);
                            setState(() {
                              uploadTask = ref.putFile(file);
                            });

                            final snapshot =
                                await uploadTask!.whenComplete(() {});

                            final urlDownload =
                                await snapshot.ref.getDownloadURL();

                            final photo = Photo(
                                photoChallengeID: args.photoChallengeId,
                                photoUrl: urlDownload,
                                userID: authService.getCurrentUserEmail(),
                                genreID: args.genreId);
                            service.createPhoto(photo);
                            service
                                .addDonePhotoChallenge(args.photoChallengeId);

                            setState(() {
                              uploadTask = null;
                            });
                            Navigator.pushNamed(
                                context, AppRoutes.doneChallenge,
                                arguments: PhotoChallengeArguments(
                                    args.photoChallengeId));
                          },
                          color: AppColors.primaryColor,
                        ),
                      )
                    ]),
              ),
            if (pickedFile == null)
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(20),
                      padding: EdgeInsets.all(20),
                      dashPattern: [9, 3],
                      color: AppColors.textGrey,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: SizedBox(
                            height: 650,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: ShapeDecoration(
                                    color: Color.fromARGB(255, 255, 190, 0),
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.all(30),
                                    icon: Icon(FeatherIcons.camera),
                                    iconSize: 48,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: () async {
                                      final result = await FilePicker.platform
                                          .pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: [
                                            'jpg',
                                            'png'
                                          ]);

                                      setState(() {
                                        pickedFile = result?.files.first;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Wähle ein Foto aus.",
                                    style:
                                        Theme.of(context).textTheme.headline3),
                                Text(
                                  "So können Andere deine Fotos auch sehen und bewerten.",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
              ),
          ])),
    );
  }

  /* Future getLabels(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final labelDetector = GoogleMlKit.vision.imageLabeler();
    final List<ImageLabel> _imageLabel =
        await labelDetector.processImage(inputImage);

    for (var index in _imageLabel) {
      print(index);
    }
  }*/
}
