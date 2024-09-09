import 'package:flutter/material.dart';

class Rootpage extends StatefulWidget {
  const Rootpage({super.key});

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      backgroundColor: Colors.black,
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Your device was Rooted....\n you can't access this application....",style: TextStyle(
              color: Colors.white,
              fontSize: 17

            ),)
          ],
        ),
      ),
    );
  }
}
