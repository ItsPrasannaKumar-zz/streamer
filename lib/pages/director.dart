import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/Controllers/director_controller.dart';
import 'package:streamer/Model/director_model.dart';

class Director extends StatefulWidget {
  final String channelName;
  final int uid;
  const Director({Key? key, required this.channelName, required this.uid})
      : super(key: key);

  @override
  _DirectorState createState() => _DirectorState();
}

class _DirectorState extends State<Director> {
  @override
  void initState() {
    super.initState();

    // context
    //     .read(directorController.notifier)
    //     .joinCall(widget.channelName, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, ref, child) {
      DirectorController directorNotifier =
          ref.watch(directorController.notifier);
      DirectorModel directorData = ref.watch(directorController);

      return Scaffold(
        body: Center(child: Text("Director")),
      );
    });
  }
}
