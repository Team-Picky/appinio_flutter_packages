import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:appinio_social_share/appinio_social_share.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppinioSocialShare appinioSocialShare = AppinioSocialShare();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Share Feature",
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text("Check Installed Apps"),
                onPressed: () async {
                  var apps = await appinioSocialShare.getInstalledApps();
                  print("Installed apps: $apps");
                },
              ),
              ElevatedButton(
                child: const Text("Share Text to WhatsApp"),
                onPressed: () async {
                  shareTextToWhatsApp(
                      "Hello from Flutter! This is a test message.");
                },
              ),
              ElevatedButton(
                child: const Text("Share Image to WhatsApp"),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(type: FileType.image, allowMultiple: false);
                  if (result != null && result.paths.isNotEmpty) {
                    shareImageToWhatsApp(
                        "Check out this image!", result.paths[0]!);
                  }
                },
              ),
            ],
          ),
        ));
  }

  shareTextToWhatsApp(String message) async {
    try {
      String result;
      if (Platform.isAndroid) {
        result =
            await appinioSocialShare.android.shareToWhatsapp(message, null);
      } else {
        result = await appinioSocialShare.iOS.shareToWhatsapp(message);
      }
      print("Share result: $result");
    } catch (e) {
      print("Error sharing text to WhatsApp: $e");
    }
  }

  shareImageToWhatsApp(String message, String filePath) async {
    try {
      String result;
      if (Platform.isAndroid) {
        result =
            await appinioSocialShare.android.shareToWhatsapp(message, filePath);
      } else {
        result = await appinioSocialShare.iOS.shareImageToWhatsApp(filePath);
      }
      print("Share result: $result");
    } catch (e) {
      print("Error sharing image to WhatsApp: $e");
    }
  }
}
