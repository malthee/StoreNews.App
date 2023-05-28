import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:i18n_extension/default.i18n.dart';
import 'package:storenews/ui/widgets/company_logo.dart';

import '../../service/company_service.dart';

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
    final companyService = GetIt.I<CompanyService>();
    final companyFuture = companyService.get(companyNumber);

    return Row(
      children: [
        CompanyLogo(companyNumber: companyNumber),
        const SizedBox(width: 10),
        Expanded(
            child: FutureBuilder(
                future: companyFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final company = snapshot.data!;
                    return Text('${company.name} - TODO store name', // TODO
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium);
                  } else if (!snapshot.hasError) {
                    return const LinearProgressIndicator();
                  }

                  return Text('Store not found'.i18n); // Fallback
                })),
      ],
    );
  }
}
