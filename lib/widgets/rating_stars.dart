import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const RatingStars({
    super.key,
    this.rating = 4,
    this.size = 16.0,
    this.activeColor = Colors.yellow,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: List.generate(5, (index) {
          return Icon(
            Icons.star,
            color: index < rating ? activeColor : inactiveColor,
            size: size,
          );
        }),
      ),
    );
  }
}
