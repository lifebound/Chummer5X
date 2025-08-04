import 'package:flutter/material.dart';
import 'package:chummer5x/models/contact.dart';

class ContactsScreen extends StatefulWidget {
  final List<Contact> contacts;
  final VoidCallback? onAddContact;
  final Function(Contact)? onEditContact;
  final Function(Contact)? onDeleteContact;

  const ContactsScreen({
    super.key,
    required this.contacts,
    this.onAddContact,
    this.onEditContact,
    this.onDeleteContact,
  });

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool _expandedAll = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        widget.contacts.isEmpty
            ? _buildEmptyState(context)
            : _buildContactsList(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use a more flexible approach based on available width
            // Calculate the minimum width needed for the row layout
            final titleWidth = _estimateTextWidth('Contacts (${widget.contacts.length})', Theme.of(context).textTheme.headlineSmall);
            final expandButtonWidth = 140; // Approximate width for "Collapse All" button
            final addButtonWidth = 130; // Approximate width for "Add Contact" button
            final spacing = 24; // Space between elements
            
            final minRequiredWidth = titleWidth + expandButtonWidth + addButtonWidth + spacing;
            final shouldWrap = constraints.maxWidth < minRequiredWidth;
            
            return shouldWrap
                ? _buildSmallScreenHeader(context)
                : _buildLargeScreenHeader(context);
          },
        ),
      ),
    );
  }

  double _estimateTextWidth(String text, TextStyle? style) {
    if (style == null) return text.length * 8.0; // Fallback estimation
    
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }

  Widget _buildLargeScreenHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'Contacts (${widget.contacts.length})',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              _expandedAll = !_expandedAll;
            });
          },
          icon: Icon(_expandedAll ? Icons.expand_less : Icons.expand_more),
          label: Text(_expandedAll ? 'Collapse All' : 'Expand All'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: widget.onAddContact,
          icon: const Icon(Icons.person_add),
          label: const Text('Add Contact'),
        ),
      ],
    );
  }

  Widget _buildSmallScreenHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Contacts (${widget.contacts.length})',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _expandedAll = !_expandedAll;
                });
              },
              icon: Icon(_expandedAll ? Icons.expand_less : Icons.expand_more),
              label: Text(_expandedAll ? 'Collapse All' : 'Expand All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: widget.onAddContact,
            icon: const Icon(Icons.person_add),
            label: const Text('Add Contact'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Contacts Yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first contact to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: widget.onAddContact,
            icon: const Icon(Icons.person_add),
            label: const Text('Add Contact'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.contacts.length,
      itemBuilder: (context, index) {
        final contact = widget.contacts[index];
        return ContactCard(
          contact: contact,
          expanded: _expandedAll,
          onEdit: () => widget.onEditContact?.call(contact),
          onDelete: () => widget.onDeleteContact?.call(contact),
        );
      },
    );
  }
}

class ContactCard extends StatefulWidget {
  final Contact contact;
  final bool expanded;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ContactCard({
    super.key,
    required this.contact,
    this.expanded = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.expanded;
  }

  @override
  void didUpdateWidget(ContactCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded != oldWidget.expanded) {
      _isExpanded = widget.expanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          _buildContactHeader(context),
          if (_isExpanded) _buildContactDetails(context),
        ],
      ),
    );
  }

  Widget _buildContactHeader(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Connection/Loyalty badges
            _buildRatingBadge(context, 'C', widget.contact.connection, Colors.blue),
            const SizedBox(width: 8),
            _buildRatingBadge(context, 'L', widget.contact.loyalty, Colors.green),
            const SizedBox(width: 16),
            
            // Contact info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contact.displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.contact.role.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.contact.role,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (widget.contact.location.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.contact.location,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            // Action buttons
            IconButton(
              onPressed: widget.onEdit,
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Contact',
            ),
            IconButton(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Contact',
            ),
            Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBadge(BuildContext context, String label, int value, Color color) {
    return Container(
      width: 32,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 8),
          _buildDetailsGrid(context),
          if (widget.contact.notes.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildNotesSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    final details = <String, String>{
      if (widget.contact.metatype.isNotEmpty) 'Metatype': widget.contact.metatype,
      if (widget.contact.gender.isNotEmpty) 'Gender': widget.contact.gender,
      if (widget.contact.age.isNotEmpty) 'Age': widget.contact.age,
      if (widget.contact.contacttype.isNotEmpty) 'Type': widget.contact.contacttype,
      if (widget.contact.preferredpayment.isNotEmpty) 'Preferred Payment': widget.contact.preferredpayment,
      if (widget.contact.hobbiesvice.isNotEmpty) 'Hobbies/Vice': widget.contact.hobbiesvice,
      if (widget.contact.personallife.isNotEmpty) 'Personal Life': widget.contact.personallife,
    };

    if (details.isEmpty) {
      return Text(
        'No additional details available',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: details.entries.map((entry) => _buildDetailChip(context, entry.key, entry.value)).toList(),
    );
  }

  Widget _buildDetailChip(BuildContext context, String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      labelStyle: Theme.of(context).textTheme.bodySmall,
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notes,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.contact.notes,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
