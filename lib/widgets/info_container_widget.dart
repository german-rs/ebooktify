import 'package:flutter/material.dart';
import 'package:booktify/utils/app_color.dart';

class InfoContainerWidget extends StatelessWidget {
  const InfoContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.myGrey,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: const [
                Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  '4.1',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: const [
                Text(
                  'Number of pages',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  '120 pages',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: const [
                Text(
                  'Language',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  'ENG',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
