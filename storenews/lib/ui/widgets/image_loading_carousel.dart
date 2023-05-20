import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:storenews/util/constants.dart';

class ImageLoadingCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const ImageLoadingCarousel({super.key, required this.imageUrls});

  @override
  State<ImageLoadingCarousel> createState() => _ImageLoadingCarouselState();
}

class _ImageLoadingCarouselState extends State<ImageLoadingCarousel> {
  // TODO implement fetching
  final List<String> images = [
    'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
    'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
    'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  ];

  int _current = 0;
  final CarouselController _controller = CarouselController();

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
          Image.network(images[0],
              fit: BoxFit.cover, width: double.infinity),
          Image.network(images[1],
              fit: BoxFit.cover, width: double.infinity),
          Image.network(images[2],
              fit: BoxFit.cover, width: double.infinity),
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
          count: images.length, controller: _controller, current: _current),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Iterable<int>.generate(count).map((i) {
        return GestureDetector(
          onTap: () => controller.animateToPage(i),
          child: Container(
            width: 9.0,
            height: 9.0,
            margin: const EdgeInsets.symmetric(vertical: InsetSizes.medium, horizontal: 4.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                    .withOpacity(current == i ? 0.9 : 0.4)),
          ),
        );
      }).toList(),
    );
  }
}
