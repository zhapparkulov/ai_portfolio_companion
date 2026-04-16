import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/holding.dart';

class HoldingTile extends StatelessWidget {
  final Holding holding;

  const HoldingTile({super.key, required this.holding});

  @override
  Widget build(BuildContext context) {
    final isUp = holding.dailyChangePercent >= 0;
    final changeColor = isUp ? Colors.green.shade700 : Colors.red.shade700;
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Text(
          holding.symbol.substring(0, holding.symbol.length > 2 ? 2 : 1),
          style: TextStyle(
            color: theme.colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(
        holding.symbol,
        style:
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${holding.name} · ${holding.quantity.toStringAsFixed(0)} shares',
        style: theme.textTheme.bodySmall,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            Formatters.currency(holding.value),
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            Formatters.percent(holding.dailyChangePercent),
            style: theme.textTheme.bodySmall?.copyWith(
              color: changeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
