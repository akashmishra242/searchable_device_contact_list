import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:searchable_listview/searchable_listview.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];
  void fetchContacts() async {
    List<Contact> _contacts = [];
    Contact? _contacts1;

    try {
      if (await Permission.contacts.status
          .then((value) => value.isGranted == true)) {
        _contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      _contacts1 = await FlutterContacts.getContact(_contacts[1].id);
      log(_contacts1!.id);
    } catch (e) {
      log(e.toString());
    }

    contacts = _contacts;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SearchableList(
              initialList: contacts,
              builder: (Contact contacts) {
                return ListTile(
                  title: Text(contacts.displayName),
                  subtitle: Text(contacts.phones[0].normalizedNumber),
                );
              },
              onItemSelected: (p0) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("selected contact name is: ${p0.displayName}")));
              },
              displayClearIcon: true,
              loadingWidget: const Center(
                child: CircularProgressIndicator(),
              ),
              filter: (value) {
                value = value.toLowerCase();
                if (value.startsWith(RegExp(r'[0-9]')) ||
                    value.startsWith('+')) {
                  return contacts
                      .where((element) =>
                          element.phones[0].normalizedNumber.contains(value))
                      .toList();
                }
                return contacts
                    .where((element) =>
                        element.displayName.toLowerCase().contains(value))
                    .toList();
              },
              inputDecoration: InputDecoration(
                labelText: "Search Contacts..",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
