import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Model/iTunesMedia.dart';
import '../ViewModel/iTunesViewModel.dart';
import 'MovieDetailScreen.dart';

class ITunesScreen extends ConsumerStatefulWidget {
  final String? entity, query;

  ITunesScreen({super.key, this.entity, this.query});

  @override
  _ITunesScreenState createState() => _ITunesScreenState();
}

class _ITunesScreenState extends ConsumerState<ITunesScreen> {
  bool isGrid = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      ref.read(iTunesProvider.notifier).fetchMedia(widget.query.toString(), widget.entity.toString());
    });
   
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(iTunesProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: const Text(
          'iTunes',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        centerTitle: true,
        actions: [],
      ),
      body: state.state == iTunesState.loading
          ? const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(color: Colors.white),
            SizedBox(width: 10),
            Text("Loading", style: TextStyle(color: Colors.white)),
          ],
        ),
      )
          : state.state == iTunesState.error
          ? Center(
        child: Text(
          state.errorMessage ?? "Error loading data",
          style: const TextStyle(color: Colors.red),
        ),
      )
          : state.mediaList.isEmpty ? 
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: Text("No Data Found...",textAlign: TextAlign.center,style: TextStyle(
            color: Colors.white,
          ),),
        ),
      )
      :SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isGrid = true;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isGrid ? Colors.grey.shade700 : Colors.grey.shade900,
                      ),
                      child: const Text(
                        "Grid Layout",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isGrid = false;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isGrid ? Colors.grey.shade900 : Colors.grey.shade700,
                      ),
                      child: const Text(
                        "List Layout",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            buildCategory('Songs', state.mediaList.where((media) => media.mediaType == 'song').toList()),
            buildCategory('eBooks', state.mediaList.where((media) => media.mediaType == 'ebook').toList()),
            buildCategory("Music Video", state.mediaList.where((media) => media.mediaType == 'music-video').toList()),
            buildCategory("Album", state.mediaList.where((media) => media.mediaType == 'album').toList()),
            buildCategory("Album", state.mediaList.where((media) => media.mediaType == 'Album').toList()),
            buildCategory("Podcast", state.mediaList.where((media) => media.mediaType == 'podcast').toList()),
            buildCategory("Music Artist", state.mediaList.where((media) => media.mediaType == 'artist').toList()),
            buildCategory("Movies", state.mediaList.where((media) => media.mediaType == 'feature-movie').toList()),
            buildCategory("TV Season", state.mediaList.where((media) => media.mediaType == 'TV Season').toList()),
            buildCategory("Artist", state.mediaList.where((media) => media.mediaType == 'Artist').toList()),
          ],
        ),
      ),
    );
  }

  Widget buildCategory(String category, List<iTunesMedia> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade900,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(
          child: isGrid
              ? GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Moviedetailscreen(items: items[index]),
                    ),
                  );
                },
                child: buildCard(items[index]),
              );
            },
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Moviedetailscreen(items: items[index]),
                    ),
                  );
                },
                child: buildCardList(items[index]),
              );
            },
          ),
        ),
      ],
    );
  }



  Widget buildCard(iTunesMedia media) {
    return SizedBox(

      child: Container(

      padding: const EdgeInsets.all(8.0),
            child: Column(
            children: [
            Image.network(
            media.artworkUrl,
            width: 100,
            height: 80,
            ),
            const SizedBox(height: 4,),

            Text(

            media.title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold,
            color: Colors.white),
            ),

            ],
            ),
      ),
    );
  }

  Widget buildCardList(iTunesMedia media) {
    return SizedBox(

      child: Container(

        padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              media.artworkUrl,
              width: 100,
              height: 100,

            ),

          Expanded(child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maxLines: 2,
                  media.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  media.artist,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.normal,
                      color: Colors.white,
                  fontSize: 12),
                ),
              ],
            ),
          ))
          ],
        ),
      ),
    );
  }
}