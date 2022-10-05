import 'package:finan_ledger/screens/create_new_task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clean Calendar Demo',
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {


  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  /// Load another ad, disposing of the current ad if there is one.
  Future<void> _loadAd() async {
    await _anchoredAdaptiveAd?.dispose();
    setState(() {
      _anchoredAdaptiveAd = null;
      _isLoaded = false;
    });

    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    String adUnitId =  Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';



    _anchoredAdaptiveAd = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }


  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _anchoredAdaptiveAd != null &&
            _isLoaded) {
          return Container(
            color: Colors.green,
            width: _anchoredAdaptiveAd!.size.width.toDouble(),
            height: _anchoredAdaptiveAd!.size.height.toDouble(),
            child: AdWidget(ad: _anchoredAdaptiveAd!),
          );
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container();
      },
    );
  }


  final Map<DateTime, List<CleanCalendarEvent>> _events = {

    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 3):
        [
      CleanCalendarEvent('수입','현급','용돈',90000,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.blue),
          CleanCalendarEvent('지출','현급','식비',12000,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '점심'),
          CleanCalendarEvent('지출','카드','교통비',2800,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '출근'),
          CleanCalendarEvent('지출','카드','교통비',2800,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '퇴근'),
    ],
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 2):
    [
      CleanCalendarEvent('수입','현급','용돈',90000,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.blue),
      CleanCalendarEvent('지출','현급','식비',12000,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '점심'),
      CleanCalendarEvent('지출','카드','교통비',2800,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '출근'),
      CleanCalendarEvent('지출','카드','교통비',2800,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '퇴근'),
      CleanCalendarEvent('수입','현급','용돈',90000,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.blue),
      CleanCalendarEvent('지출','현급','식비',12000,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '점심'),
      CleanCalendarEvent('지출','카드','교통비',2800,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '출근'),
      CleanCalendarEvent('지출','카드','교통비',2800,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '퇴근'),
      CleanCalendarEvent('지출','현급','식비',12000,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '점심'),
      CleanCalendarEvent('지출','카드','교통비',2800,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '출근'),
      CleanCalendarEvent('지출','카드','교통비',2800,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '퇴근'),
    ],
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day ):
    [
      CleanCalendarEvent('지출','카드','식비',4200,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '맥모닝'),
      CleanCalendarEvent('지출','현급','식비',9800,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '점심'),
      CleanCalendarEvent('지출','카드','교통비',2800,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '출근'),
      CleanCalendarEvent('지출','카드','교통비',2800,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.red,subCategory: '퇴근'),
    ],
  };

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(

        child: Stack(alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Calendar(
                startOnMonday: true,
                weekDays: ['일', '월', '화', '수', '목', '금', '토'],
                events: _events,
                isExpandable: true,
                eventDoneColor: Colors.green,
                selectedColor: Colors.pink,
                todayColor: Colors.blue,
                eventColor: Colors.grey,
                hideTodayIcon:true,
                locale: 'ko_KR',
                todayButtonText: 'Heute',
                isExpanded: true,
                expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                dayOfWeekStyle: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
              ),

              new Positioned(
                  bottom: 80.0,
                  right: 10.0,

                  child: FloatingActionButton(
                    key: UniqueKey() ,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateNewTaskPage(),
                        ),
                      );
                    },
                    child: Icon(Icons.add),
                    mini: true,
                    elevation: 10,


                  )
              ),


              _getAdWidget()
            ])
      ),

    );
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }
}
