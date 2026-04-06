import 'dart:convert';

import 'package:http/http.dart' as http;

class WorkshopApiService {
  static final Uri _eventsUri = Uri.parse(
    'https://69d2abd65043d95be9721706.mockapi.io/events',
  );

  Future<List<Map<String, dynamic>>> fetchMachineEvents() async {
    final response = await http.get(_eventsUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load machine events');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded.map((item) => item as Map<String, dynamic>).toList();
  }
}
