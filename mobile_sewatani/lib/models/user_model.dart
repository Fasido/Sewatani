class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  bool get isPetani => role == 'petani';
  bool get isVendor => role == 'vendor';

  String get roleLabel => isVendor ? 'Vendor / Pemilik Alat' : 'Petani / Penyewa';
}
