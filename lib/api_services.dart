import 'package:weather_app/models/weather_json.dart';
import 'package:http/http.dart' as http;

const APIKEY = "8eefc206a91d412f88058f96665fb9f8";

class APIService {
  Future<Weather> getWeather(String location) async {
    final response = await http.get(Uri.parse(
        "http://api.weatherstack.com/current?access_key=$APIKEY&query=$location"));
    if (response.statusCode == 200) {
      Weather w = weatherFromJson(response.body);
      return w;
    } else {
      throw Exception("Failed to load weather");
    }
  }
}
