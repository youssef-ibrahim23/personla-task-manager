import 'package:image_picker/image_picker.dart';

class User {
  String? uid;
  String name;
  String email;
  String phoneNumber;
  String? password;
  XFile? image;

  User({
    this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.password,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'UID': uid,
      'NAME': name,
      'EMAIL': email,
      'PHONE_NUMBER': phoneNumber,
      'PASSWORD': password,
      'IMAGE_PATH': image?.path,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['UID']?.toString(),
      name: map['NAME'],
      email: map['EMAIL'],
      phoneNumber: map['PHONE_NUMBER'],
      password: map['PASSWORD'],
      image: map['IMAGE_PATH'] != null ? XFile(map['IMAGE_PATH']) : null,
    );
  }

  @override
  String toString() =>
      'User(uid: $uid, name: $name, email: $email, phone: $phoneNumber, image: ${image?.path})';
}
