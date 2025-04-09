import 'dart:io';
import 'dart:isolate';
import 'package:flutter/cupertino.dart';
import 'package:gallary_app/hivestorage/media.dart';
import 'package:gallary_app/providerdirectory/mediaprovider.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';


//class that handle all shared preference tasks
class sharedpref
{
 static void savetoshared(String key,String value)async
  {
   SharedPreferences pref=await SharedPreferences.getInstance();
   pref.setString(key, value);
  }
 static void savetosharedlist(String key,List<String> value)async
 {
   SharedPreferences pref=await SharedPreferences.getInstance();
   pref.setStringList(key, value);
 }
 static Future<String> gettoshared(String key)async
 {
   SharedPreferences pref=await SharedPreferences.getInstance();
   return pref.getString(key)??'';
 }
 static Future<List<String>> gettosharedlist(String key)async
 {
   SharedPreferences pref=await SharedPreferences.getInstance();
   return pref.getStringList(key)??[];
 }
}

// Function to request storage permissions
Future<void> requestPermission() async {
  if (Platform.isAndroid) {
    if (await Permission.photos.isDenied || await Permission.photos.isPermanentlyDenied) {
      await Permission.photos.request();
    }
    if (await Permission.videos.isDenied || await Permission.videos.isPermanentlyDenied) {
      await Permission.videos.request();
    }
    if (await Permission.manageExternalStorage.isDenied ||
        await Permission.manageExternalStorage.isPermanentlyDenied) {
      await Permission.manageExternalStorage.request();
    }
  }
}

/// Function to get storage location (Android & iOS)
Future<void> getDeviceLocation() async {
  List<String> storageDirs = [];
  List<Directory> directories = [];

  if (Platform.isAndroid) {
    Directory? internalStorage = await getExternalStorageDirectory();
    if (internalStorage != null) directories.add(internalStorage);

    List<Directory>? externalStorage = await getExternalStorageDirectories();
    if (externalStorage != null) directories.addAll(externalStorage);
  } else if (Platform.isIOS) {
    directories.add(await getApplicationDocumentsDirectory());
  }

  // Extract unique paths
  Set<String> uniquePaths = directories
      .map((dir) => dir.path.startsWith("/storage/emulated/0")
      ? "/storage/emulated/0"
      : RegExp(r"^(/storage/[^/]+)").firstMatch(dir.path)?.group(1))
      .whereType<String>()
      .toSet();

  print("Storage Locations: ${uniquePaths.toList()}");
  sharedpref.savetosharedlist("deviceLocations", uniquePaths.toList());
}



///with isolate
Future<void> fetchSongslist(BuildContext context) async {
  List<String> deviceLocations = await sharedpref.gettosharedlist("deviceLocations");
  final mediaProvider = Provider.of<MediaListProvider>(context, listen: false);

  // Show shimmer
  mediaProvider.setLoading(true);

  // Create ReceivePort to get data from isolate
  final ReceivePort receivePort = ReceivePort();

  // Spawn isolate
  await Isolate.spawn(_mediaScanIsolate, [receivePort.sendPort, deviceLocations]);

  // Listen to incoming file paths
  receivePort.listen((message) {
    if (message != 'done') {
      // New media path received
      mediaProvider.addMedia(Media(path: message));
      print("message recieved from isolate : $message");
    } else if (message == 'done') {
      // All media paths are sent
      mediaProvider.setLoading(false);
      receivePort.close(); // Stop listening
    }
  });
}


void _mediaScanIsolate(List<dynamic> args) async {
  SendPort sendPort = args[0];
  List<String> deviceLocations = List<String>.from(args[1]);

  print("Media isolate started");

  for (String rootPath in deviceLocations) {
    try {
      await for (final path in _safeRecursiveScanStream(Directory(rootPath))) {
        sendPort.send(path); // Send file path immediately
      }
    } catch (e) {
      print("Skipping inaccessible root directory: $rootPath");
    }
  }

  sendPort.send('done'); // Let main isolate know scanning is done
}


Stream<String> _safeRecursiveScanStream(Directory dir) async* {
  try {
    await for (var entity in dir.list(recursive: false, followLinks: false)) {
      if (entity is Directory) {
        try {
          yield* _safeRecursiveScanStream(entity); // Recurse safely
        } catch (e) {
          print("Skipped inaccessible subdirectory: ${entity.path}");
        }
      } else if (entity is File) {
        String extension = entity.path.toLowerCase().split('.').last;
        if (supportedExtensions.contains('.$extension')) {
          yield entity.path;
        }
      }
    }
  } catch (e) {
    print("Error accessing directory ${dir.path}: $e");
  }
}





/// Define a set of supported extensions for quick lookup
const Set<String> supportedExtensions = {
  '.jpg', '.jpeg', '.png', '.bmp', '.webp',  // Image formats
  '.mp4', '.m4v', '.mov', '.webm'            // Video formats
};