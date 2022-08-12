import 'package:driver_monitoring/src/models/contact.dart';
import 'package:driver_monitoring/src/services/contactService.dart';
import 'package:driver_monitoring/src/views/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SoSContacts extends StatefulWidget {
  SoSContacts({Key? key}) : super(key: key);

  @override
  State<SoSContacts> createState() => _SoSContactsState();
}

class _SoSContactsState extends State<SoSContacts> {
  ContactService contactsDb = ContactService();
  List<ContactModel> contacts = [];

  bool contactCheck = false;
  fetchContacts() async {
    var contcts = await contactsDb.fetchContacts();
    setState(() {
      contacts = contcts;
    });
    if (contacts == null || contacts.length <= 3) {
      contactCheck = true;
    }
    setState(() {});
  }

  void checkContactLength() async {
    await fetchContacts();
    if (!contactCheck) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => Home(),
        ),
      );
    }
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
        automaticallyImplyLeading: false,
        title: "SOS Contacts".text.make(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => checkContactLength(),
        ),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: ((context, index) {
          return ListTile(
            title: contacts[index].name.text.make(),
            subtitle: contacts[index].phone.text.make(),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final PhoneContact contact =
              await FlutterContactPicker.pickPhoneContact();
          await contactsDb.addItem(
            ContactModel(
              name: contact.fullName.toString(),
              phone: contact.phoneNumber!.number.toString(),
            ),
          );
          await fetchContacts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
