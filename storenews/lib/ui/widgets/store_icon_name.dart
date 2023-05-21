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
        // TODO load ico from company
        const Icon(Icons.business_center),
        const SizedBox(width: 10),
        Expanded(
            // TODO Company name + store name
            child: Text('Billa - Hagenberg',
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium)),
      ],
    );
  }
}