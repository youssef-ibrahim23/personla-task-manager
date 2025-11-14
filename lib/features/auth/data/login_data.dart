class LoginData {
  final String email;
  final String password;

  const LoginData({
    required this.email,
    required this.password,
  });

  LoginData copyWith({
    String? email,
    String? password,
  }) {
    return LoginData(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() => 'LoginData(email: $email, password: $password)';
}
