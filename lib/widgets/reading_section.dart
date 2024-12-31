import 'package:flutter/material.dart';
import 'package:booktify/utils/app_color.dart';

class ReadingSection extends StatelessWidget {
  const ReadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.myGreen,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(
              Icons.drag_handle,
              color: Colors.white,
              size: 32.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Continue Reading',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Container(
            decoration: BoxDecoration(
              color: AppColors.myGrey,
              borderRadius: BorderRadius.circular(16.0),
            ),
            height: 100.0,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
