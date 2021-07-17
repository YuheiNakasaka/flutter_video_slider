# video_slider

A simple video slider to trim by specific area.

This library is inspired by [video_editor](https://github.com/seel-channel/video_editor). Almost slider code is copied from the library. What I did is to extract only slider from other dependencies like player, cropper and ffmpeg. You can combine a original player or trimming methods which you want to use with this simple slider.

## Requirement

- sdk: >=2.12.0 <3.0.0
- flutter: >=1.20.0

## Installation

- Add the dependency video_slider to your pubspec.yaml file.

## Usage

### Example

```dart
/// Require to wrap VideoSlider by a widget having width and height constraint.
Container(
  width: MediaQuery.of(context).size.width - 40,
  height: 60,
  margin: const EdgeInsets.symmetric(horizontal: 20),
  child: VideoSlider(
    controller: widget.controller,
    height: 60,
    maxDuration: const Duration(seconds: 15),
  ),
)
```

See [example](https://github.com/YuheiNakasaka/video_slider/tree/master/example) for more info.

![RPReplay_Final1626501540](https://user-images.githubusercontent.com/1421093/126027540-0bdeca06-5167-420c-9f36-2c37c2ba0862.gif)
