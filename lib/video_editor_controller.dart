import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_slider/trim_slider_style.dart';
import 'package:video_player/video_player.dart';

///_max = Offset(1.0, 1.0);
const Offset _max = Offset(1.0, 1.0);

///_min = Offset.zero;
const Offset _min = Offset.zero;

class VideoEditorController extends ChangeNotifier {
  ///Constructs a [VideoEditorController] that edits a video from a file.
  VideoEditorController.file(
    this.file, {
    TrimSliderStyle? trimStyle,
  })  : _video = VideoPlayerController.file(file),
        trimStyle = trimStyle ?? TrimSliderStyle();

  ///Style for TrimSlider
  final TrimSliderStyle trimStyle;

  ///Video from [File].
  final File file;

  bool isTrimming = false;

  double _minTrim = _min.dx;
  double _maxTrim = _max.dx;

  Offset _minCrop = _min;
  Offset _maxCrop = _max;

  Duration _trimEnd = Duration.zero;
  Duration _trimStart = Duration.zero;
  final VideoPlayerController _video;

  ///Get the `VideoPlayerController`
  VideoPlayerController get video => _video;

  ///Get the `VideoPlayerController.value.initialized`
  bool get initialized => _video.value.isInitialized;

  ///Get the `VideoPlayerController.value.position`
  Duration get videoPosition => _video.value.position;

  ///Get the `VideoPlayerController.value.duration`
  Duration get videoDuration => _video.value.duration;

  ///The **MinTrim** (Range is `0.0` to `1.0`).
  double get minTrim => _minTrim;
  set minTrim(double value) {
    if (value >= _min.dx && value <= _max.dx) {
      _minTrim = value;
      _updateTrimRange();
    }
  }

  ///The **MaxTrim** (Range is `0.0` to `1.0`).
  double get maxTrim => _maxTrim;
  set maxTrim(double value) {
    if (value >= _min.dx && value <= _max.dx) {
      _maxTrim = value;
      _updateTrimRange();
    }
  }

  ///The **TopLeft Offset** (Range is `Offset(0.0, 0.0)` to `Offset(1.0, 1.0)`).
  Offset get minCrop => _minCrop;
  set minCrop(Offset value) {
    if (value >= _min && value <= _max) {
      _minCrop = value;
      notifyListeners();
    }
  }

  ///The **BottomRight Offset** (Range is `Offset(0.0, 0.0)` to `Offset(1.0, 1.0)`).
  Offset get maxCrop => _maxCrop;
  set maxCrop(Offset value) {
    if (value >= _min && value <= _max) {
      _maxCrop = value;
      notifyListeners();
    }
  }

  //----------------//
  //VIDEO CONTROLLER//
  //----------------//
  ///Attempts to open the given [File] and load metadata about the video.
  Future<void> initialize() async {
    await _video.initialize();
    _video.addListener(_videoListener);
    await _video.setLooping(true);
    _updateTrimRange();
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    if (_video.value.isPlaying) {
      await _video.pause();
    }
    _video.removeListener(_videoListener);
    await _video.dispose();
    super.dispose();
  }

  void _videoListener() {
    final position = videoPosition;
    if (position < _trimStart || position >= _trimEnd) {
      _video.seekTo(_trimStart);
    }
  }

  //----------//
  //VIDEO TRIM//
  //----------//
  void _updateTrimRange() {
    final duration = videoDuration;
    _trimStart = duration * minTrim;
    _trimEnd = duration * maxTrim;
    notifyListeners();
  }

  ///Get the **VideoPosition** (Range is `0.0` to `1.0`).
  double get trimPosition => videoPosition.inMilliseconds / videoDuration.inMilliseconds;
}
