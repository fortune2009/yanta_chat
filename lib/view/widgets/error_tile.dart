import 'package:flutter/material.dart';

class YantaErrorTile extends StatelessWidget {
  const YantaErrorTile(this.backgroundColor, this.errorMessage, {super.key});
  final Color backgroundColor;
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(errorMessage),
          ),
        ),
      ),
    );
  }
}
