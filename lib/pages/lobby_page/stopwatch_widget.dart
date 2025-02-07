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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
    Duration stopwatchDuration;

    stopwatchDuration = lobby!.lobby.duration;

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
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _formatTime(stopwatchDuration),
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
