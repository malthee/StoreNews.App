import 'package:flutter/material.dart';

class BtSettingsButton extends StatelessWidget {
  const BtSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () {
        // TODO start stop bt menu
      },
    );
  }
}
