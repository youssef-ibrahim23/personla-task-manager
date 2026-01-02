class Weather {
  final Location location;
  final CurrentWeather current;

  Weather({required this.location, required this.current});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: Location.fromJson(json['location']),
      current: CurrentWeather.fromJson(json['current']),
    );
  }
}

class Location {
  final String name;
  final String region;
  final String country;
  final String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      localtime: json['localtime'],
    );
  }
}

class CurrentWeather {
  final double tempC;
  final WeatherCondition condition;
  final double windKph;
  final int humidity;
  final double feelslikeC;

  CurrentWeather({
    required this.tempC,
    required this.condition,
    required this.windKph,
    required this.humidity,
    required this.feelslikeC,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      tempC: json['temp_c'],
      condition: WeatherCondition.fromJson(json['condition']),
      windKph: json['wind_kph'],
      humidity: json['humidity'],
      feelslikeC: json['feelslike_c'],
    );
  }
}

class WeatherCondition {
  final String text;
  final String icon;

  WeatherCondition({required this.text, required this.icon});

  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      text: json['text'],
      icon: json['icon'],
    );
  }
}