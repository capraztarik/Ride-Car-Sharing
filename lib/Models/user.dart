class User {
  String email;
  String password;

  User({required this.email,  required this.password});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        email: responseData['email'],
        password: responseData['password']
    );
  }
}