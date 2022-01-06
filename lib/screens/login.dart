import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout/models/user.dart';
import 'package:scout/api/api.dart';
import 'home.dart';

enum LoginMode {login, create}

class Login extends StatefulWidget {
	const Login({Key? key, required this.mode}) : super(key: key);

	static const route = '/login';
	static const createRoute = '/login/create';

	final LoginMode mode;

	@override
	_LoginState createState() => _LoginState();
}

enum _LoginPhase {none, login, loading}

class _LoginState extends State<Login> {
	late final Text _message = _loginMode ? const Text('Log In') : const Text('Create Account');

	// if non null indaicates a loggin error has occured along with a message to display
	String? _errorMessage;

	// logging in state
	_LoginPhase _phase = _LoginPhase.none;

	final _usernameController = TextEditingController();
	final _passwordController = TextEditingController();

	bool get _loginMode => widget.mode == LoginMode.login;
	bool get _createMode => widget.mode == LoginMode.create;

	Widget makeChildren(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: _message,
			),
			body: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 64),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						TextField(
							controller: _usernameController,
							autocorrect: false,
							decoration: const InputDecoration(
								hintText: 'username',
							),
						),
						const SizedBox(height: 16),
						TextField(
							controller: _passwordController,
							obscureText: true,
							autocorrect: false,
							decoration: const InputDecoration(
								hintText: 'password',
							),
						),
						SizedBox(
							height: 80,
							child: Center(
								child: Visibility(
									child: const CircularProgressIndicator(
									),
									maintainSize: true,
									maintainAnimation: true,
									maintainState: true,
									visible: _phase == _LoginPhase.loading,
								),
							),
						),
						Visibility(
							child: Text(
								_errorMessage ?? '',
								style: const TextStyle(color: Colors.red),
							),
							maintainSize: true,
							maintainAnimation: true,
							maintainState: true,
							visible: _errorMessage != null && _phase != _LoginPhase.loading,
						),
						const SizedBox(height: 8),
						ElevatedButton(
							child: Padding(
								padding: const EdgeInsets.symmetric(horizontal: 32),
								child: _message,
							),
							onPressed: () {
								setState(() {
									if (_phase == _LoginPhase.none) {
										_phase = _LoginPhase.login;
									}
								});
							},
						),
						if (_loginMode) TextButton(
							onPressed: () => Navigator.pushNamed(context, Login.createRoute),
							child: const Text('Create Account'),
						),
					],
				),
			),
		);
	}

	@override
	void dispose() {
		_usernameController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		if (_phase == _LoginPhase.login) {
			_phase = _LoginPhase.loading;
			var provider = Provider.of<UserModel>(context, listen: false);
			var uname = _usernameController.text;
			var pswd = _passwordController.text;
			return FutureBuilder<User?>(
				future: _loginMode ? provider.login(uname, pswd) : provider.create(uname, pswd),
				builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
					if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
						_phase = _LoginPhase.none;
						_errorMessage = null;
						//WidgetsBinding.instance!.addPostFrameCallback((_) => Navigator.restorablePushReplacementNamed(context, Home.route));
						return makeChildren(context);
					} else if (snapshot.hasError && snapshot.connectionState == ConnectionState.done) {
						// Not using set state, because we are already in a rebuild
						_phase = _LoginPhase.none;
						if (snapshot.error is ConnectionException) {
							_errorMessage = 'Unable to connect to server';
						} else if (snapshot.error is LoginException) {
							_errorMessage = 'Incorrect username or password';
						} else if (snapshot.error is UserCreationException) {
							_errorMessage = 'Username is already in use';
						} else {
							_errorMessage = 'Uknown error';
						}
						return makeChildren(context);
					} else {
						return makeChildren(context);
					}
				},
			);
		} else {
			return makeChildren(context);
		}
	}
}
