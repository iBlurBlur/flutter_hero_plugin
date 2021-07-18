import 'package:flutter/material.dart';
import 'package:flutter_hero_plugin/flutter_hero_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            _buildPlatformVersion(),
          ],
        ),
        body: Center(
          child: Text('Flutter plugins'),
        ),
      ),
    );
  }

  FutureBuilder _buildPlatformVersion() => FutureBuilder<String?>(
        future: FlutterHeroPlugin.platformVersion,
        builder: (context, snapshot) {
          return Visibility(
            visible: snapshot.hasData,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 12),
              child: Text(snapshot.data ?? ''),
            ),
          );
        },
      );
}
