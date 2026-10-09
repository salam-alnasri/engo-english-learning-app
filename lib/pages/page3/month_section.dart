import 'package:flutter/material.dart';

import 'months_data.dart';
import 'task_card.dart';

/// Renders one full month block:
///   - pastel-green pill banner (title + subtitle + emoji)
///   - 2×2 grid of [TaskCard]s
class MonthSection extends StatelessWidget {
  final MonthData month;

  const MonthSection({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // -------- Banner --------
        Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: BoxDecoration(
            color: const Color(0xFFB8DDC2), // pastel green
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${month.title}:',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      month.subtitle,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(month.emoji, style: const TextStyle(fontSize: 44)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // -------- 2x2 grid of tasks --------
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: month.tasks
              .map((t) => TaskCard(task: t, monthId: month.id))
              .toList(),
        ),
      ],
    );
  }
}
