import 'package:flutter/material.dart';
import '../../i18n/news_scan_settings_button.i18n.dart';

class NewsScanSettingsButton extends StatelessWidget {
  final bool isScanning;
  final Function onScanToggle;

  const NewsScanSettingsButton({super.key, required this.isScanning, required this.onScanToggle});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: (scanEnabled) {
          onScanToggle();
        },
        tooltip: 'News Scan Settings'.i18n,
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
