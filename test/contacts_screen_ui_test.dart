import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/models/contact.dart';
import 'package:chummer5x/screens/contacts_screen.dart';

void main() {
  group('ContactsScreen UI Tests', () {
    testWidgets('should display empty state when no contacts', (WidgetTester tester) async {
      // Given: Empty contacts list
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContactsScreen(
              contacts: [],
              onAddContact: () {},
            ),
          ),
        ),
      );

      // Then: Should show empty state
      expect(find.text('No Contacts Yet'), findsOneWidget, reason: 'Should show empty state message');
      expect(find.text('Add your first contact to get started'), findsOneWidget, reason: 'Should show empty state subtitle');
      expect(find.byIcon(Icons.people_outline), findsOneWidget, reason: 'Should show empty state icon');
      expect(find.text('Add Contact'), findsWidgets, reason: 'Should show add contact button');
    });

    testWidgets('should display contacts list when contacts exist', (WidgetTester tester) async {
      // Given: Sample contacts
      final contacts = [
        Contact(
          name: 'Marcus Johnson',
          role: 'Fixer',
          location: 'Downtown Seattle',
          connection: 4,
          loyalty: 3,
          metatype: 'Human',
          gender: 'Male',
          age: 'Mid-30s',
          contacttype: 'Contact',
          preferredpayment: 'Credstick',
          hobbiesvice: 'Classic Cars',
          personallife: 'Single Father',
          type: 'Street Contact',
          file: '',
          relative: '',
          notes: 'Reliable fixer with connections to the automotive underworld.',
          notesColor: '',
          groupname: '',
          colour: 0,
          group: false,
          family: false,
          blackmail: false,
          free: false,
          groupenabled: false,
          guid: 'marcus-guid',
          mainmugshotindex: -1,
          mugshots: [],
        ),
        Contact(
          name: 'Dr. Sarah Chen',
          role: 'Street Doc',
          location: 'University District',
          connection: 2,
          loyalty: 5,
          metatype: 'Human',
          gender: 'Female',
          age: 'Late 20s',
          contacttype: 'Contact',
          preferredpayment: 'Nuyen',
          hobbiesvice: 'Medical Research',
          personallife: 'Workaholic',
          type: 'Professional Contact',
          file: '',
          relative: '',
          notes: 'Brilliant young doctor who patches up shadowrunners.',
          notesColor: '',
          groupname: '',
          colour: 0,
          group: false,
          family: false,
          blackmail: false,
          free: false,
          groupenabled: false,
          guid: 'sarah-guid',
          mainmugshotindex: -1,
          mugshots: [],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContactsScreen(
              contacts: contacts,
              onAddContact: () {},
              onEditContact: (contact) {},
              onDeleteContact: (contact) {},
            ),
          ),
        ),
      );

      // Then: Should show contacts list
      expect(find.text('Contacts (2)'), findsOneWidget, reason: 'Should show contacts count in header');
      expect(find.text('Marcus Johnson'), findsOneWidget, reason: 'Should show first contact name');
      expect(find.text('Dr. Sarah Chen'), findsOneWidget, reason: 'Should show second contact name');
      expect(find.text('Fixer'), findsOneWidget, reason: 'Should show first contact role');
      expect(find.text('Street Doc'), findsOneWidget, reason: 'Should show second contact role');
      
      // Should show connection/loyalty badges
      expect(find.text('C'), findsNWidgets(2), reason: 'Should show connection badges for both contacts');
      expect(find.text('L'), findsNWidgets(2), reason: 'Should show loyalty badges for both contacts');
      expect(find.text('4'), findsOneWidget, reason: 'Should show Marcus connection rating');
      expect(find.text('3'), findsOneWidget, reason: 'Should show Marcus loyalty rating');
      expect(find.text('2'), findsOneWidget, reason: 'Should show Sarah connection rating');
      expect(find.text('5'), findsOneWidget, reason: 'Should show Sarah loyalty rating');

      // Should show locations
      expect(find.text('Downtown Seattle'), findsOneWidget, reason: 'Should show first contact location');
      expect(find.text('University District'), findsOneWidget, reason: 'Should show second contact location');
    });

    testWidgets('should expand contact details when tapped', (WidgetTester tester) async {
      // Given: Contact with detailed information
      final contact = Contact(
        name: 'Marcus Johnson',
        role: 'Fixer',
        location: 'Downtown Seattle',
        connection: 4,
        loyalty: 3,
        metatype: 'Human',
        gender: 'Male',
        age: 'Mid-30s',
        contacttype: 'Contact',
        preferredpayment: 'Credstick',
        hobbiesvice: 'Classic Cars',
        personallife: 'Single Father',
        type: 'Street Contact',
        file: '',
        relative: '',
        notes: 'Reliable fixer with connections to the automotive underworld.',
        notesColor: '',
        groupname: '',
        colour: 0,
        group: false,
        family: false,
        blackmail: false,
        free: false,
        groupenabled: false,
        guid: 'marcus-guid',
        mainmugshotindex: -1,
        mugshots: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContactsScreen(
              contacts: [contact],
              onAddContact: () {},
              onEditContact: (contact) {},
              onDeleteContact: (contact) {},
            ),
          ),
        ),
      );

      // When: Tap on the contact to expand details
      await tester.tap(find.text('Marcus Johnson'));
      await tester.pumpAndSettle();

      // Then: Should show expanded details
      expect(find.text('Metatype: Human'), findsOneWidget, reason: 'Should show metatype detail');
      expect(find.text('Gender: Male'), findsOneWidget, reason: 'Should show gender detail');
      expect(find.text('Age: Mid-30s'), findsOneWidget, reason: 'Should show age detail');
      expect(find.text('Preferred Payment: Credstick'), findsOneWidget, reason: 'Should show preferred payment detail');
      expect(find.text('Hobbies/Vice: Classic Cars'), findsOneWidget, reason: 'Should show hobbies/vice detail');
      expect(find.text('Personal Life: Single Father'), findsOneWidget, reason: 'Should show personal life detail');
      expect(find.text('Notes'), findsOneWidget, reason: 'Should show notes section header');
      expect(find.text('Reliable fixer with connections to the automotive underworld.'), findsOneWidget, reason: 'Should show notes content');
    });

    testWidgets('should trigger callbacks when buttons are pressed', (WidgetTester tester) async {
      // Given: Contact and callback tracking
      bool addCalled = false;
      bool editCalled = false;
      bool deleteCalled = false;
      Contact? editedContact;
      Contact? deletedContact;

      final contact = Contact(
        name: 'Test Contact',
        role: 'Test Role',
        location: 'Test Location',
        connection: 2,
        loyalty: 3,
        metatype: '',
        gender: '',
        age: '',
        contacttype: '',
        preferredpayment: '',
        hobbiesvice: '',
        personallife: '',
        type: '',
        file: '',
        relative: '',
        notes: '',
        notesColor: '',
        groupname: '',
        colour: 0,
        group: false,
        family: false,
        blackmail: false,
        free: false,
        groupenabled: false,
        guid: 'test-guid',
        mainmugshotindex: -1,
        mugshots: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContactsScreen(
              contacts: [contact],
              onAddContact: () => addCalled = true,
              onEditContact: (c) {
                editCalled = true;
                editedContact = c;
              },
              onDeleteContact: (c) {
                deleteCalled = true;
                deletedContact = c;
              },
            ),
          ),
        ),
      );

      // When: Tap add contact button
      await tester.tap(find.text('Add Contact').first);
      await tester.pump();

      // Then: Add callback should be called
      expect(addCalled, isTrue, reason: 'Add contact callback should be triggered');

      // When: Tap edit button
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pump();

      // Then: Edit callback should be called
      expect(editCalled, isTrue, reason: 'Edit contact callback should be triggered');
      expect(editedContact, equals(contact), reason: 'Edit callback should receive the correct contact');

      // When: Tap delete button
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pump();

      // Then: Delete callback should be called
      expect(deleteCalled, isTrue, reason: 'Delete contact callback should be triggered');
      expect(deletedContact, equals(contact), reason: 'Delete callback should receive the correct contact');
    });
  });
}
