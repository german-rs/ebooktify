import 'package:booktify/utils/app_color.dart';
import 'package:flutter/material.dart';

class BottomMenuItem extends StatelessWidget {
  final Function() onTap;
  final bool isActive;
  final String title;
  final IconData icon;

  const BottomMenuItem({
    super.key,
    required this.onTap,
    required this.isActive,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.myOrange : AppColors.myDarkGrey,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.myOrange : AppColors.myDarkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
