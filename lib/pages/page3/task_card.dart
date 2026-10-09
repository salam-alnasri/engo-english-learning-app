import 'package:flutter/material.dart';

import 'months_data.dart';
import 'task_content_page.dart';

/// One colored card inside a month's 2×2 grid.
///
/// Tapping it pushes a [TaskContentPage] carrying the [task] and the
/// [monthId] so reading content can be filtered by month.
class TaskCard extends StatelessWidget {
  final TaskData task;

  /// معرّف الشهر الذي تنتمي إليه البطاقة (يُمرَّر لصفحة المحتوى).
  final String monthId;

  const TaskCard({super.key, required this.task, required this.monthId});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: task.color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TaskContentPage(task: task, monthId: monthId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Decorative sparkles around the icon
              SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(task.icon, size: 38, color: Colors.black87),
                    // tiny decoration marks (top-right)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  task.title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
