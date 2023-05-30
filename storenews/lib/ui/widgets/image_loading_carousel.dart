import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:storenews/util/constants.dart';

import '../../domain/image_data.dart';
import '../../service/image_service.dart';

class ImageLoadingCarousel extends StatefulWidget {
  final List<String> imageIds;

  const ImageLoadingCarousel({super.key, required this.imageIds});

  @override
  State<ImageLoadingCarousel> createState() => _ImageLoadingCarouselState();
}

class _ImageLoadingCarouselState extends State<ImageLoadingCarousel> {
  final imageService = GetIt.I<ImageService>();
  final CarouselController _controller = CarouselController();
  late final List<Future<ImageData?>> imagesFutures;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    imagesFutures = widget.imageIds
        .map((imageId) => imageService.getImageById(imageId))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    // Use third or big size in landscape mode
    final carouselHeight = orientation == Orientation.portrait
        ? size.height / 3
        : size.height / 1.4;

    return Column(children: [
      CarouselSlider(
        items: [
          // Load images in futures
          for (final future in imagesFutures)
            FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final imageData = snapshot.data!;
                    return Image(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        image: Image.memory(imageData.data,
                                //width: double.infinity,
                                key: ValueKey("${imageData.id}_image"))
                            .image);
                  } else if (!snapshot.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Fallback, show missing icon
                  return Icon(Icons.image_not_supported_rounded,
                      size: min(size.width, size.height) / 3);
                }),
        ],
        carouselController: _controller,
        options: CarouselOptions(
            height: carouselHeight,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      _CarouselDots(
          count: widget.imageIds.length,
          controller: _controller,
          current: _current),
    ]);
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots({
    super.key,
    required this.count,
    required this.controller,
    required this.current,
  });

  final int count, current;
  final CarouselController controller;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: count > 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: Iterable<int>.generate(count).map((i) {
          return GestureDetector(
            onTap: () => controller.animateToPage(i),
            child: Container(
              width: 9.0,
              height: 9.0,
              margin: const EdgeInsets.symmetric(
                  vertical: InsetSizes.small, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(current == i ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
