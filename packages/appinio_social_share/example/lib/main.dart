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
                child: const Text("ShareToWhatsapp"),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(type: FileType.image, allowMultiple: false);
                  if (result != null && result.paths.isNotEmpty) {
                    shareToWhatsApp("message", result.paths[0]!);
                  }
                },
              ),
            ],
          ),
        ));
  }

  shareToWhatsApp(String message, String filePath) async {
    try {
      if (Platform.isAndroid) {
        await appinioSocialShare.android.shareToWhatsapp(message, filePath);
        return;
      }
      await appinioSocialShare.iOS.shareImageToWhatsApp(filePath);
    } catch (e) {
      print("Error sharing to WhatsApp: $e");
    }
  }
}
