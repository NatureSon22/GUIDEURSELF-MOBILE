import 'package:flutter/material.dart';

class Showlistening extends StatefulWidget {
  const Showlistening({super.key});

  @override
  _ShowlisteningState createState() => _ShowlisteningState();
}

class _ShowlisteningState extends State<Showlistening> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('lib/assets/webp/head_listening.webp'), context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Image.asset(
        'lib/assets/webp/head_listening.webp',
        fit: BoxFit.cover,
        cacheWidth: 150,
        cacheHeight: 150,
      ),
    );
  }
}
