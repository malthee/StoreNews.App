import 'package:flutter/material.dart';

class StoreIconName extends StatelessWidget {
  final int companyNumber, storeNumber;

  const StoreIconName({
    super.key,
    required this.companyNumber,
    required this.storeNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // TODO load ico from store
        const Icon(Icons.business_center),
        const SizedBox(width: 10),
        Expanded(
            child: Text('Billa Hagenberg, Hauptstraße 16',
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium)),
      ],
    );
  }
}