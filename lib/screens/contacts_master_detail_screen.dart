import 'package:flutter/material.dart';
import 'package:chummer5x/models/contact.dart';

class ContactsMasterDetailScreen extends StatefulWidget {
  final List<Contact> contacts;
  final VoidCallback? onAddContact;
  final Function(Contact)? onEditContact;
  final Function(Contact)? onDeleteContact;

  const ContactsMasterDetailScreen({
    super.key,
    required this.contacts,
    this.onAddContact,
    this.onEditContact,
    this.onDeleteContact,
  });

  @override
  State<ContactsMasterDetailScreen> createState() => _ContactsMasterDetailScreenState();
}

class _ContactsMasterDetailScreenState extends State<ContactsMasterDetailScreen> {
  Contact? _selectedContact;

  @override
  void initState() {
    super.initState();
    if (widget.contacts.isNotEmpty) {
      _selectedContact = widget.contacts.first;
    }
  }

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
                    SizedBox(
                      width: 400,
                      child: _buildContactsList(context),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: _selectedContact != null
                          ? _buildContactDetail(context, _selectedContact!)
                          : _buildNoSelectionState(context),
                    ),
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
              'Contacts',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            if (_selectedContact != null) ...[
              OutlinedButton.icon(
                onPressed: () => widget.onEditContact?.call(_selectedContact!),
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  widget.onDeleteContact?.call(_selectedContact!);
                  if (widget.contacts.length > 1) {
                    final currentIndex = widget.contacts.indexOf(_selectedContact!);
                    final newIndex = currentIndex > 0 ? currentIndex - 1 : 0;
                    _selectedContact = widget.contacts[newIndex];
                  } else {
                    _selectedContact = null;
                  }
                  setState(() {});
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(width: 16),
            ],
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
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 0, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Contact List (${widget.contacts.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: widget.contacts.length,
              itemBuilder: (context, index) {
                final contact = widget.contacts[index];
                final isSelected = contact == _selectedContact;
                return _buildContactListItem(context, contact, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactListItem(BuildContext context, Contact contact, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _selectedContact = contact),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : null,
          border: isSelected
              ? Border(
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    contact.displayName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildSmallRatingBadge(context, 'C', contact.connection, Colors.blue),
                const SizedBox(width: 4),
                _buildSmallRatingBadge(context, 'L', contact.loyalty, Colors.green),
              ],
            ),
            if (contact.role.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                contact.role,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (contact.location.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      contact.location,
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
    );
  }

  Widget _buildSmallRatingBadge(BuildContext context, String label, int value, Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSelectionState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a Contact',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a contact from the list to view details',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetail(BuildContext context, Contact contact) {
    return Card(
      margin: const EdgeInsets.fromLTRB(4, 0, 8, 8),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactHeader(context, contact),
              const SizedBox(height: 24),
              _buildContactInfo(context, contact),
              if (contact.notes.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildNotesSection(context, contact),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactHeader(BuildContext context, Contact contact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          contact.displayName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (contact.role.isNotEmpty) ...[
              Chip(
                label: Text(contact.role),
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
            ],
            _buildRatingBadge(context, 'Connection', contact.connection, Colors.blue),
            const SizedBox(width: 12),
            _buildRatingBadge(context, 'Loyalty', contact.loyalty, Colors.green),
          ],
        ),
        if (contact.location.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 8),
              Text(
                contact.location,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildRatingBadge(BuildContext context, String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, Contact contact) {
    final infoItems = <Widget>[];

    void addInfoItem(String label, String value, IconData icon) {
      if (value.isNotEmpty) {
        infoItems.add(_buildInfoItem(context, label, value, icon));
      }
    }

    addInfoItem('Metatype', contact.metatype, Icons.person);
    addInfoItem('Gender', contact.gender, Icons.wc);
    addInfoItem('Age', contact.age, Icons.cake);
    addInfoItem('Contact Type', contact.contacttype, Icons.category);
    addInfoItem('Preferred Payment', contact.preferredpayment, Icons.payment);
    addInfoItem('Hobbies/Vice', contact.hobbiesvice, Icons.sports_esports);
    addInfoItem('Personal Life', contact.personallife, Icons.home);

    if (infoItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 12),
            Text(
              'No additional information available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...infoItems,
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context, Contact contact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            contact.notes,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
