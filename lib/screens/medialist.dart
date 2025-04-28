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
  String screen="none";

  @override
  Widget build(BuildContext context)
  {
    final mediaProvider=Provider.of<MediaListProvider>(context);

    if(mediaProvider.MediaList.isEmpty)
      {
        return const Center(child: Text("No media Found"),);
      }


    return CustomScrollView(
      slivers: [
        // 🧱 AppBar
        SliverAppBar(
          pinned: false,
          floating: true,
          snap: true,
          expandedHeight: 50.0,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Pictures"),
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.camera_fill)),
                    IconButton(onPressed: () async{
                      final selected=await showMenu(context: context,
                          position: const RelativeRect.fromLTRB(100,80,10,100),
                          items: [
                            const PopupMenuItem(
                                value:"date",
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Sort by Date"),
                                    Icon(Icons.calendar_month)
                                  ],
                                )),
                            const PopupMenuItem(
                                value:"folder",
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Sort by folder"),
                                    Icon(Icons.folder)
                                  ],
                                )),
                          ]);
                      if (selected!=null)
                        {
                          if(selected=='date')
                            mediaProvider.SortbyDate();
                          if(selected=='folder')
                            mediaProvider.SortbyFolder();

                          mediaProvider.changescreen(selected);
                        }
                    }, icon: const Icon(CupertinoIcons.sort_down)),
                    IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.search)),
                  ],
                ),
              ],
            ),
            centerTitle: true,
          ),
        ),

       //this is default screen where screen is none
       if(mediaProvider.screen=='date')...[_builddatelist(mediaProvider)]
       else if(mediaProvider.screen=='folder')...[_buildfolderlist(mediaProvider)]
        else...[_builddefualtlist(mediaProvider)]
      ],
    );






  }

  //where screen none default screen
  Widget _builddefualtlist(MediaListProvider mediaProvider)
  {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
                (context,index){
              final item=mediaProvider.MediaList[index];
              
                return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  item.path.endsWith(".mp4")?File(item.thumbnail??''):File(item.path),
                  fit: BoxFit.cover,
                  cacheHeight: 300,
                  cacheWidth: 300,
                  errorBuilder: (context,error,stackTrace){
                    print("=======>erorr on ${item.path} was not supported");
                    return const Icon(Icons.error_outline);},
                ),
              );
            },
            childCount: mediaProvider.MediaList.length,
          ),

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          )),
    );
  }

  //where the screen is date
 Widget _builddatelist(MediaListProvider mediaProvider)
 {
   final keys=mediaProvider.groupmedia.keys.toList();
   print(keys);

   ///remaining to understand
   keys.sort((a, b) {
     DateTime? parse(String date) {
       try {
         return DateTime.parse(
             date.split('-').reversed.join()); // dd-mm-yyyy → yyyy-mm-dd
       } catch (_) {
         return null;
       }
     }

     DateTime? dateA = parse(a);
     DateTime? dateB = parse(b);

     if (dateA == null && dateB == null) return 0; // Both invalid
     if (dateA == null) return 1;                  // a is invalid → goes after
     if (dateB == null) return -1;                 // b is invalid → goes after

     return dateB.compareTo(dateA); // 🔁 reverse order → newest to oldest
   });

   print(keys);
   return SliverList(
     delegate: SliverChildBuilderDelegate(
           (context, index) {
         final key = keys[index];
         final mediaItems = mediaProvider.groupmedia[key]!; // Directly store non-null

         return Padding(
           padding: const EdgeInsets.symmetric(vertical: 8.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // Date Title
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                 child: Row(
                   children: [
                     Icon(CupertinoIcons.calendar_today,color: Colors.orange,),
                     SizedBox(width: 5,),
                     Text(
                       key,
                       style: const TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ],
                 ),
               ),

               // Grid of Images
               GridView.builder(
                 shrinkWrap: true,
                 physics: const NeverScrollableScrollPhysics(),
                 itemCount: mediaItems.length,
                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 3,
                   crossAxisSpacing: 8,
                   mainAxisSpacing: 8,
                   childAspectRatio: 1,
                 ),
                 padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add side padding
                 itemBuilder: (context, gridIndex) {
                   final item = mediaItems[gridIndex];
                   return ClipRRect(
                     borderRadius: BorderRadius.circular(8),
                     child: Image.file(
                       item.path.endsWith(".mp4")?File(item.thumbnail??''):File(item.path),
                       fit: BoxFit.cover,
                       cacheHeight: 300,
                       cacheWidth: 300,
                       errorBuilder: (context,error,stackTrace){
                         print("=======>erorr on ${item.path} was not supported");
                         return const Icon(Icons.error_outline);},
                     ),
                   );
                 },
               ),
             ],
           ),
         );
       },
       childCount: keys.length,
     ),
   );


 }

 //where the screen is folder
  Widget _buildfolderlist(MediaListProvider mediaProvider)
  {
    final keys=mediaProvider.groupmediafolder.keys.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final key = keys[index];
          final mediaItems = mediaProvider.groupmediafolder[key]!; // Directly store non-null
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.folder_fill,color: Colors.orange,),
                      SizedBox(width: 5,),
                      Text(
                        key,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Grid of Images
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mediaItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add side padding
                  itemBuilder: (context, gridIndex) {
                    final item = mediaItems[gridIndex];
                    if(item.path.endsWith(".mp4"))
                      return Stack(
                        fit: StackFit.expand,
                        children: [

                          Positioned(

                              child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(item.thumbnail??''),
                              fit: BoxFit.cover,
                              cacheHeight: 350,
                              cacheWidth: 350,
                              errorBuilder: (context,error,stackTrace){
                                print("=======>erorr on ${item.path} was not supported");
                                return const Icon(Icons.error_outline);},
                            ),
                          )),
                          Positioned(
                            top:45,
                              right:45,
                              child: Icon(CupertinoIcons.play_circle_fill,size: 40,color: CupertinoColors.white,))
                        ],
                      );
                      else
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                          File(item.path),
                        fit: BoxFit.cover,
                        cacheHeight: 300,
                        cacheWidth: 300,
                        errorBuilder: (context,error,stackTrace){
                          print("=======>erorr on ${item.path} was not supported");
                          return const Icon(Icons.error_outline);},
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        childCount: keys.length,
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
