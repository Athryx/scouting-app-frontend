import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';
import 'models/models.dart';

void main() async {
	runApp(
		MultiProvider(
			providers: [
				ChangeNotifierProvider(create: (_) => UserModel()),
			],
			child: const MyApp()
		)
	);
}

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'FRC Scouting App',
			theme: ThemeData(
				primarySwatch: Colors.blue,

				//inputDecorationTheme: const InputDecorationTheme(
				//),
			),
			initialRoute: Login.route,
			routes: {
				Login.route: (_) => const Login(mode: LoginMode.login),
				Login.createRoute: (_) => const Login(mode: LoginMode.create),
				Home.route: (_) => const Home(),
				Teams.route: (_) => const Teams(),
				Profile.route: (_) => const Profile(),
				Settings.route: (_) => const Settings(),
			},
		);
	}
}
