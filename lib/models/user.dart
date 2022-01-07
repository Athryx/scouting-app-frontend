import 'package:flutter/foundation.dart';
import 'package:scout/api/user.dart';

class UserModel extends ChangeNotifier {
	User? _user;

	User? get user => _user;
	set user(User? user) {
		_user = user;
		notifyListeners();
	}

	// Attempts to log in, and sets user property is succesful, and returns the user on success
	Future<User?> login(String username, String password) async {
		user = await User.login(username, password);
		return user;
	}

	// Attempts to create user account, and sets user property on success
	Future<User?> create(String username, String password) async {
		user = await User.create(username, password);
		return user;
	}

	void logout() {
		user = null;
	}
}
