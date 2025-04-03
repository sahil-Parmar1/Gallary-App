import 'dart:io';
import "package:shared_preferences/shared_preferences.dart";
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pathforextract;
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

// Function to get storage location (Android & iOS)
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


// Function to run at app startup
Future<void> startups() async {
  List<String> deviceLocations = await sharedpref.gettosharedlist("deviceLocations");

  if (deviceLocations.isEmpty) {
    print("device location is empty");
    await Future.wait([
      requestPermission(),  // Runs first
      getDeviceLocation()   // Runs at the same time
    ]);

  }
  else
    {
      print("$deviceLocations");
    }
}