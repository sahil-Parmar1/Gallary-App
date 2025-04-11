import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallary_app/functions.dart';
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


    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: false,
          floating: true,
          snap: true,
          expandedHeight: 50.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Pictures"),
                ),
                 Row(
                   children: [
                     IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.sort_down)),
                     IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.search)),
                   ],
                 ),
              ],
            ),
            centerTitle: true,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                Media media = mediaProvider.MediaList[index];
                print("$index on  this image -->>> ${media.dateCreated}");
                return GestureDetector(
                  onTap: () async {

                  },
                  child: Image.file(
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
                  ),
                );
              },
              childCount: mediaProvider.MediaList.length,
            ),
          ),
        ),
      ],
    );





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



