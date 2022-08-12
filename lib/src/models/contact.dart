class ContactModel {
  final int? id;
  final String name;
  final String phone;

  ContactModel({this.id, required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "phone": phone,
    };
  }
}
