import 'package:flutter/material.dart';
import 'package:finan_ledger/theme/colors/light_colors.dart';
import 'package:finan_ledger/widgets/top_container.dart';
import 'package:finan_ledger/widgets/back_button.dart';
import 'package:finan_ledger/widgets/my_text_field.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';



class CreateNewTaskPage extends StatefulWidget {
  const CreateNewTaskPage();


  @override
  _CreateNewTaskPageState createState() => _CreateNewTaskPageState();
}



class _CreateNewTaskPageState extends State<CreateNewTaskPage> {

  late Box _box;


  @override
  void initState() {
    super.initState();
    _box = Hive.box('myBox');
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              width: width,
              height: 300,
              child: Column(
                children: <Widget>[
                  MyBackButton(),
                  SizedBox(
                    height: 30,
                  ),

                  SizedBox(height: 20),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MyTextField(label: '수입/지출',defaultText: '지출',),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: MyTextField(
                              label: '날짜',
                              icon: downwardIcon,
                              keyboardType:3,
                              defaultText: '${DateFormat('yyyy-MM-dd').format(DateTime.now())}',


                            ),
                          ),
              CircleAvatar(
                radius: 25.0,
                backgroundColor: LightColors.kGreen,
                child: Icon(
                  Icons.calendar_today,
                  size: 20.0,
                  color: Colors.white,
                ),
              ),
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[



                  MyTextField(
                    label: '현금/은행/카드',
                    minLines: 1,
                    maxLines: 1,
                    defaultText: '카드',
                  ),
                  SizedBox(height: 20),
                  MyTextField(
                    label: '분류',
                    minLines: 1,
                    maxLines: 1,
                    defaultText: '식비',
                  ),
                  SizedBox(height: 20),
                  MyTextField(
                    label: '금액',
                    minLines: 1,
                    maxLines: 1,
                    defaultText: '',
                    keyboardType:2
                  ),
                  SizedBox(height: 20),
                  MyTextField(
                    label: '상세 분류',
                    minLines: 1,
                    maxLines: 1,
                    defaultText: '맥모닝',
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '상세분류 선택',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          //direction: Axis.vertical,
                          alignment: WrapAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          runSpacing: 0,
                          //textDirection: TextDirection.rtl,
                          spacing: 10.0,
                          children: <Widget>[
                            Chip(
                              label: Text("식비"),
                              backgroundColor: LightColors.kRed,
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            Chip(
                              label: Text("교통비"),
                            ),
                            Chip(
                              label: Text("교육비"),
                            ),
                            Chip(
                              label: Text("공과금"),
                            ),
                            Chip(
                              label: Text("미용"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
            Container(
              height: 80,
              width: width,
              child: GestureDetector(
                onTap:(){
                  _box?.put('counter', {"name":1});
                },
                child:Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Text(
                      '저장하기',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    width: width - 40,
                    decoration: BoxDecoration(
                      color: LightColors.kBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ],
              ),)
            ),
          ],
        ),
      ),
    );
  }
}
