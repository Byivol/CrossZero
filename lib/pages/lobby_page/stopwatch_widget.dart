import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'lobbydata_inherited.dart';

class StopwatchWidget extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const StopwatchWidget(
      {super.key,
      this.padding = EdgeInsets.zero,
      this.margin = EdgeInsets.zero});

  @override
  State<StopwatchWidget> createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final lobby = LobbyData.of(context);
      if (lobby != null && lobby.lobby.isStarted) {
        if (!_stopwatch.isRunning) {
          _stopwatch.start();
        }
        setState(() {});
      } else {
        if (_stopwatch.isRunning) {
          _stopwatch.stop();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final lobby = LobbyData.of(context);
    bool isStarted = lobby!.lobby.isStarted;
    Duration _stopwatchDuration;
    if (_stopwatch.elapsed.inSeconds > lobby!.lobby.duration.inSeconds) {
      _stopwatchDuration = _stopwatch.elapsed;
    } else {
      _stopwatchDuration = lobby.lobby.duration;
    }
    return Container(
      width: 120,
      height: 60,
      padding: widget.padding,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(237, 237, 237, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          _formatTime(_stopwatchDuration),
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
