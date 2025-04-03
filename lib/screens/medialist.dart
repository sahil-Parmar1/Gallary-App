import 'package:flutter/cupertino.dart';
import 'package:gallary_app/providerdirectory/mediaprovider.dart';
import 'package:provider/provider.dart';
import 'package:gallary_app/hivestorage/media.dart';
class MediaListScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    final mediaProvider=Provider.of<MediaListProvider>(context);
    return ListView.builder(
        itemCount: mediaProvider.MediaList.length,
        itemBuilder: (context,index){
          Media media=mediaProvider.MediaList[index];
          return Text("${media.path}",style: TextStyle(color: CupertinoColors.black),);
        });

  }
}