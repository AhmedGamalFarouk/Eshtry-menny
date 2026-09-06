class UserProfileModel {
  final int id;
  final String email;
  final String username;
  final String phone;
  final UserName name;
  final UserAddress address;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.name,
    required this.address,
  });

  String get fullName {
    final first = name.firstname.isNotEmpty
        ? '${name.firstname[0].toUpperCase()}${name.firstname.substring(1)}'
        : '';
    final last = name.lastname.isNotEmpty
        ? '${name.lastname[0].toUpperCase()}${name.lastname.substring(1)}'
        : '';
    return '$first $last'.trim();
  }

  String get initials {
    final first = name.firstname.isNotEmpty ? name.firstname[0].toUpperCase() : '';
    final last = name.lastname.isNotEmpty ? name.lastname[0].toUpperCase() : '';
    return '$first$last'.isNotEmpty ? '$first$last' : 'U';
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] != null
          ? UserName.fromJson(json['name'] as Map<String, dynamic>)
          : UserName(firstname: '', lastname: ''),
      address: json['address'] != null
          ? UserAddress.fromJson(json['address'] as Map<String, dynamic>)
          : UserAddress(
              city: '',
              street: '',
              number: 0,
              zipcode: '',
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'phone': phone,
      'name': name.toJson(),
      'address': address.toJson(),
    };
  }
}

class UserName {
  final String firstname;
  final String lastname;

  UserName({required this.firstname, required this.lastname});

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}

class UserAddress {
  final String city;
  final String street;
  final int number;
  final String zipcode;

  UserAddress({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
  });

  String get formattedAddress {
    final parts = [
      if (number > 0) '$number',
      if (street.isNotEmpty) street,
      if (city.isNotEmpty) city,
      if (zipcode.isNotEmpty) zipcode,
    ];
    return parts.join(', ');
  }

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      city: json['city'] ?? '',
      street: json['street'] ?? '',
      number: json['number'] is num ? (json['number'] as num).toInt() : 0,
      zipcode: json['zipcode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'number': number,
      'zipcode': zipcode,
    };
  }
}
