import 'package:flutter/material.dart';

import 'formauth_widget.dart';

class StartAuthPage extends StatefulWidget {
  const StartAuthPage({super.key});

  @override
  StartAuthState createState() => StartAuthState();
}

class StartAuthState extends State<StartAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawerEnableOpenDragGesture: false,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SizedBox(width: 380, height: 480, child: FormAuth()),
        ),
      ),
    );
  }
}
