import 'dart:async';

import 'misc.dart';

class LoginException implements Exception {
	@override
	String toString() => 'LoginException: incorrect username or password';
}

class UserCreationException implements Exception {
	@override
	String toString() => 'UserCreationException: could not create user: username already exists';
}

class User {
	// Api token
	late final String _token;
	String get token => _token;

	// Throws ConnectionException if cannot connect, throws LoginException if username and password are wrong
	static Future<User> login(String name, String password) async {
		var out = User();

		var result = await sendQuery('{authenticate(name: "$name", password: "$password")}');

		var tmp = result['data']['authenticate'];
		if (tmp == null) {
			throw LoginException();
		}
		out._token = tmp as String;

		return out;
	}

	static Future<User> create(String name, String password) async {
		var createResult = await sendQuery('mutation{createUser(name: "$name", password: "$password"){id}}');
		// error occured
		if (createResult['data'] == null) {
			throw UserCreationException();
		}

		return login(name, password);
	}
}
