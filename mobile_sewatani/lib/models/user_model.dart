class UserModel {
  final int id;
  final String firebaseUid;
  final String name;
  final String email;
  final String photoUrl;
  final String role;

  const UserModel({
    this.id = 0,
    this.firebaseUid = '',
    required this.name,
    required this.email,
    this.photoUrl = '',
    this.role = '',
  });

  // Alias agar kode lama yang memakai uid tetap aman.
  String get uid => firebaseUid;

  bool get isPetani => role == 'petani';
  bool get isVendor => role == 'vendor';
  bool get hasRole => role.isNotEmpty;

  String get roleLabel {
    if (role == 'vendor') {
      return 'Vendor / Pemilik Alat';
    }

    if (role == 'petani') {
      return 'Petani / Penyewa';
    }

    return 'Belum memilih role';
  }

  UserModel copyWith({
    int? id,
    String? firebaseUid,
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? uid ?? this.firebaseUid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firebaseUid': firebaseUid,
      'uid': firebaseUid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: _toInt(map['id']),
      firebaseUid: (map['firebaseUid'] ?? map['uid'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      photoUrl: (map['photoUrl'] ?? '').toString(),
      role: (map['role'] ?? '').toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
