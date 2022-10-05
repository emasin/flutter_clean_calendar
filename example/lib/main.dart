import 'package:finan_ledger/screens/create_new_task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';

void main() => runApp(MyApp());

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
  final Map<DateTime, List<CleanCalendarEvent>> _events = {

    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3):
        [
      CleanCalendarEvent('수입','현급','용돈',90000,DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),color: Colors.blue),
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
        child: Calendar(
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
      ),
      floatingActionButton: new  FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNewTaskPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        mini: true


      ),
    );
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }
}
