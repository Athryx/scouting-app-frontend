import 'package:flutter/material.dart';

class Teams extends StatefulWidget {
	const Teams({Key? key}) : super(key: key);

	static const route = '/teams';

	@override
	_TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Teams'),
			),
		);
	}
}
