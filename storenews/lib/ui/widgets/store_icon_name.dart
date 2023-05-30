import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:storenews/i18n/store_icon_name.i18n.dart';
import 'package:storenews/ui/widgets/company_logo.dart';

import '../../domain/company.dart';
import '../../domain/store.dart';
import '../../service/company_service.dart';
import '../../service/store_service.dart';

class StoreIconName extends StatefulWidget {
  final int companyNumber, storeNumber;

  const StoreIconName({
    super.key,
    required this.companyNumber,
    required this.storeNumber,
  });

  @override
  State<StoreIconName> createState() => _StoreIconNameState();
}

class _StoreIconNameState extends State<StoreIconName> {
  final companyService = GetIt.I<CompanyService>();
  final storeService = GetIt.I<StoreService>();
  late final Future<List<dynamic>> storeCompanyFuture;

  @override
  void initState() {
    super.initState();
    final companyFuture = companyService.get(widget.companyNumber);
    final storeFuture =
        storeService.get(widget.companyNumber, widget.storeNumber);
    storeCompanyFuture = Future.wait([storeFuture, companyFuture]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CompanyLogo(
            key: ValueKey("${widget.companyNumber}_companyLogo"),
            companyNumber: widget.companyNumber),
        const SizedBox(width: 10),
        Expanded(
            child: FutureBuilder(
                future: storeCompanyFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final store = snapshot.data![0] as Store?;
                    final company = snapshot.data![1] as Company?;

                    if (company == null || store == null) {
                      return Text('Store not found'.i18n); // Fallback
                    }
                    return Text('${company.name} - ${store.name}',
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge);
                  } else if (!snapshot.hasError) {
                    return const LinearProgressIndicator();
                  }

                  return Text('Store not found'.i18n); // Fallback
                })),
      ],
    );
  }
}
