import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m2pfintech/Views/ITunesLayout.dart';
import 'package:root_checker_plus/root_checker_plus.dart';
import '../ViewModel/iTunesViewModel.dart';
import 'RootPage.dart';

class SearchScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Set<String> selectedFilters = {};
  var stringList = "";
  bool rootedCheck = false;
  bool jailbreak = false;
  bool devMode = false;

  @override
  void initState() {

    super.initState();
    root_detection();


    root_detection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.apple_outlined, color: Colors.white, size: 40,),
                  Text('iTunes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                ],
              ),
              const SizedBox(height: 40),
              const Text('Search for a variety of content from iTunes store including books, movies, podcasts, music, music videos, and audiobooks', style: TextStyle(color: Colors.white, fontSize: 15),),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Search term',
                    hintStyle: TextStyle(
                      color: Colors.grey
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 36),
              const Text('Specify the parameter for the content to be searched', style: TextStyle(color: Colors.white),),
              const SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Wrap(
                  children: [
                    _buildFilterButton('album'),
                    _buildFilterButton('movie'),
                    _buildFilterButton('musicVideo'),
                    _buildFilterButton('song'),
                    _buildFilterButton('musicArtist'),
                    _buildFilterButton('podcast'),
                    _buildFilterButton('ebook'),
                    _buildFilterButton('tvSeason'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  final selectedEntities = selectedFilters.join(',');

                  if (_controller.text.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ITunesScreen(
                            entity: selectedEntities,
                            query: _controller.text
                        )));
                  } else {
                    Fluttertoast.showToast(msg: "Please Enter the term");
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  height: 50,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (selectedFilters.contains(filter)) {
              selectedFilters.remove(filter);
            } else {
              selectedFilters.add(filter);
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedFilters.contains(filter)
              ? Colors.green
              : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(
              color: Colors.white
            )

          )
        ),
        child: Text(
          filter,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void root_detection() {

    if (Platform.isAndroid) {
      androidRootChecker();
      developerMode();
    }
    if (Platform.isIOS) {
      iosJailbreak();
    }
  Future.delayed(Duration.zero,(){
  if(rootedCheck || jailbreak || devMode){
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Rootpage()));
  }
  });


  }

  Future<void> androidRootChecker() async {
    try {
      rootedCheck = (await RootCheckerPlus.isRootChecker())!;
    } on PlatformException {
      rootedCheck = false;
    }
    if (!mounted) return;
    setState(() {
      rootedCheck = rootedCheck;
    });
  }

  Future<void> developerMode() async {
    try {
      devMode = (await RootCheckerPlus.isDeveloperMode())!;
    } on PlatformException {
      devMode = false;
    }
    if (!mounted) return;
    setState(() {
      devMode = devMode;
    });
  }

  Future<void> iosJailbreak() async {
    try {
      jailbreak = (await RootCheckerPlus.isJailbreak())!;
    } on PlatformException {
      jailbreak = false;
    }
    if (!mounted) return;
    setState(() {
      jailbreak = jailbreak;
    });
  }
}
