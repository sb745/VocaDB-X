import 'package:equatable/equatable.dart';


class UserCookie extends Equatable {
  final List<String> cookies;

  const UserCookie({required this.cookies});

  @override
  List<Object> get props => [cookies];

  @override
  String toString() => 'UserCookie { cookies: $cookies }';
}
