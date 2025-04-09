import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallary_app/providerdirectory/mediaprovider.dart';
import 'package:provider/provider.dart';
import 'package:gallary_app/hivestorage/media.dart';
import 'package:shimmer/shimmer.dart';

class MediaListScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    final mediaProvider=Provider.of<MediaListProvider>(context);
    if(mediaProvider.isLoading)
      {
        return _buildLoadingScreen();
      }
    
    if(mediaProvider.MediaList.isEmpty)
      {
        return const Center(child: Text("No media Found"),);
      }
    return GridView.builder(
       padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 1,
        ),
        itemCount: mediaProvider.MediaList.length,
        itemBuilder: (context,index){
          Media media=mediaProvider.MediaList[index];
          return Image.file(
            File(media.path),
            width: 150,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {

              return Container(
                width: 150,
                height: 150,
                color: Colors.grey,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, color: Colors.white),
              );
            },
          );

        });



  }
}



Widget _buildLoadingScreen() {
  return GridView.builder(
    padding: const EdgeInsets.all(12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4, // More space for each shimmer tile
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1,
    ),
    itemCount: 50, // Keep it realistic
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      );
    },
  );
}



