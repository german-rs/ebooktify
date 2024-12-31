import 'package:booktify/widgets/custom_app_bar.dart';
import 'package:booktify/widgets/custom_search_bar.dart';
import 'package:booktify/widgets/carousel_section.dart';
import 'package:booktify/widgets/reading_section.dart';
import 'package:flutter/material.dart';
import 'package:booktify/utils/app_color.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myGrey,
      body: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            child: Container(
              color: AppColors.myWhite,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CustomAppBar(),
                    const SizedBox(height: 8.0),
                    const CustomSearchBar(),
                    const SizedBox(height: 32.0),
                    const CarouselSection(),
                    const SizedBox(height: 32.0),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ReadingSection(),
          ),
        ],
      ),
    );
  }
}
