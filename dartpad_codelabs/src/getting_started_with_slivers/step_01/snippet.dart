import 'package:flutter/material.dart';

void main() {
  runApp(HorizonsApp());
}

class HorizonsApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // This is the theme of your application.
      theme: ThemeData.dark(),
      // Scrolling in Flutter behaves differently depending on the ScrollBehavior.
      // By default, ScrollBehavior changes depending on the current platform.
      // For the purposes of this scrolling workshop, we're using a custom
      // ScrollBehavior so that the experience is the same for everyone -
      // regardless of the platform they are using.
      scrollBehavior: const ConstantScrollBehavior(),
      title: 'Horizons Weather',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Horizons'),
          backgroundColor: Colors.teal[800],
        ),
        body: WeeklyForecastList(),
      )
    );
  }
}

class WeeklyForecastList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateTime currentDate = DateTime.now();
    final TextTheme textTheme = Theme.of(context).textTheme;
    final List<DailyForecast> forecasts = Server.getDailyForecastList();
    
    return SingleChildScrollView(
      child: Column(
        children: forecasts.map((DailyForecast forecast) {
          return Card(
            child: ListTile(
              leading: Text(
                forecast.getDate(currentDate.day).toString(),
                style: textTheme.headline4,
              ),
              title: Text(
                forecast.getWeekday(currentDate.weekday),
                style: textTheme.headline5,
              ),
              subtitle: Text(forecast.description),
              trailing: Text(
                '${forecast.highTemp} H / ${forecast.lowTemp} L',
                style: textTheme.subtitle2,
              ),
            ),
          );
        }).toList(),
      )  
    );
  }
}

// -----------------------------------------------------------------------------
// Below this line are helper classes and data.

const String baseAssetURL = 'https://dartpad-workshops-io2021.web.app/getting_started_with_slivers/';

const Map<int, DailyForecast> _kDummyData = {
  0 : DailyForecast(
    id: 0,
    imageId: 'assets/day_0.jpeg',
    highTemp: 73,
    lowTemp: 52,
    description: 'Partly cloudy in the morning, with sun appearing in the afternoon.',
  ),
  1 : DailyForecast(
    id: 1,
    imageId: 'assets/day_1.jpeg',
    highTemp: 70,
    lowTemp: 50,
    description: 'Partly sunny.',
  ),
  2 : DailyForecast(
    id: 2,
    imageId: 'assets/day_2.jpeg',
    highTemp: 71,
    lowTemp: 55,
    description: 'Party cloudy.',
  ),
  3 : DailyForecast(
    id: 3,
    imageId: 'assets/day_3.jpeg',
    highTemp: 74,
    lowTemp: 60,
    description: 'Thunderstorms in the evening.',
  ),
  4 : DailyForecast(
    id: 4,
    imageId: 'assets/day_4.jpeg',
    highTemp: 67,
    lowTemp: 60,
    description: 'Severe thunderstorm warning.',
  ),
  5 : DailyForecast(
    id: 5,
    imageId: 'assets/day_5.jpeg',
    highTemp: 73,
    lowTemp: 57,
    description: 'Cloudy with showers in the morning.',
  ),
  6 : DailyForecast(
    id: 6,
    imageId: 'assets/day_6.jpeg',
    highTemp: 75,
    lowTemp: 58,
    description: 'Sun throughout the day.',
  ),
};

class Server {
  static List<DailyForecast> getDailyForecastList() => _kDummyData.values.toList();

  static DailyForecast getDailyForecastByID(int id) {
    assert(id >= 0 && id <= 6);
    return _kDummyData[id]!;
  }
}

class DailyForecast {
  const DailyForecast({
    required this.id,
    required this.imageId,
    required this.highTemp,
    required this.lowTemp,
    required this.description,
  });
  final int id;
  final String imageId;
  final int highTemp;
  final int lowTemp;
  final String description;

  static const List<String> _weekdays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String getWeekday(int today) {
    final int offset = today + id;
    final int day = offset >= 7 ? offset - 7 : offset;
    return _weekdays[day];
  }

  int getDate(int today) => today + id;
}

class ConstantScrollBehavior extends ScrollBehavior {
  const ConstantScrollBehavior();

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) => child;

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;

  @override
  TargetPlatform getPlatform(BuildContext context) => TargetPlatform.macOS;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}
