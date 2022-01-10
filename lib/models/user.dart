import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:scout/api/user.dart';
import 'package:scout/consts.dart';

class UserModel extends ChangeNotifier {
	User? _user;
	Link? _link;

	User? get user => _user;
	Link? get link => _link;

	void _initLink() {
		if (_user != null) {
			_link = HttpLink(
				serverUrl,
				defaultHeaders: {
					"token": _user!.token,
				},
			);
		} else {
			_link = null;
			return;
		}
	}

	// Attempts to log in, and sets user property is succesful, and returns the user on success
	Future<User?> login(String username, String password) async {
		_user = await User.login(username, password);
		_initLink();
		notifyListeners();
		return user;
	}

	// Attempts to create user account, and sets user property on success
	Future<User?> create(String username, String password) async {
		_user = await User.create(username, password);
		_initLink();
		notifyListeners();
		return user;
	}

	void logout() {
		_user = null;
		_link = null;
		notifyListeners();
	}
}
