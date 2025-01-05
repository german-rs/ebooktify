import 'package:booktify/bloc/current_reading_bloc.dart';
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
              if (state.currentBook != null && state.isReading)
                Container(
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
                          // Cambiamos Column por Row para poner el círculo a la derecha
                          children: [
                            // Contenido principal (nombre, autor, estrellas)
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
                                  Container(
                                    margin: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 16.0),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 16.0),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 16.0),
                                        Icon(Icons.star,
                                            color: Colors.yellow, size: 16.0),
                                        Icon(Icons.star,
                                            color: Colors.grey, size: 16.0),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Círculo de progreso
                            Container(
                              margin: const EdgeInsets.only(right: 16.0),
                              width: 40,
                              height: 40,
                              child: Stack(
                                children: [
                                  // Círculo base (fondo blanco)
                                  Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Círculo de progreso
                                  CustomPaint(
                                    painter: ProgressPainter(
                                      progress: 0.65, // 65%
                                      progressColor: AppColors.myOrange,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '65%',
                                        style: TextStyle(
                                          color: AppColors.myOrange,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
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
                ),
            ],
          ),
        );
      },
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress; // valor entre 0 y 1
  final Color progressColor;

  ProgressPainter({
    required this.progress,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dibuja el arco de progreso
    final paint = Paint()
      ..color = progressColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // El arco comienza desde arriba (-90 grados) y avanza en sentido horario
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (3.14159 / 180), // Convertir -90 grados a radianes
      progress *
          2 *
          3.14159, // Convertir el progreso a radianes (360 grados = 2π)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
