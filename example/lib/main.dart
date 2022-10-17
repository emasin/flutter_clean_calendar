  import 'package:finan_ledger/screens/create_new_task_page.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
  import 'package:google_mobile_ads/google_mobile_ads.dart';
  import 'dart:io';
  import 'dart:convert';
  import 'package:settings_ui/settings_ui.dart';
  import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
  import 'package:intl/intl.dart';
  import 'package:hive_flutter/hive_flutter.dart';
  import 'package:flutter_localizations/flutter_localizations.dart';
  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();
    await Hive.initFlutter();// var box =
    await Hive.openBox('myBox');

    runApp(MyApp());}

  class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Clean Calendar Demo',
        home: CalendarScreen(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ko', 'KR'),
        ],
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
    DateTime _selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day );


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
    late Box _box;

    late Map<DateTime, List<CleanCalendarEvent>> _events = {

    };

    void loadData() {
      var a = _box?.keys;
      if(a != null) {
        for(final d in a){
          // _events[DateTime.parse(d)] = [];
          List<CleanCalendarEvent> c = [];
          for(final e in _box?.get(d)){


            c.add(CleanCalendarEvent.fromJson(e));

          }
          _events[DateTime.parse(d)] = c;

        }
      }


      for(final el in _events.keys){
        print(el);
        int tot = 0;
        //heatMapDatasets[el] = _events[el]?.map((v2){ return tot += v2.money;}) as int;
        for(final e in _events[el]!) {
          tot += e.money;
        }

        heatMapDatasets[el] = tot;


      }
      this.setState(() {
        _selectedEvents  = _events[_selectedDate];
      });


    }

    @override
    void initState() {
      super.initState();
      future = Future.value(0);
      _box = Hive.box('myBox');

      loadData();

      // Force selection of today on first load, so that the list of today's events gets shown.
      _handleNewDate(DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));





    }
    int _selectedIndex = 0;

    void setSelectedIndex(int s) {
      setState(() {
        this._selectedIndex = s;
      });
    }

    Map<DateTime, int> heatMapDatasets = {};


    List<CleanCalendarEvent>? _selectedEvents;

    Future<int>? future;



    Widget _buildEventList() {
      return _selectedEvents != null ? Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int index) {
            final CleanCalendarEvent event = _selectedEvents![index];
            final String start =
            DateFormat('HH:mm').format(DateTime.now()).toString();
            final String end =
            DateFormat('HH:mm').format(DateTime.now()).toString();
            return ListTile(
              contentPadding:
              EdgeInsets.only(left: 2.0, right: 8.0, top: 2.0, bottom: 2.0),
              leading: Container(
                width: 10.0,
                color: event.color,
              ),
              title: Text(event.mainCategory),
              subtitle:
              Text('${event.mainType} | ${event.payType}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(event.money.toString())],
              ),
              onTap: () {},
            );
          },
          itemCount: _selectedEvents?.length,
        ),
      ) : Container();
    }



    @override
    Widget build(BuildContext context) {
      //_selectedEvents  = _events[_selectedDate];


      double height = MediaQuery.of(context).size.height;
      //print(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day ));



      return FutureBuilder(future: future, builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        print('FutureBuilder');
        return Scaffold(
          appBar:AppBar(
            actions: [
              GestureDetector(onTap:()=>{this.setSelectedIndex(0)},child:Icon(Icons.calendar_month,color:_selectedIndex == 0 ? Colors.cyanAccent:Colors.white)),
              SizedBox(width:10),
              GestureDetector(onTap:()=>{this.setSelectedIndex(1)},child:Icon(Icons.area_chart,color:_selectedIndex == 1 ? Colors.cyanAccent:Colors.white)),
              SizedBox(width:10),
              GestureDetector(onTap:()=>{this.setSelectedIndex(2)},child:Icon(Icons.person,color:_selectedIndex == 2 ? Colors.cyanAccent:Colors.white)),
              SizedBox(width:15)
            ],
          ),
          body: SafeArea(

              child: _selectedIndex == 0 ? Stack(alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Column(children: [Calendar(
                      eventListBuilder: (BuildContext context, List<CleanCalendarEvent> events)=>Container(),
                      onDateSelected:_handleNewDate,
                      startOnMonday: false,
                      weekDays: [ '일', '월', '화', '수', '목', '금', '토'],
                      events: _events,
                      isExpandable: true,
                      eventDoneColor: Colors.green,
                      selectedColor: Colors.pink,
                      todayColor: Colors.blue,
                      eventColor: Colors.grey,
                      hideTodayIcon:true,
                      locale: 'ko_KR',
                      todayButtonText: '오늘',
                      isExpanded: false,
                      expandableDateFormat: 'yyyy년 MM월 dd일 , EEEE',
                      dayOfWeekStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
                    ),
                      _buildEventList(),
                    ],)
                    ,

                    new Positioned(
                        bottom: 80.0,
                        right: 10.0,

                        child: FloatingActionButton(
                          key: UniqueKey() ,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateNewTaskPage(showSnackBar),

                              ),
                            );
                          },
                          child: Icon(Icons.add),
                          mini: true,
                          elevation: 10,


                        )
                    ),



                    _getAdWidget()
                  ]): _selectedIndex == 1 ?
              Container(child: Column(
                children: [
                  Card(
                    margin: const EdgeInsets.all(5),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(5),

                      // HeatMapCalendar
                      child: HeatMapCalendar(
                        onClick:(d){
                          print('+++++++++ $d');
                          print('--------- $_selectedDate');
                          setState(() {

                            _selectedDate = d;
                            //print(_selectedEvents);
                          });
                        },
                        flexible: true,
                        datasets: heatMapDatasets,
                        colorMode:
                        isOpacityMode ? ColorMode.opacity : ColorMode.color,
                        colorsets: const {
                          1: Colors.red,
                          3: Colors.orange,
                          5: Colors.yellow,
                          7: Colors.green,
                          9: Colors.blue,
                          11: Colors.indigo,
                          13: Colors.purple,
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: _selectedEvents != null && _selectedEvents!.isNotEmpty
                        ? ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (BuildContext context, int index) {
                        final CleanCalendarEvent event = _selectedEvents![index];
                        final String start =
                            event.startTime;

                        return Container(
                          height: 50.0,
                          child: InkWell(
                            onTap: () {

                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      color: event.color,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(event.payType,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 25,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(event.mainCategory,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),

                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(event.subCategory,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),

                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(NumberFormat.currency(locale: "ko_KR", symbol: "￦").format(event.money).toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),

                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: _selectedEvents?.length,
                    )
                        : Container(child:Text('none')),
                  )

                ],)) :
              Container(child:SettingsList(
                sections: [
                  SettingsSection(
                    title: Text('개인 설정'),
                    tiles: <SettingsTile>[

                      SettingsTile.navigation(
                        leading: Icon(Icons.person),
                        title: Text('프로필'),
                        value: Text('Scott'),
                      ),
                      SettingsTile.switchTile(
                        onToggle: (value) {},
                        initialValue: false,
                        leading: Icon(Icons.dark_mode),
                        title: Text('Dark Mode'),
                      ),
                      SettingsTile.switchTile(
                        onToggle: (value) {},
                        initialValue: true,
                        leading: Icon(Icons.backup_sharp),
                        title: Text('자동 백업'),
                      ),
                      SettingsTile.switchTile(
                        onToggle: (value) {

                          Hive.box('myBox').clear();
                          this.setState(() {
                            _events.clear();
                            _events = {};
                          });
                        },
                        initialValue: true,
                        leading: Icon(Icons.backup_sharp),
                        title: Text('초기화'),
                      ),
                    ],
                  ),
                ],
              ),)
          ) ,

        );
      },) ;
    }

    Widget _textField(final String hint, final TextEditingController controller) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, right: 20, top: 8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffe7e7e7), width: 1.0)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF20bca4), width: 1.0)),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            isDense: true,
          ),
        ),
      );
    }

    final TextEditingController dateController = TextEditingController();
    final TextEditingController heatLevelController = TextEditingController();

    bool isOpacityMode = true;


    @override
    void dispose() {
      super.dispose();
      _anchoredAdaptiveAd?.dispose();
      dateController.dispose();
      heatLevelController.dispose();
    }


    void showSnackBar(String label) {
      loadData();
      future = Future.value(1);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(label),
        ),
      );
    }

    void _handleNewDate(date) {
      this.setState(() {
        _selectedEvents  = _events[date];
      });
      print('Date selected: $date');
    }
  }
