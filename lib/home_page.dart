import 'package:flutter/material.dart';
import 'package:weather_app/api_services.dart';
import 'package:weather_app/models/weather_json.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController cLocation = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String locationName = "";

  @override
  void initState() {
    super.initState();
    cLocation = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Weather App"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Form(
              key: _formkey,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: cLocation,
                  decoration: InputDecoration(
                      hintText: "Enter The City Name",
                      labelText: "City Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: InkWell(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                locationName = cLocation.text;
                              });
                            }
                          },
                          child: const Icon(Icons.search))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter The City Name";
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: FutureBuilder<Weather>(
                future: APIService().getWeather(locationName),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text(
                          snapshot.data!.location.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          snapshot.data!.location.country,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${snapshot.data!.current.temperature}°C",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.network(
                          snapshot.data!.current.weatherIcons[0],
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          snapshot.data!.current.weatherDescriptions[0],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
