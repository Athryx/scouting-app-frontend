import 'dart:convert' as convert;
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:scout/consts.dart';

class ConnectionException implements Exception {
	final String message;

	ConnectionException(this.message);

	@override
	String toString() => 'ConnectionException: ' + message;
}

Future<Map<String, dynamic>> sendQuery(String query) async {
	// querys need paranthasees escaped when sent to graphql server
	// FIXME: this will replace even when backslash is already present
	query = query.replaceAll('"', '\\"');

	var url = Uri.parse(serverUrl);

	http.Response response;
	try {
		response = await http.post(
			url, 
			headers: {'content-type': 'application/json'},
			body: '{"operationName":null,"variables":{},"query":"$query"}',
		);
	} catch(e) {
		if (e is SocketException || e is TimeoutException) {
			throw ConnectionException('could not reach server: $serverUrl');
		} else {
			rethrow;
		}
	}

	if (response.statusCode == 200) {
		return convert.jsonDecode(response.body);
	} else {
		throw ConnectionException('could not reach server: $serverUrl');
	}
}
