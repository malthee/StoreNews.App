import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../i18n/permissions_missing.i18n.dart';

class PermissionsMissingDialog extends StatelessWidget {
  const PermissionsMissingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Permissions required'.i18n),
      content: Text('StoreNews needs location permissions always on in order to get the latest news.'.i18n),
      actions: <Widget>[
        TextButton(
          onPressed: () => openAppSettings(),
          child: Text('Open Settings'.i18n),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'.i18n),
        ),
      ],
    );
  }
}
