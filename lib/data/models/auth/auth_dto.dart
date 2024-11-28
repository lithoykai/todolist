class AuthDTO {
  final String email;
  final String password;

  AuthDTO({required this.email, required this.password});

  factory AuthDTO.fromJson(Map<String, dynamic> json) {
    return AuthDTO(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
