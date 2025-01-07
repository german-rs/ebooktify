import 'package:booktify/bloc/reading/current/current_reading_bloc.dart';
import 'package:booktify/widgets/progress_circle.dart';
import 'package:booktify/widgets/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booktify/utils/app_color.dart';

class ReadingSection extends StatelessWidget {
  const ReadingSection({super.key});

  String formatBookName(String name) {
    final words = name.split(' ');
    if (words.length > 3) {
      return '${words.take(3).join(' ')}...';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentReadingBloc, CurrentReadingState>(
      builder: (context, state) {
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
              const Center(
                child: Icon(
                  Icons.drag_handle,
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
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
              _buildContent(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(CurrentReadingState state) {
    if (state.status == CurrentReadingStatus.loading) {
      return Container(
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.myWhite,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (state.currentBook != null && state.isReading) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.myWhite,
          borderRadius: BorderRadius.circular(16.0),
        ),
        height: 100.0,
        width: double.infinity,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
              ),
              child: Image.network(
                state.currentBook!.imageUrl,
                width: 70,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.book),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formatBookName(state.currentBook!.name),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.myBlack,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          state.currentBook!.author,
                          style: const TextStyle(
                            color: AppColors.myDarkGrey,
                            fontSize: 12.0,
                          ),
                        ),
                        const RatingStars(),
                      ],
                    ),
                  ),
                  const ProgressCircle(progress: 0.65),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.myGrey,
        borderRadius: BorderRadius.circular(16.0),
      ),
      height: 100.0,
      width: double.infinity,
      child: const Center(
        child: Text(
          'No book currently reading',
          style: TextStyle(color: AppColors.myBlack),
        ),
      ),
    );
  }
}
