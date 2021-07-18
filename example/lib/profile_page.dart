import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hero_plugin/flutter_hero_plugin.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('iBlurBlur Plugin'),
        actions: [
          _buildPlatformVersion(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileNative(),
            _buildForm(),
          ],
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

  StreamBuilder _buildProfileNative() {
    final params = <String, dynamic>{
      "name": "iBlurBlur",
      "role": "Flutter Developer",
      "image":
          "https://i.natgeofe.com/n/3861de2a-04e6-45fd-aec8-02e7809f9d4e/02-cat-training-NationalGeographic_1484324.jpg"
    };

    return StreamBuilder<dynamic>(
      stream: FlutterHeroPlugin.showColor,
      builder: (context, snapshot) => Container(
        color: snapshot.hasData ? Color(snapshot.data) : Colors.grey[200],
        height: 270,
        child: Platform.isAndroid
            ? _buildAndroidProfile(FlutterHeroPlugin.profileView, params)
            : _buildIOSProfile(FlutterHeroPlugin.profileView, params),
      ),
    );
  }

  AndroidView _buildAndroidProfile(
    String viewType,
    Map<String, dynamic> creationParams,
  ) =>
      AndroidView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );

  UiKitView _buildIOSProfile(
    String viewType,
    Map<String, dynamic> creationParams,
  ) =>
      UiKitView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );

  void _save() async {
    final result = await FlutterHeroPlugin.setName(_nameController.text);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        content: Text(
          result ? 'Successful' : 'Failed to save',
          style: TextStyle(color: result ? Colors.green : Colors.red),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('close'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      ),
    );
  }

  Padding _buildForm() => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'name',
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _save(),
              child: Text('save'),
            ),
            SizedBox(height: 80),
          ],
        ),
      );
}
