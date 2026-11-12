/// Peran pengguna. Peran lebih tinggi hanya bisa diberikan admin
/// (lewat Firebase Console / halaman admin), bukan saat mendaftar.
enum UserRole {
  warga,
  rt,
  pengurus,
  admin;

  static UserRole fromString(String? value) {
    return UserRole.values.firstWhere(
      (r) => r.name == value,
      orElse: () => UserRole.warga,
    );
  }

  String get label => switch (this) {
        UserRole.warga => 'Warga',
        UserRole.rt => 'Ketua RT',
        UserRole.pengurus => 'Pengurus',
        UserRole.admin => 'Admin',
      };

  bool get isPengurus => this != UserRole.warga;
}

class AppUser {
  const AppUser({
    required this.uid,
    required this.name,
    required this.rt,
    required this.role,
  });

  final String uid;
  final String name;

  /// Nomor RT asal, 1-16.
  final int rt;
  final UserRole role;

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      name: (data['name'] as String?) ?? 'Warga',
      rt: (data['rt'] as num?)?.toInt() ?? 1,
      role: UserRole.fromString(data['role'] as String?),
    );
  }
}
