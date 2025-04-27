import "package:flutter/cupertino.dart";
import "package:gallary_app/hivestorage/media.dart";
import "package:provider/provider.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
class MediaListProvider extends ChangeNotifier {
  List<Media> MediaList = [];
  Box<Media> Mediabox;
  Map<String, List<Media>> groupmedia = {};
  String screen = "none";
  Map<String, List<Media>> groupmediafolder = {};

  MediaListProvider(this.Mediabox) {
    _loadMedia();
  }

  void changescreen(String s)
  {
    screen=s;
    print("$screen");
    notifyListeners();
  }

  void SortbyDate()
  {
    MediaList.forEach((value){
      String key=value.dateCreated??"unknown";

      if(groupmedia.containsKey(key))
        groupmedia[key]!.add(value);
      else
        groupmedia[key]=[value];
    });


    notifyListeners();
  }
  void SortbyFolder()
  {
    MediaList.forEach((value){
      String fullPath=value.path;
      String parentDir=p.dirname(fullPath);
      String key=p.basename(parentDir);
      print("$key");
      if(groupmediafolder.containsKey(key))
        groupmediafolder[key]!.add(value);
      else
        groupmediafolder[key]=[value];
    });
    notifyListeners();
  }
  void _loadMedia()async
  {
    MediaList=Mediabox!.values.toList();
    print("${MediaList}");
  }

  void addMedia(Media media) {

    for(Media old in MediaList)
    {
      if(old.path == media.path)
        return;
    }
   //  int index = _findInsertIndex(media);
   // MediaList.insert(index, media);
   // Mediabox.addAll(MediaList);
    Mediabox.add(media);
    MediaList=Mediabox!.values.toList();
   notifyListeners();
   // Update list
  }
///binary insertion
  int _findInsertIndex(Media value) {
    int low = 0;
    int high = MediaList.length;

    DateTime valueDate = value.date ?? DateTime(0);

    while (low < high) {
      int mid = (low + high) >> 1;
      DateTime midDate = MediaList[mid].date ?? DateTime(0);
      if (midDate.compareTo(valueDate) < 0) {
        high = mid;
      } else {
        low = mid + 1;
      }
    }
    return low;
  }

}