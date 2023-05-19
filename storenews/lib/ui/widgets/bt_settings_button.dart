import 'package:flutter/material.dart';
import 'package:i18n_extension/default.i18n.dart';

class BtSettingsButton extends StatelessWidget {
  final bool isScanning;
  final Function onScanToggle;

  const BtSettingsButton({super.key, required this.isScanning, required this.onScanToggle});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: (scanEnabled) {
          onScanToggle();
        },
        tooltip: 'Bluetooth Scan Settings'.i18n,
        itemBuilder: (context) => <PopupMenuEntry<bool>>[
              if (!isScanning)
                PopupMenuItem<bool>(
                  value: true,
                  child: Row(
                    children: [
                      const Icon(Icons.restart_alt),
                      const SizedBox(width: 10),
                      Text('Restart Scan'.i18n)
                    ],
                  ),
                )
              else
                PopupMenuItem<bool>(
                    value: false,
                    child: Row(
                      children: [
                        const Icon(Icons.pause),
                        const SizedBox(width: 10),
                        Text('Pause Scan'.i18n)
                      ],
                    )),
            ]);
  }
}
