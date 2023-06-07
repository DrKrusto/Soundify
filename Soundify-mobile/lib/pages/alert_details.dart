import 'package:flutter/material.dart';

class AlertDetails extends StatefulWidget {
  const AlertDetails({super.key, required this.message});

  final String message;

  @override
  State<AlertDetails> createState() => _AlertDetailsState();
}

class _AlertDetailsState extends State<AlertDetails> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: FittedBox(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            widget.message,
            overflow: TextOverflow.fade,
          )
        ],
      )),
    );
  }
}
