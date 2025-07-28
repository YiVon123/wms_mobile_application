import 'package:flutter/material.dart';
import 'package:wms_mobile_application/constants/colors.dart';
import '../models/service.dart';

class ProgressBar extends StatelessWidget {
  final ServiceStatus status;

  const ProgressBar({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Vehicle\nReceived',
      'Diagnosing',
      'In Progress',
      'Ready For\nPickup',
    ];
    final currentStepIndex = _getCurrentStepIndex(status);

    // progress bar white container
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Custom Progress Bar with Circles and Lines
          SizedBox(
            // height: 40,
            child: CustomPaint(
              painter: ProgressLinePainter(
                currentStepIndex: currentStepIndex,
                stepCount: steps.length,
                circleWidth: 80, // Match SizedBox width
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(steps.length, (index) {
                  final isCompleted = index <= currentStepIndex;
                  return SizedBox(
                    width: 80, // Increased to prevent text wrapping
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: isCompleted
                              ? AppColors.darkBlue
                              : AppColors.grey,
                          child: Icon(
                            isCompleted ? Icons.check : Icons.circle,
                            size: isCompleted ? 14 : 8,
                            color: isCompleted
                                ? AppColors.white
                                : AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 3),
          // Step Labels aligned with circles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (index) {
              return SizedBox(
                width: 80, // Match circle width
                child: Text(
                  steps[index],
                  style: const TextStyle(
                    fontSize: 9, // Smaller to prevent wrapping
                    overflow: TextOverflow.ellipsis, // Handle overflow
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  int _getCurrentStepIndex(ServiceStatus status) {
    return [
      ServiceStatus.vehicle_received,
      ServiceStatus.diagnosing,
      ServiceStatus.in_progress,
      ServiceStatus.ready_for_pickup,
    ].indexOf(status);
  }
}

// Custom Painter for Progress Lines
class ProgressLinePainter extends CustomPainter {
  final int currentStepIndex;
  final int stepCount;
  final double circleWidth;

  ProgressLinePainter({
    required this.currentStepIndex,
    required this.stepCount,
    required this.circleWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double circleRadius = 10;
    final double lineHeight = 2;
    final double circleCenterY = size.height / 2;

    // Calculate the center of each circle based on SizedBox width
    final double totalCircleWidth = stepCount * circleWidth;
    final double remainingWidth = size.width - totalCircleWidth;
    final double gapWidth = stepCount > 1
        ? remainingWidth / (stepCount - 1)
        : 0;

    // Draw lines between circles
    for (int i = 0; i < stepCount - 1; i++) {
      // Center of the i-th circle
      final double startCenterX =
          (i * circleWidth) + (circleWidth / 2) + (i * gapWidth);
      // Center of the (i+1)-th circle
      final double endCenterX =
          ((i + 1) * circleWidth) + (circleWidth / 2) + ((i + 1) * gapWidth);

      // Line from right edge of i-th circle to left edge of (i+1)-th circle
      final double startX = startCenterX + circleRadius;
      final double endX = endCenterX - circleRadius;

      final Paint paint = Paint()
        ..color = i < currentStepIndex ? AppColors.blue : AppColors.grey
        ..strokeWidth = lineHeight
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(startX, circleCenterY),
        Offset(endX, circleCenterY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
