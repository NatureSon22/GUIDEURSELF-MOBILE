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
    precacheImage(
        const AssetImage('lib/assets/webp/head_listening.gif'), context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 150,
      child: Center(
        child: Image.asset(
          'lib/assets/webp/head_listening.gif',
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
