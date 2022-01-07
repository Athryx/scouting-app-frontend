import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
	const Settings({Key? key}) : super(key: key);

	static const route = '/settings';

	@override
	_SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Settings'),
			),
		);
	}
}
