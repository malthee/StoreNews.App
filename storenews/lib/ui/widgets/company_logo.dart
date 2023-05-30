import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:storenews/domain/image_data.dart';

import '../../service/company_service.dart';
import '../../service/image_service.dart';
import '../../util/constants.dart';

const logoSize = 24.0;

class CompanyLogo extends StatefulWidget {
  final int companyNumber;

  const CompanyLogo({super.key, required this.companyNumber});

  @override
  State<CompanyLogo> createState() => _CompanyLogoState();
}

class _CompanyLogoState extends State<CompanyLogo> {
  final imageService = GetIt.I<ImageService>();
  final companyService = GetIt.I<CompanyService>();
  late Future<ImageData?> logoFuture;

  @override
  void initState() {
    super.initState();
    logoFuture = companyService.get(widget.companyNumber).then((company) async {
      return company?.logoImageId == null
          ? null
          : await imageService.getImageById(company!.logoImageId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: logoFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final imageData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(InsetSizes.small),
              child: Image(
                  width: logoSize,
                  height: logoSize,
                  fit: BoxFit.contain,
                  image: Image.memory(imageData.data,
                          key: ValueKey("${imageData.id}_image"))
                      .image),
            );
          }

          return const Icon(Icons.more_horiz_rounded); // Fallback
        });
  }
}
