import 'package:flutter/material.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/plan/view/plan_view.dart';

import '../../../../core/utils/DB/models/attachment.dart';

class AddPlanButton extends StatelessWidget {
  final void Function(Attachment) onPlanAdded;

  const AddPlanButton({
    super.key,
    required this.onPlanAdded,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: screenWidth * 0.8,
          child: OutlinedButton.icon(
            onPressed: () async {
              final Attachment? planImage =
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>  PlanDrawView(),
                ),
              );

              if (planImage != null) {
                onPlanAdded(planImage);
              }
            },
            icon: const Icon(
              Icons.draw_rounded,
              color: AppColors.primary,
            ),
            label: Text(
              'Add Plane',
              style: const TextStyle(color: AppColors.primary),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
