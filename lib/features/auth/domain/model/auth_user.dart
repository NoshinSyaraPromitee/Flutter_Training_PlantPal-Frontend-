class AuthUser {
  const AuthUser({required this.id, required this.email, this.name});
  final String id;
  final String email;
  final String? name;

  String get displayName {
    final n = name?.trim();
    if (n != null && n.isNotEmpty) return n;
    final local = email.split('@').first;
    return local.isEmpty ? 'Plant Parent' : local[0].toUpperCase() + local.substring(1);
  }

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name};
  factory AuthUser.fromJson(Map<String, dynamic> j) =>
      AuthUser(id: j['id'] as String, email: j['email'] as String, name: j['name'] as String?);
}