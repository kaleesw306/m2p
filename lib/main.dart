import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m2pfintech/Views/SearchScreen.dart';

import 'Views/ITunesLayout.dart';

void main(){

  runApp(
    ProviderScope(child: MyApp())
  );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

