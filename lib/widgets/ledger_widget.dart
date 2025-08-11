import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_entry.dart';
import 'expense_chart.dart';

enum LedgerType { karma, nuyen }

class LedgerConfiguration {
  final String title;
  final IconData icon;
  final Color Function(BuildContext context) iconColor;
  final Color Function(BuildContext context) containerColor;
  final Color Function(BuildContext context) positiveAmountColor;
  final String Function(num amount) formatAmount;
  final String emptyStateTitle;
  final String emptyStateSubtitle;
  final LedgerType type;

  const LedgerConfiguration({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.containerColor,
    required this.positiveAmountColor,
    required this.formatAmount,
    required this.emptyStateTitle,
    required this.emptyStateSubtitle,
    required this.type,
  });

  static LedgerConfiguration karma() {
    return LedgerConfiguration(
      title: 'Karma Ledger',
      icon: Icons.auto_awesome,
      iconColor: (context) => Theme.of(context).colorScheme.primary,
      containerColor: (context) => Theme.of(context)
          .colorScheme
          .primaryContainer
          .withValues(alpha: 0.3),
      positiveAmountColor: (context) => Theme.of(context).colorScheme.primary,
      formatAmount: (amount) {
        final numberFormat = NumberFormat.decimalPattern();
        return amount is double && amount != amount.round()
            ? numberFormat.format(amount)
            : numberFormat.format(amount.round());
      },
      emptyStateTitle: 'No Karma Entries',
      emptyStateSubtitle: 'Add your first karma entry above',
      type: LedgerType.karma
    );
  }

  static LedgerConfiguration nuyen() {
    return LedgerConfiguration(
      title: 'Nuyen Ledger',
      icon: Icons.currency_yen,
      iconColor: (context) => Theme.of(context).colorScheme.secondary,
      containerColor: (context) => Theme.of(context)
          .colorScheme
          .secondaryContainer
          .withValues(alpha: 0.3),
      positiveAmountColor: (context) => Theme.of(context).colorScheme.secondary,
      formatAmount: (amount) {
        final numberFormat = NumberFormat.currency(symbol: '¥', decimalDigits: 0);
        return numberFormat.format(amount);
      },
      emptyStateTitle: 'No Nuyen Entries',
      emptyStateSubtitle: 'Add your first nuyen entry above',
      type: LedgerType.nuyen,
    );
  }
}

class LedgerWidget extends StatefulWidget {
  final List<ExpenseEntry> entries;
  final LedgerConfiguration config;

  const LedgerWidget({
    super.key,
    required this.entries,
    required this.config,
  });

  @override
  State<LedgerWidget> createState() => _LedgerWidgetState();
}

class _LedgerWidgetState extends State<LedgerWidget> {
  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: widget.config.containerColor(context),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Use column layout on narrow headers (< 300px)
                if (constraints.maxWidth < 300) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            widget.config.icon,
                            color: widget.config.iconColor(context),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.config.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Show Chart',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: _showChart,
                            onChanged: (value) {
                              debugPrint('${widget.config.title} chart toggle: $value');
                              setState(() {
                                _showChart = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  // Use row layout on wider headers
                  return Row(
                    children: [
                      Icon(
                        widget.config.icon,
                        color: widget.config.iconColor(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.config.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            'Show Chart',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: _showChart,
                            onChanged: (value) {
                              debugPrint('${widget.config.title} chart toggle: $value');
                              setState(() {
                                _showChart = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          // Content area
          Container(
            height: 400, // Fixed height for consistent layout
            padding: const EdgeInsets.all(16.0),
            child: _showChart
                ? _buildChart(context, widget.entries)
                : _buildTable(context, widget.entries),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<ExpenseEntry> entries) {
    // Filter out zero amounts for display
    final filteredEntries = entries.where((entry) => entry.amount != 0).toList();

    if (filteredEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.config.icon,
              size: 48,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              widget.config.emptyStateTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.config.emptyStateSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              const Expanded(
                  flex: 2,
                  child: Text('Date',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              const Expanded(
                  flex: 2,
                  child: Text('Amount',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              const Expanded(
                  flex: 3,
                  child: Text('Reason',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Table content
        Expanded(
          child: ListView.builder(
            itemCount: filteredEntries.length,
            itemBuilder: (context, index) {
              final entry = filteredEntries[index];
              return _buildEntryRow(context, entry, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEntryRow(BuildContext context, ExpenseEntry entry, int index) {
    // Format date with locale-aware formatting
    final dateFormat = DateFormat.yMd();
    final formattedDate = dateFormat.format(entry.date);

    // Format amount using the configuration's formatter
    final amount = widget.config.formatAmount(entry.amount);
    final reason = entry.reason;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: index.isEven
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              formattedDate,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${entry.amount >= 0 ? '+' : ''}$amount',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: entry.amount >= 0
                        ? widget.config.positiveAmountColor(context)
                        : Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              reason,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<ExpenseEntry> entries) {
    // Use the appropriate chart configuration based on the widget config
    ExpenseChartConfiguration chartConfig;
    

    switch (widget.config.type) {
      case LedgerType.karma:
        chartConfig = ExpenseChartConfiguration.karma(context);
        break;
      case LedgerType.nuyen:
        chartConfig = ExpenseChartConfiguration.nuyen(context);
        break;
    }
    return ExpenseChart(
      entries: entries,
      config: chartConfig,
    );
  }
}

// Convenience widgets for easy usage
class KarmaLedger extends StatelessWidget {
  final List<ExpenseEntry> karmaEntries;

  const KarmaLedger({
    super.key,
    required this.karmaEntries,
  });

  @override
  Widget build(BuildContext context) {
    return LedgerWidget(
      entries: karmaEntries,
      config: LedgerConfiguration.karma(),
    );
  }
}

class NuyenLedger extends StatelessWidget {
  final List<ExpenseEntry> nuyenEntries;

  const NuyenLedger({
    super.key,
    required this.nuyenEntries,
  });

  @override
  Widget build(BuildContext context) {
    return LedgerWidget(
      entries: nuyenEntries,
      config: LedgerConfiguration.nuyen(),
    );
  }
}
