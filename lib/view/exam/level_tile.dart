import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/view/exam/exam_model.dart';

class LevelTile extends StatelessWidget {
  final ExamModel exam;
  final String level;
  final bool isSelected;
  final VoidCallback onTap;

  const LevelTile({
    required this.exam,
    required this.level,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenColor.withOpacity(0.2) : null,
          border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Image.asset(
                exam.iconPath,
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 5),
              Text(
                '${exam.name} $level',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              isSelected
                  ? Image.asset(
                      'assets/icons/selected.png',
                      height: 20,
                      width: 20,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
