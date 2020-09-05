import 'package:meta/meta.dart';

class User {
  int id;
  String fullName;
  String phone;

  User(
      {this.id,
        this.fullName,
  @required this.phone});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'id': id,
      'full_name': fullName,
      'phone': phone,
    };
    return map;
  }

  get fullPhoneNumber => '+84$phone';

  User.fromJson(Map<String, dynamic> map) {
    id = map['id'] as int;
    fullName = map['full_name'] as String;
    phone = map['phone'] as String;
  }

  @override
  String toString() {
    return ('id: ${this.id} - full name: ${this.fullName}');
  }
}
