import 'dart:async';
import 'package:flutter/material.dart';
import 'package:instaclone/utils/project_utils.dart';

class DurationTimerWidget extends StatefulWidget {
  final DateTime date;
  final TextStyle textStyle;

  const DurationTimerWidget({Key? key, required this.date, required this.textStyle}) : super(key: key);

  @override
  State<DurationTimerWidget> createState() => _DurationTimerWidgetState();
}

class _DurationTimerWidgetState extends State<DurationTimerWidget> {
  String durationText = '';
  late Timer timer;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        durationText = ProjectUtils.timestampToString(widget.date, DateTime.now());
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      durationText,
      style: widget.textStyle,
    );
  }
}

class DurationProvider extends ChangeNotifier {
  late Timer timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);

  void _updateTimer(Timer timer) => notifyListeners();

  String getDuration(DateTime date) {
    return ProjectUtils.timestampToString(date, DateTime.now());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
