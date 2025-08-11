import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/expense_entry.dart';

class ExpenseChartConfiguration {
  final String title;
  final Color titleColor;
  final Color primaryColor;
  final Color secondaryColor;
  final String Function(num) formatAmount;
  final String Function(num) formatTooltipAmount;
  final Widget Function(num) formatLeftAxisLabel;

  const ExpenseChartConfiguration({
    required this.title,
    required this.titleColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.formatAmount,
    required this.formatTooltipAmount,
    required this.formatLeftAxisLabel,
  });

  static ExpenseChartConfiguration karma(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern();
    
    return ExpenseChartConfiguration(
      title: 'Karma',
      titleColor: Theme.of(context).colorScheme.secondary,
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      formatAmount: (amount) => numberFormat.format(amount),
      formatTooltipAmount: (amount) =>
          '${numberFormat.format(amount.round())} karma',
      formatLeftAxisLabel: (value) => Text(
        value.toInt().toString(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 10,
        ),
      ),
    );
  }

  static ExpenseChartConfiguration nuyen(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '¥', decimalDigits: 2);
    
    return ExpenseChartConfiguration(
      title: 'Nuyen',
      titleColor: Theme.of(context).colorScheme.secondary,
      primaryColor: Colors.green,
      secondaryColor: Colors.greenAccent,
      formatAmount: (amount) => currencyFormat.format(amount),
      formatTooltipAmount: (amount) => currencyFormat.format(amount),
      formatLeftAxisLabel: (value) {
        // Format large numbers with K suffix for nuyen
        final intValue = value.toInt();
        String displayValue;
        if (intValue.abs() >= 1000) {
          displayValue = '${(intValue / 1000).toStringAsFixed(0)}K';
        } else {
          displayValue = intValue.toString();
        }
        return Text(
          '¥$displayValue',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        );
      },
    );
  }
}

class ExpenseChart extends StatelessWidget {
  final List<ExpenseEntry> entries;
  final ExpenseChartConfiguration config;

  const ExpenseChart({
    super.key,
    required this.entries,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    // Filter out zero amounts for chart display
    final filteredEntries =
        entries.where((entry) => entry.amount != 0).toList();

    if (filteredEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.show_chart,
              size: 64,
              color: config.primaryColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No ${config.title} Data',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: config.primaryColor,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add ${config.title.toLowerCase()} entries to see the chart',
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

    // Sort all filtered entries chronologically first
    final sortedEntries = List<ExpenseEntry>.from(filteredEntries)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Find the date range (first entry to last entry)
    final firstDate = DateTime(sortedEntries.first.date.year,
        sortedEntries.first.date.month, sortedEntries.first.date.day);
    final lastDate = DateTime(sortedEntries.last.date.year,
        sortedEntries.last.date.month, sortedEntries.last.date.day);

    // Generate all calendar days in the range (continuous timeline)
    final allDays = <DateTime>[];
    var currentDate = firstDate;
    while (currentDate.isBefore(lastDate.add(const Duration(days: 1)))) {
      allDays.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Group entries by calendar day
    final Map<DateTime, List<ExpenseEntry>> entriesByDay = {};
    for (final entry in sortedEntries) {
      final dayKey =
          DateTime(entry.date.year, entry.date.month, entry.date.day);
      entriesByDay.putIfAbsent(dayKey, () => []).add(entry);
    }

    // Create chart data with individual entries stacked for same dates
    final chartData = <FlSpot>[];
    final entryToSpotMapping =
        <ExpenseEntry, FlSpot>{}; // Track which entry corresponds to which spot
    num runningTotal = 0;

    for (int dayIndex = 0; dayIndex < allDays.length; dayIndex++) {
      final day = allDays[dayIndex];
      final entriesForDay = entriesByDay[day];

      if (entriesForDay != null) {
        // Add each entry for this day as a separate point
        for (int entryIndex = 0;
            entryIndex < entriesForDay.length;
            entryIndex++) {
          final entry = entriesForDay[entryIndex];
          runningTotal += entry.amount;

          // Use day index as x-coordinate, add small offset for stacking entries on same day
          final xPos = dayIndex.toDouble() +
              (entryIndex * 0.05); // Smaller offset for better visual
          final spot = FlSpot(xPos, runningTotal.toDouble());
          chartData.add(spot);
          entryToSpotMapping[entry] = spot;
        }
      }
    }

    // Find min/max values for better scaling
    final maxY =
        chartData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    final minY =
        chartData.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    final padding = (maxY - minY) * 0.1; // 10% padding

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${config.title} Over Time',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: config.titleColor,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  horizontalInterval: (maxY - minY) / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < allDays.length) {
                          final date = allDays[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${date.month}/${date.day}',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return config.formatLeftAxisLabel(value);
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: allDays.isEmpty
                    ? 0
                    : (allDays.length - 1).toDouble() +
                        0.5, // Account for stacking offset
                minY: minY - padding,
                maxY: maxY + padding,
                lineBarsData: [
                  LineChartBarData(
                    spots: chartData,
                    isCurved: false,
                    color: config.primaryColor,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: config.primaryColor,
                          strokeWidth: 2,
                          strokeColor: Theme.of(context).colorScheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: config.primaryColor.withValues(alpha: 0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        // Find the entry that corresponds to this spot
                        final entry = entryToSpotMapping.entries
                            .where((e) =>
                                e.value.x == spot.x && e.value.y == spot.y)
                            .firstOrNull
                            ?.key;

                        if (entry != null) {
                          final date = entry.date;
                          final runningTotalFormatted =
                              config.formatTooltipAmount(spot.y);
                          final entryAmountFormatted =
                              config.formatAmount(entry.amount);

                          // Build tooltip with entry details
                          String tooltip =
                              '${date.month}/${date.day}/${date.year}\n'
                              'Running Total: $runningTotalFormatted\n'
                              'This Entry: ${entry.amount > 0 ? '+' : ''}$entryAmountFormatted\n'
                              '${entry.reason}';

                          return LineTooltipItem(
                            tooltip,
                            TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 12,
                            ),
                          );
                        }
                        return null;
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Convenience widgets for easy usage
class KarmaChart extends StatelessWidget {
  final List<ExpenseEntry> karmaEntries;

  const KarmaChart({
    super.key,
    required this.karmaEntries,
  });

  @override
  Widget build(BuildContext context) {
    return ExpenseChart(
      entries: karmaEntries,
      config: ExpenseChartConfiguration.karma(context),
    );
  }
}

class NuyenChart extends StatelessWidget {
  final List<ExpenseEntry> nuyenEntries;

  const NuyenChart({
    super.key,
    required this.nuyenEntries,
  });

  @override
  Widget build(BuildContext context) {
    return ExpenseChart(
      entries: nuyenEntries,
      config: ExpenseChartConfiguration.nuyen(context),
    );
  }
}
