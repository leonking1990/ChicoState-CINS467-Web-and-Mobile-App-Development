import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoURL;

  const VideoPlayerScreen({Key? key, required this.videoURL}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _showOverlay = true;
  late VoidCallback _listener;
  bool _isFullScreen=false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoURL))
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
    _listener = () {
      setState(() {});
    };
    _controller.addListener(_listener);
    _hideOverlayAfterDelay();
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  void _enterFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // Optionally, also enter full-screen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  void _exitFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Optionally, exit full-screen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  void _toggleFullScreen(){
    if(_isFullScreen){
      _exitFullScreen();
    }else{
      _enterFullScreen();
    }
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _hideOverlayAfterDelay();
    });
  }

  void _hideOverlayAfterDelay() {
    if (!_showOverlay) return;
    Future.delayed(const Duration(seconds: 5), () {
      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        setState(() => _showOverlay = false);
      }
    });
  }

Widget? backButton() {
  if (_isFullScreen) {
    return Positioned(
      top: 10,
      left: 10,
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          _exitFullScreen();
          Navigator.of(context).pop();
        },
      ),
    );
  }
  return null;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: !_isFullScreen ? AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {
            _exitFullScreen(),
            Navigator.of(context).pop(),
            },
          
        ),
        backgroundColor: Colors.black,
      ): null,
      body: GestureDetector(
        onTap: () {
          setState(() => _showOverlay = true);
          _hideOverlayAfterDelay();
        },
        child: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(_controller),
                if (_showOverlay) ...[
                  _videoOverlay(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _videoOverlay() {
    return Positioned.fill(
      child: Stack(
        children: [
          if (backButton() != null) backButton()!,
          Positioned(
            bottom: 10,
            left: 10,
            child: IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: _togglePlay,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(
                Icons.fullscreen,
                color: Colors.white,
              ),
              onPressed: _toggleFullScreen,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VideoProgressIndicator(_controller, allowScrubbing: true),
          ),
        ],
      ),
    );
  }
}
