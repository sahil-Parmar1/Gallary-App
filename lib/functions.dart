import 'dart:io';
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





///fecth the song list
Future<void> fetchSongslist(context) async {
  List<String> deviceLocations=await sharedpref.gettosharedlist("deviceLocations");
final mediaProvider=Provider.of<MediaListProvider>(context,listen:false);
  for (String path in deviceLocations) {
    await for (String song in fetchMedia(path))
    {
      print("song ==>$song");
       Media newmedia=Media(path: song);
       mediaProvider.addMedia(newmedia);
    }
    print("all Image/Video are fecthed....");
  }
}

///fectching media
Stream<String> fetchMedia(String path) async* {
  Directory directory = Directory(path);
  yield* getMedia(directory);
}

/// Define a set of supported extensions for quick lookup
const Set<String> supportedExtensions = {
  '.jpg', '.jpeg', '.png', '.bmp', '.webp',  // Image formats
  '.mp4', '.m4v', '.mov', '.webm'            // Video formats
};
/// Recursively find songs in directories
Stream<String> getMedia(Directory dir) async* {
  try {
    await for (var entity in dir.list(recursive: false, followLinks: false)) {
      if (entity is Directory) {
        yield* getMedia(entity);
      } else if (entity is File) {
        String extension=entity.path.toLowerCase().split('.').last;
       if(supportedExtensions.contains('.$extension'))
        yield entity.path;
      }
    }
  } catch (e) {
   // print("Skipping inaccessible directory: ${dir.path}, Error: $e");
  }
}