import 'package:flutter/material.dart';
import 'package:chummer5x/models/contact.dart';

class ContactsTableScreen extends StatefulWidget {
  final List<Contact> contacts;
  final VoidCallback? onAddContact;
  final Function(Contact)? onEditContact;
  final Function(Contact)? onDeleteContact;

  const ContactsTableScreen({
    super.key,
    required this.contacts,
    this.onAddContact,
    this.onEditContact,
    this.onDeleteContact,
  });

  @override
  State<ContactsTableScreen> createState() => _ContactsTableScreenState();
}

class _ContactsTableScreenState extends State<ContactsTableScreen> {
  Contact? _selectedContact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: widget.contacts.isEmpty
              ? _buildEmptyState(context)
              : Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildContactsTable(context),
                    ),
                    if (_selectedContact != null) ...[
                      const VerticalDivider(width: 1),
                      Expanded(
                        flex: 1,
                        child: _buildContactDetails(context, _selectedContact!),
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              'Contacts (${widget.contacts.length})',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: widget.onAddContact,
              icon: const Icon(Icons.person_add),
              label: const Text('Add Contact'),
            ),
          ],
        ),
      ),
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
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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

  Widget _buildContactsTable(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildTableHeader(context),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: widget.contacts.length,
              itemBuilder: (context, index) {
                final contact = widget.contacts[index];
                final isSelected = contact == _selectedContact;
                return _buildTableRow(context, contact, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      ),
      child: Row(
        children: [
          const SizedBox(width: 48), // Space for rating badges
          const Expanded(
            flex: 3,
            child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Expanded(
            flex: 2,
            child: Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Expanded(
            flex: 2,
            child: Text('Archetype', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Expanded(
            flex: 1,
            child: Text('C/L', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 80), // Space for action buttons
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, Contact contact, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _selectedContact = contact),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : null,
        ),
        child: Row(
          children: [
            // Rating badges
            SizedBox(
              width: 48,
              child: Row(
                children: [
                  _buildSmallRatingBadge(context, contact.connection, Colors.blue),
                  const SizedBox(width: 4),
                  _buildSmallRatingBadge(context, contact.loyalty, Colors.green),
                ],
              ),
            ),
            
            // Name
            Expanded(
              flex: 3,
              child: Text(
                contact.displayName,
                style: const TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Location
            Expanded(
              flex: 2,
              child: Text(
                contact.location.isNotEmpty ? contact.location : '-',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Archetype
            Expanded(
              flex: 2,
              child: Text(
                contact.role.isNotEmpty ? contact.role : '-',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Connection/Loyalty
            Expanded(
              flex: 1,
              child: Text('${contact.connection}/${contact.loyalty}'),
            ),
            
            // Action buttons
            SizedBox(
              width: 80,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => widget.onEditContact?.call(contact),
                    icon: const Icon(Icons.edit, size: 18),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    onPressed: () => widget.onDeleteContact?.call(contact),
                    icon: const Icon(Icons.delete, size: 18),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallRatingBadge(BuildContext context, int value, Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          value.toString(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildContactDetails(BuildContext context, Contact contact) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    contact.displayName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _selectedContact = null),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(context, 'Role/Archetype', contact.role),
            _buildDetailRow(context, 'Location', contact.location),
            _buildDetailRow(context, 'Connection', contact.connection.toString()),
            _buildDetailRow(context, 'Loyalty', contact.loyalty.toString()),
            if (contact.metatype.isNotEmpty)
              _buildDetailRow(context, 'Metatype', contact.metatype),
            if (contact.gender.isNotEmpty)
              _buildDetailRow(context, 'Gender', contact.gender),
            if (contact.age.isNotEmpty)
              _buildDetailRow(context, 'Age', contact.age),
            if (contact.preferredpayment.isNotEmpty)
              _buildDetailRow(context, 'Preferred Payment', contact.preferredpayment),
            if (contact.hobbiesvice.isNotEmpty)
              _buildDetailRow(context, 'Hobbies/Vice', contact.hobbiesvice),
            if (contact.personallife.isNotEmpty)
              _buildDetailRow(context, 'Personal Life', contact.personallife),
            if (contact.notes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(contact.notes),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
