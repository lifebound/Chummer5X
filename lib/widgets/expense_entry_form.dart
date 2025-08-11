// A new self-contained widget for the form
import 'package:flutter/material.dart';

class ExpenseEntryForm extends StatefulWidget {
  final Function({num? karma, num? nuyen, required String reason}) onSubmit;

  const ExpenseEntryForm({super.key, required this.onSubmit});

  @override
  State<ExpenseEntryForm> createState() => ExpenseEntryFormState();
}

class ExpenseEntryFormState extends State<ExpenseEntryForm> {
  final _karmaController = TextEditingController();
  final _nuyenController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _karmaController.dispose();
    _nuyenController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final karmaText = _karmaController.text.trim();
    final nuyenText = _nuyenController.text.trim();
    final reason = _reasonController.text.trim();

    // Validation
    if (reason.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a reason for this entry'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (karmaText.isEmpty && nuyenText.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter either a karma or nuyen amount'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Parse amounts
    num? karmaAmount;
    num? nuyenAmount;

    if (karmaText.isNotEmpty) {
      karmaAmount = num.tryParse(karmaText);
      if (karmaAmount == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid karma amount. Please enter a number.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    if (nuyenText.isNotEmpty) {
      nuyenAmount = num.tryParse(nuyenText);
      if (nuyenAmount == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid nuyen amount. Please enter a number.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    try {
      // Call the parent widget's callback with the parsed values
      await widget.onSubmit(
        karma: karmaAmount,
        nuyen: nuyenAmount,
        reason: reason,
      );

      // Clear the form on success
      _karmaController.clear();
      _nuyenController.clear();
      _reasonController.clear();

      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entry added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding entry: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Entry',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Responsive form layout
          LayoutBuilder(
            builder: (context, constraints) {
              // Use column layout on narrow screens (< 600px)
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    // Karma field
                    TextField(
                      controller: _karmaController,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      decoration: InputDecoration(
                        labelText: 'Karma',
                        hintText: 'e.g., -5, +10',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.psychology),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Nuyen field
                    TextField(
                      controller: _nuyenController,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      decoration: InputDecoration(
                        labelText: 'Nuyen',
                        hintText: 'e.g., -1000, +5000',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.attach_money),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Reason field
                    TextField(
                      controller: _reasonController,
                      decoration: InputDecoration(
                        labelText: 'Reason',
                        hintText: 'Reason for expense/income',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.description),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Submit button - full width on mobile
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _handleSubmit,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Entry'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // Use row layout on wider screens
                return Row(
                  children: [
                    // Karma field
                    Expanded(
                      child: TextField(
                        controller: _karmaController,
                        keyboardType:
                            const TextInputType.numberWithOptions(signed: true),
                        decoration: InputDecoration(
                          labelText: 'Karma',
                          hintText: 'e.g., -5, +10',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.psychology),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Nuyen field
                    Expanded(
                      child: TextField(
                        controller: _nuyenController,
                        keyboardType:
                            const TextInputType.numberWithOptions(signed: true),
                        decoration: InputDecoration(
                          labelText: 'Nuyen',
                          hintText: 'e.g., -1000, +5000',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.attach_money),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Reason field
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _reasonController,
                        decoration: InputDecoration(
                          labelText: 'Reason',
                          hintText: 'Reason for expense/income',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.description),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Submit button
                    ElevatedButton.icon(
                      onPressed: _handleSubmit,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Entry'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}