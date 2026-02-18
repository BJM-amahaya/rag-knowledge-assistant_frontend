import 'package:flutter/material.dart';

class DateHeader extends StatelessWidget {
  final DateTime date;
  const DateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    String label;
    if (dateOnly == today) {
      label = '今日';
    } else if (dateOnly == yesterday) {
      label = '昨日';
    } else {
      label = '${date.month}月${date.day}日';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.outline,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
