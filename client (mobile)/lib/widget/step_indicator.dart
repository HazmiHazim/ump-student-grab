import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              for (int i = 0; i < totalSteps; i++) ...[
                _StepCircle(index: i, currentStep: currentStep),
                if (i < totalSteps - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: i < currentStep
                          ? AppColor.primary
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < totalSteps; i++)
                SizedBox(
                  width: 60,
                  child: Text(
                    labels[i],
                    textAlign: i == 0
                        ? TextAlign.left
                        : i == totalSteps - 1
                            ? TextAlign.right
                            : TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: i <= currentStep
                          ? AppColor.primary
                          : Colors.grey.shade400,
                      fontWeight: i == currentStep
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int index;
  final int currentStep;

  const _StepCircle({required this.index, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isCompleted = index < currentStep;
    final isCurrent = index == currentStep;
    final bgColor =
        isCompleted || isCurrent ? AppColor.primary : Colors.grey.shade300;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: isCurrent ? Colors.white : Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
