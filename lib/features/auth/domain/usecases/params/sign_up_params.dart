import 'package:equatable/equatable.dart';

class SignUpParams extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;

  const SignUpParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [fullName, email, password, confirmPassword];
}