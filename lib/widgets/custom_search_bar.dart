import 'package:flutter/material.dart';
import 'package:booktify/utils/app_color.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.myGrey,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.search, color: AppColors.myDarkGrey),
              SizedBox(width: 8.0),
              Text('Search', style: TextStyle(color: AppColors.myDarkGrey)),
            ],
          ),
          Icon(Icons.mic, color: AppColors.myDarkGrey),
        ],
      ),
    );
  }
}
