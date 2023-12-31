import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../components/line_chart.dart';
import '../model/chartPoints.dart';
import 'package:collection/collection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription subscription;
  bool isDeviceConnected=false;
  bool isAlertSet = false;
  bool isRefresh = false;

  var lat, lon, weather, temp, temperature, min, max;
  String? country, desc, city, today; // main;
  int? hour;
  List<dynamic> forcast = [];
  List<double> chartValue = [];
  var apiKey = 'f094631489a586125760c6b70957ee7c';
  bool flag = false;
  bool anotherFlag = false;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  getData() async {
    Position position = await _determinePosition();
    lat = position.latitude;
    lon = position.longitude;

    final url1 =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';
    final uri1 = Uri.parse(url1);
    final response1 = await http.get(uri1);
    final body1 = response1.body;
    final jsonBody = jsonDecode(body1);

    final url2 =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey';
    final uri2 = Uri.parse(url2);
    final response2 = await http.get(uri2);
    final body2 = response2.body;
    final jsonBody2 = jsonDecode(body2);

    setState(() {
      temperature = jsonBody['main']['temp'] - 273.15;
      min = jsonBody['main']['temp_min'] - 273.15;
      max = jsonBody['main']['temp_max'] - 273.15;
      country = jsonBody['sys']['country'];
      weather = jsonBody['weather'];
      temp = weather?[0];
      desc = temp['description'];
      city = jsonBody['name'];
      forcast = jsonBody2['list'];
      getPointsData();
    });

    var now = DateTime.now();
    var formatter = DateFormat.yMMMMd('en_US');
    today = formatter.format(now);
    hour = now.hour;

    flag = true;
  }

  @override
  void initState() {
    super.initState();
    getConnectivity();
    if(isDeviceConnected){
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            const Color(0xff1F1D36), //Color(0xff040a3f),//Color(0xff1F1D36),
        body: flag
            ? ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Weather forecast',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Image.asset(
                              'assets/images/menu.png'), //SvgPicture.asset('assets/svg/ic_menu2.svg'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY: 5,
                        ),
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xff343058).withOpacity(0.3),
                                    const Color(0xff504b8e).withOpacity(0.3),
                                  ]),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
                                horizontal:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              // vertical: 20.0, horizontal: 30.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Today',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      ),
                                      Text(
                                        today!,
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Center(
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${temperature.toInt()}॰',
                                                style: TextStyle(
                                                  height: 0.8,
                                                  fontFamily: 'Nunito_Medium',
                                                  fontSize: 64,
                                                  color: Colors.amber.shade700,
                                                ),
                                              ),
                                              Text(
                                                'H:${max.toInt()}॰ L:${min.toInt()}॰',
                                                style: const TextStyle(
                                                  height: 1.2,
                                                  fontSize: 16,
                                                  fontFamily: 'Nunito_Light',
                                                  color: Color(0xffc4c4c4),
                                                ),
                                              ),
                                              Text(
                                                '$desc',
                                                style: const TextStyle(
                                                  height: 1,
                                                  fontSize: 18,
                                                  fontFamily: 'Nunito_Light',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: (4 <= hour! && hour! <= 18)
                                              ? setDayIcon(desc!)
                                              : setNightIcon(
                                                  desc!), //: Image.asset('assets/images/cloud.png'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Image.asset(
                                            'assets/images/marker-2.png'), //SvgPicture.asset('assets/svg/location-pin.svg'),
                                      ),
                                      Text(
                                        '$city, $country',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Nunito_Light',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 15),
                    child: Text(
                      'Next 5 days: ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Nunito_Regular',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SizedBox(
                      height: 160,
                      width: 80,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: forcast.length,
                          itemBuilder: (context, index) {
                            final data = forcast[index];
                            final dateTime = data['dt_txt'];
                            final temperature = data['main']['temp'] - 273.15;
                            final weather = data['weather'];
                            final temp = weather?[0];
                            final desc = temp['description'];

                            return ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 5,
                                  sigmaY: 5,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xff343058)
                                                .withOpacity(0.3),
                                            const Color(0xff504b8e)
                                                .withOpacity(0.3),
                                          ]),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          setTime(dateTime),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            height: 1.5,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 70,
                                            width: 70,
                                            child: (4 <=
                                                        int.parse(get24Time(
                                                            dateTime)) &&
                                                    int.parse(get24Time(
                                                            dateTime)) <=
                                                        18)
                                                ? setDayIcon(desc!)
                                                : setNightIcon(desc!),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${temperature.toInt()}॰',
                                          style: TextStyle(
                                            color: Colors.amber.shade700,
                                            height: 1,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          child: Text(
                                            setDate(dateTime),
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              height: 1,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 20
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'Chances of rain/snow: ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Nunito_Regular',
                      ),
                    ),
                  ),
                  chart(),
                ],
              )
            : const Skeleton(),
      ),
    );
  }

  Widget chart() {
    return LineChartWidget(chartPoints);
  }

  getPointsData() {
    if(isRefresh){
      return;
    }
    for (int i = 0; i < forcast.length; i++) {
      final data = forcast[i];
      final weather = data['weather'];
      final temp = weather?[0];
      final desc = temp['description'];
      final dateTime = data['dt_txt'];
      int time = int.parse(get24Time(dateTime));
      if (time == 12) {
        if (desc == 'light rain' || desc == 'light snow') {
          chartValue.add(2.0);
        } else if (desc == 'moderate rain' || desc == 'moderate snow') {
          chartValue.add(3.0);
        } else if (desc == 'heavy intensity rain' ||
            desc == 'heavy intensity snow') {
          chartValue.add(4.0);
        } else {
          chartValue.add(1.0);
        }
      }
    }
    isRefresh = true;
  }

  setDayIcon(String str) {
    switch (str) {
      case 'light rain':
        return Image.asset('assets/images/light-rain-day.png');
      case 'moderate rain':
        return Image.asset('assets/images/heavy-rain-2.png');
      case 'heavy intensity rain':
        return Image.asset('assets/images/heavy-rain.png');
      case 'few clouds':
        return Image.asset('assets/images/few-clouds-day.png');
      case 'overcast clouds':
        return Image.asset('assets/images/overcast-cloud-with-sun.png');
      case 'broken clouds':
        return Image.asset('assets/images/overcast-clouds.png');
      case 'scattered clouds':
        return Image.asset('assets/images/overcast-clouds.png');
      case 'light snow':
        return Image.asset('assets/images/light-snow.webp');
      default:
        return Image.asset('assets/images/sun-with-wind.png');
    }
  }

  setNightIcon(String str) {
    switch (str) {
      case 'light rain':
        return Image.asset('assets/images/rain-night.png');
      case 'moderate rain':
        return Image.asset('assets/images/rain-night.png');
      case 'heavy intensity rain':
        return Image.asset('assets/images/rain-night.png');
      case 'few clouds':
        return Image.asset('assets/images/few-clouds-night.png');
      case 'overcast clouds':
        return Image.asset('assets/images/overcast-cloud-with-moon.png');
      case 'broken clouds':
        return Image.asset('assets/images/overcast-cloud-with-moon.png');
      case 'scattered clouds':
        return Image.asset('assets/images/overcast-cloud-with-moon.png');
      case 'light snow':
        return Image.asset('assets/images/snow-cloud-night.png');
      default:
        return Image.asset('assets/images/moon-with-wind.png');
    }
  }

  setTime(String dt) {
    String dateT = dt;
    String timeString = dateT.substring(10).trim();
    DateTime dateTime = DateFormat('HH:mm:ss').parse(timeString);
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }

  setDate(String dt) {
    String date = dt;
    var formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
    String finalDate = DateFormat.MMMEd().format(formattedDate);
    return finalDate;
  }

  get24Time(String dt) {
    String date = dt;
    String timeString = date.substring(10).trim();
    DateTime dateTime = DateFormat('HH:mm:ss').parse(timeString);
    String formattedTime = DateFormat('HH').format(dateTime);
    return formattedTime;
  }

  List<ChartPoints> get chartPoints {
    return chartValue
        .mapIndexed(
            ((index, element) => ChartPoints(x: index.toDouble(), y: element)))
        .toList();
  }

  getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && isAlertSet == false) {
        setState(() => isAlertSet = true);
        if (context.mounted) showDialogBox(context);
      }else{
        getData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  showDialogBox(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
    return StatefulBuilder(builder: ((context, setState)
    {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: const Color(0xff343058),
        title:const Text(
          'No Internet',
          style: TextStyle(fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        content:const Text(
          'Please check your internet connectivity.',
          style: TextStyle(fontSize: 14, color: Colors.red),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text('Ok', style: TextStyle(color: Colors.black),),
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                isAlertSet = false;
                // if(isDeviceConnected) {
                //   print('setState => getData');
                //   getData();
                // }
              });
              isDeviceConnected =
              await InternetConnectionChecker().hasConnection;
              if (!isDeviceConnected) {
                if (context.mounted) showDialogBox(context);
                setState(() => isAlertSet = true);
              }
            },
          ),
        ],
      );
    }));
    });
  }


}

class Skeleton extends StatelessWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 160,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
