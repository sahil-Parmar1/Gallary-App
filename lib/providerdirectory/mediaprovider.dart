import "package:flutter/cupertino.dart";
import "package:gallary_app/hivestorage/media.dart";
import "package:provider/provider.dart";
import 'package:hive_flutter/hive_flutter.dart';
class MediaListProvider extends ChangeNotifier
{
  List<Media> MediaList=[];
  Box<Media> Mediabox;
  bool _isLoading=true;
  bool get isLoading=>_isLoading;
  MediaListProvider(this.Mediabox){
    _loadMedia();
  }
  void _loadMedia()async
  {
    MediaList=Mediabox!.values.toList();
    print("${MediaList}");
    notifyListeners();
  }
  void addMedia(Media media) {
    for(Media old in MediaList)
    {
      if(old.path == media.path)
        return;
    }
    Mediabox.add(media); // Save to Hive
    MediaList = Mediabox.values.toList();
    print("${media.path} was  media is added.. contain ${MediaList}");// Update list
    notifyListeners();
  }

   void setLoading(bool value)
   {
     _isLoading=value;
     notifyListeners();
   }
}