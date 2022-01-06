import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout/models/user.dart';
import 'package:scout/api/user.dart';
import 'home.dart';

class Login extends StatefulWidget {
	const Login({Key? key}) : super(key: key);

	static const route = '/login';

	@override
	_LoginState createState() => _LoginState();
}

enum _LoginPhase {none, login, loading}

class _LoginState extends State<Login> {
	// if non null indaicates a loggin error has occured along with a message to display
	String? _errorMessage;

	// remember user
	// TODO: actually use this
	bool _remember = false;

	// logging in state
	_LoginPhase _phase = _LoginPhase.none;

	final _usernameController = TextEditingController();
	final _passwordController = TextEditingController();

	Widget makeChildren(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Log In'),
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
						const SizedBox(height: 16),
						Row(
							mainAxisAlignment: MainAxisAlignment.start,
							children: <Widget>[
								// the login will break if checkbox is clicked during login phase
								// TODO: find a better way to do this
								AbsorbPointer(
									child: Checkbox(
										value: _remember,
										onChanged: (bool? val) {
											setState(() {
												// The checkbox is not tristate, so val is never null
												_remember = val!;
											});
										},
									),
									absorbing: _phase != _LoginPhase.none
								),
								const Text('Keep me logged in'),
							],
						),
						const SizedBox(height: 64),
						if (_phase != _LoginPhase.loading) Visibility(
							child: Text(
								_errorMessage ?? '',
								style: const TextStyle(color: Colors.red),
							),
							maintainSize: true,
							maintainAnimation: true,
							maintainState: true,
							visible: _errorMessage != null,
						),
						if (_phase == _LoginPhase.loading) const LinearProgressIndicator(
						),
						const SizedBox(height: 8),
						ElevatedButton(
							child: const Padding(
								padding: EdgeInsets.symmetric(horizontal: 32),
								child: Text('Log In'),
							),
							onPressed: () {
								setState(() {
									if (_phase == _LoginPhase.none) {
										_phase = _LoginPhase.login;
									}
								});
							},
						),
						TextButton(
							onPressed: () {},
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
			return FutureBuilder<User?>(
				future: Provider.of<UserModel>(context, listen: false).login(_usernameController.text, _passwordController.text),
				builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
					if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
						_phase = _LoginPhase.none;
						_errorMessage = null;
						WidgetsBinding.instance!.addPostFrameCallback((_) => Navigator.restorablePushReplacementNamed(context, Home.route));
						return makeChildren(context);
					} else if (snapshot.hasError) {
						// Not using set state, because we are already in a rebuild
						_phase = _LoginPhase.none;
						if (snapshot.error is ConnectionException) {
							_errorMessage = 'Unable to connect to server';
						} else if (snapshot.error is LoginException) {
							_errorMessage = 'Incorrect username or password';
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

class CreateAccount extends StatefulWidget {
	const CreateAccount({Key? key}) : super(key: key);

	static const route = '/login/create';

	@override
	_LoginState createState() => _LoginState();
}

class _CreateAccountState extends State<CreateAccount> {
	final _usernameController = TextEditingController();
	final _passwordController = TextEditingController();

	@override
	void dispose() {
		_usernameController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Create Account'),
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
						const SizedBox(height: 16),
						Row(
							mainAxisAlignment: MainAxisAlignment.start,
							children: <Widget>[
								// the login will break if checkbox is clicked during login phase
								// TODO: find a better way to do this
								AbsorbPointer(
									child: Checkbox(
										value: _remember,
										onChanged: (bool? val) {
											setState(() {
												// The checkbox is not tristate, so val is never null
												_remember = val!;
											});
										},
									),
									absorbing: _phase != _LoginPhase.none
								),
								const Text('Keep me logged in'),
							],
						),
						const SizedBox(height: 64),
						if (_phase != _LoginPhase.loading) Visibility(
							child: Text(
								_errorMessage ?? '',
								style: const TextStyle(color: Colors.red),
							),
							maintainSize: true,
							maintainAnimation: true,
							maintainState: true,
							visible: _errorMessage != null,
						),
						if (_phase == _LoginPhase.loading) const LinearProgressIndicator(
						),
						const SizedBox(height: 8),
						ElevatedButton(
							child: const Padding(
								padding: EdgeInsets.symmetric(horizontal: 32),
								child: Text('Log In'),
							),
							onPressed: () {
								setState(() {
									if (_phase == _LoginPhase.none) {
										_phase = _LoginPhase.login;
									}
								});
							},
						),
						TextButton(
							onPressed: () {},
							child: const Text('Create Account'),
						),
					],
				),
			),
		);
	}
}
