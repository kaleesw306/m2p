import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:m2pfintech/Model/iTunesMedia.dart';
import 'package:video_player/video_player.dart';
class Moviedetailscreen extends StatefulWidget {

  iTunesMedia? items;

   Moviedetailscreen({super.key,
   this.items
   });

  @override
  State<Moviedetailscreen> createState() => _MoviedetailscreenState();
}

class _MoviedetailscreenState extends State<Moviedetailscreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;


  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.items!.previewUrl.toString()),
    );

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,


      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.redAccent,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),

      fullScreenByDefault: false,
    );
  }

  @override
  void dispose() {

    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new,
            color: Colors.white,),
        ),
        title: const Text('Description',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.network(
                    widget.items!.artworkUrl.toString(),
                    height: 100,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          widget.items!.title.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.items!.artist.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.items!.primaryGenreName.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
        SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Chewie(
            controller: _chewieController,
          )

        ),
              const SizedBox(height: 20),
              const Text("Description",
              style: TextStyle(
                color: Colors.white,
          
              ),),
              const SizedBox(height: 20),
              Text(
                widget.items!.description.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 16,
                fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

