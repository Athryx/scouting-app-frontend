import 'package:flutter/material.dart';

class Home extends StatefulWidget {
	const Home({Key? key}) : super(key: key);

	static const route = '/home';

	@override
	_HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Home'),
			),
			drawer: Drawer(
			),
			body: const Center(
				child: Text('Hello, World!'),
			),
		);
	}
}
