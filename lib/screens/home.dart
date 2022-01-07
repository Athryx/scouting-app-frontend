import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scout/models/user.dart';
import 'screens.dart';

class Home extends StatefulWidget {
	const Home({Key? key}) : super(key: key);

	static const route = '/home';

	@override
	_HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
	static const double _spacing = 32;
	static const double _buttonWidth = 128;

	@override
	Widget build(BuildContext context) {
		// TODO: this is temporary
		return Scaffold(
			appBar: AppBar(
				title: const Text('Home'),
			),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						ElevatedButton(
							child: const SizedBox(
								width: _buttonWidth,
								child: Center(
									child: Text('Forms'),
								),
							),
							onPressed: () {}
						),
						const SizedBox(height: _spacing),
						ElevatedButton(
							child: const SizedBox(
								width: _buttonWidth,
								child: Center(
									child: Text('Teams'),
								),
							),
							onPressed: () => Navigator.pushNamed(context, Teams.route),
						),
						const SizedBox(height: _spacing),
						ElevatedButton(
							child: const SizedBox(
								width: _buttonWidth,
								child: Center(
									child: Text('Profile'),
								),
							),
							onPressed: () => Navigator.pushNamed(context, Profile.route),
						),
						const SizedBox(height: _spacing),
						ElevatedButton(
							child: const SizedBox(
								width: _buttonWidth,
								child: Center(
									child: Text('Settings'),
								),
							),
							onPressed: () => Navigator.pushNamed(context, Settings.route),
						),
						const SizedBox(height: _spacing),
						ElevatedButton(
							child: const SizedBox(
								width: _buttonWidth,
								child: Center(
									child: Text('Logout'),
								),
							),
							onPressed: () {
								Provider.of<UserModel>(context, listen: false).logout();
								Navigator.restorablePushReplacementNamed(context, Login.route);
							},
						),
					],
				),
			),
		);
	}
}
