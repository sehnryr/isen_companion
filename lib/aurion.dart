import 'package:isen_aurion_client/isen_aurion_client.dart';

class Aurion {
  const Aurion();

  static String _serviceUrl = "";

  static late IsenAurionClient client;

  static void init(String serviceUrl) {
    _serviceUrl = serviceUrl;
    client = IsenAurionClient(serviceUrl: _serviceUrl);
  }
}
