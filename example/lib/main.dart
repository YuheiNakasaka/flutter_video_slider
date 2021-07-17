import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_slider/video_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VideoSlider Demo',
      home: PickerPage(),
    );
  }
}

class PickerPage extends StatefulWidget {
  const PickerPage({Key? key}) : super(key: key);

  @override
  _PickerPageState createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final assets = await FilePicker.platform.pickFiles(type: FileType.video);
            if (assets != null) {
              final controller = VideoEditorController.file(File(assets.files.single.path!));
              Navigator.push(
                context,
                MaterialPageRoute<bool>(
                  builder: (_) => AppPage(controller),
                ),
              );
            }
          },
          child: Text("Pick Video From Gallery"),
        ),
      ),
    );
  }
}

class AppPage extends StatefulWidget {
  const AppPage(this.controller, {Key? key}) : super(key: key);

  final VideoEditorController controller;

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await widget.controller.video.initialize();
    widget.controller.video.setLooping(true);
    widget.controller.video.play();
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: widget.controller.video.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: widget.controller.video.value.aspectRatio,
                        child: VideoPlayer(widget.controller.video),
                      )
                    : const Center(
                        child: Text('Loading...'),
                      ),
              ),
              if (widget.controller.video.value.isInitialized)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: VideoSlider(
                      controller: widget.controller,
                      height: 60,
                      maxDuration: const Duration(seconds: 15),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
