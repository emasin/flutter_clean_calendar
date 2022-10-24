import 'dart:convert';
import 'dart:math';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:finan_ledger/theme/colors/light_colors.dart';
import 'package:finan_ledger/widgets/top_container.dart';
import 'package:finan_ledger/widgets/back_button.dart';
import 'package:finan_ledger/widgets/my_text_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';

typedef LabelledValueChanged<T, U> = void Function(T label);

class CreateNewTaskPage extends StatefulWidget {
  const CreateNewTaskPage(this.onValueChanged);
  final LabelledValueChanged<String, dynamic> onValueChanged;

  @override
  _CreateNewTaskPageState createState() => _CreateNewTaskPageState();
}

class _CreateNewTaskPageState extends State<CreateNewTaskPage> with SingleTickerProviderStateMixin {
  late Box _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box('myBox');

    _payTypes = ["현금", "카드", "계좌"];
    _mainTyepe = ["지출", "수입"];

    _sharedRatio = _payTypes!.map((e) => 1.0).toList();
    shareList = {for (var u in _payTypes!) u: "0.00"};
    _shareControler = _payTypes!.map((e) => TextEditingController(text: shareList![e])).toList();

    _items = _list.toList();
    _selectedLanguages = [];
  }

  @override
  void dispose() {
    _selectedLanguages.clear();
    _itemEditor.clear();
    _payTypeEditor.clear();
    _amountEditor.clear();
    _dateEditor.clear();
    _mainTypeEditor.clear();

    super.dispose();
  }


  void printBox() {
    final cats = _box.values;
  }


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  TextEditingController _itemEditor = TextEditingController();
  TextEditingController _payTypeEditor = TextEditingController(text: '현금');
  TextEditingController _amountEditor = TextEditingController();
  TextEditingController _dateEditor = TextEditingController(text: DateTime.now().toString());
  TextEditingController _mainTypeEditor = TextEditingController(text: '지출');
  List<TextEditingController>? _shareControler;
  Map<String, String>? shareList;
  List<String>? _payTypes;
  List<String>? _mainTyepe;
  List<double>? _sharedRatio;
  final List<bool> _selectedMainType = <bool>[false, true];
  final List<Widget> mainTypeButtons = <Widget>[
    Text('수입'),
    Text('지출'),
  ];

  final List<bool> _selectedPayType = <bool>[true, false, false];
  final List<Widget> payTypeButtons = <Widget>[
    Text('현금'),
    Text('카드'),
    Text('계좌'),
  ];


  String _selectedValuesJson = 'Nothing to show';
  late List<Language> _selectedLanguages;


  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;

    final width2 = MediaQuery.of(context).size.width * 0.87 / max(1,2);
    final width3 = MediaQuery.of(context).size.width * 0.87 / max(1,3);


    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(width: double.infinity, child: Column(
              children:[
                Container(child: MyBackButton(),padding: const EdgeInsets.symmetric(horizontal: 16.0),),

                SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[

                        ToggleButtons(

                          direction: Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              // The button that is tapped is set to true, and the others to false.
                              for (int i = 0; i < _selectedMainType.length; i++) {
                                _selectedMainType[i] = i == index;
                              }
                              _mainTypeEditor.text = (mainTypeButtons[index] as Text).data!;
                              print(_mainTypeEditor.text);

                            });
                          },
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor: Colors.red[700],
                          selectedColor: Colors.white,
                          fillColor: Colors.red[200],
                          color: Colors.red[400],
                          constraints: BoxConstraints(maxWidth: width2, minWidth: width2, minHeight: 40.0, maxHeight: 40.0),
                          isSelected: _selectedMainType,
                          children: mainTypeButtons,
                        ),
                        /**SizedBox(height: 9),
                        SelectFormField(
                          // key: ValueKey<int>(count2),
                          autovalidate: false,
                          type: SelectFormFieldType.dropdown, // or can be dialog
                          controller: _mainTypeEditor,
                          icon: Icon(Icons.category),
                          hintText: '수입/지출 선택',
                          labelText: '입출',
                          items: _mainTyepe!
                              .map((e) => {
                            "value": e,
                            "label": e,
                          })
                              .map((e) => Map<String, dynamic>.from(e))
                              .toList(),

                          validator: (value) => value!.isEmpty ? "Required field *" : null,
                        ),**/
                        SizedBox(height: 9),
                        DateTimePicker(
                          controller: _dateEditor,
                          type: DateTimePickerType.date,
                          dateMask: 'yyyy년 MM월 dd일',
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),

                          dateLabelText: '날짜',
                          locale: Locale("ko","KR"),
                          validator: (value) => value!.isEmpty ? "Required field *" : null,
                        ),
                        SizedBox(height: 18),
                        /**SelectFormField(
                          icon: Icon(Icons.person_outline),
                          labelText: '자산구분',
                          controller: _payTypeEditor,
                          items: _payTypes!.map((e) => {
                            "value": e,
                            "label": e,
                          })
                              .map(
                                  (e) => Map<String, dynamic>.from(e)) // select form field items require <String,dynamic>
                              .toList(),
                          validator: (value) => value!.isEmpty ? "Required filed *" : null,
                        ),**/
                        ToggleButtons(

                          direction: Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              // The button that is tapped is set to true, and the others to false.
                              for (int i = 0; i < _selectedPayType.length; i++) {
                                _selectedPayType[i] = i == index;
                              }
                              _payTypeEditor.text = (payTypeButtons[index] as Text).data!;
                              print(_mainTypeEditor.text);

                            });
                          },
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor: Colors.red[700],
                          selectedColor: Colors.white,
                          fillColor: Colors.red[200],
                          color: Colors.red[400],
                          constraints: BoxConstraints(maxWidth: width3, minWidth: width3, minHeight: 40.0, maxHeight: 40.0),
                          isSelected: _selectedPayType,
                          children: payTypeButtons,
                        ),
                        SizedBox(height: 9),

                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: FlutterTagging<Language>(
                            initialItems: _selectedLanguages,
                            textFieldConfiguration: TextFieldConfiguration(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white.withAlpha(30),
                                hintText: '자주 입력하는 항목 검색',
                                labelText: '항목검색',
                              ),
                            ),
                            findSuggestions: getLanguages,
                            additionCallback: (value) {
                              return Language(
                                name: value,
                                position: 0,
                              );
                            },
                            onAdded: (language) {
                              // api calls here, triggered when add to tag button is pressed
                              return Language(name: language.name, position: -1);
                            },
                            configureSuggestion: (lang) {
                              return SuggestionConfiguration(
                                title: Text(lang.name),
                                subtitle: Text(lang.position.toString()),
                                additionWidget: Chip(
                                  avatar: Icon(
                                    Icons.add_circle,
                                    color: Colors.white,
                                  ),
                                  label: Text('항목 추가'),
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            configureChip: (lang) {
                              return ChipConfiguration(
                                label: Text(lang.name),
                                backgroundColor: Colors.green,
                                labelStyle: TextStyle(color: Colors.white),
                                deleteIconColor: Colors.white,
                              );
                            },
                            onChanged: () {
                              setState(() {
                                _selectedValuesJson = _selectedLanguages
                                    .map<String>((lang) => '\n${lang.toJson()}')
                                    .toList()
                                    .toString();
                                _selectedValuesJson =
                                    _selectedValuesJson.replaceFirst('}]', '}\n]');
                              });
                            },
                          ),
                        ),




                        /**
                        TextFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          decoration: const InputDecoration(

                            hintText: '항목을 입력해주세요',
                            labelText: '항목',
                          ),
                          controller: _itemEditor,
                          validator: (value) => value!.isEmpty ? "Required filed *" : null,
                        ),**/
                        SizedBox(height: 9),

                        TextFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: TextInputType.number,
                          controller: _amountEditor,
                          onEditingComplete: () {
                            _amountEditor.text = NumberFormat.currency(locale: "ko_KR", symbol: "￦").format(int.parse(_amountEditor.text));
                          },

                          decoration: const InputDecoration(

                            hintText: '금액을 입력하세요',
                            labelText: "금액",
                          ),
                          validator: (val) {
                            if (val!.isEmpty) return "Required filed *";
                            if (double.tryParse(val) == null) {
                              return "Entre a valid number ";
                            }
                            return null;
                          },
                        ),



                        SizedBox(height: 9),
                        Row(
                          children: [
                            Icon(
                              Icons.people_outline,
                              color: Colors.black.withOpacity(.6),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    "자세한 기록을 남겨보아요.",
                                    style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(.7)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        _tags2,
                        if (showError)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                child: Text(
                                  "* Amount should be shared properly.",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                )
              ]

            ))),
      ),
        bottomNavigationBar:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: clearForm,
                child: Text(
                  "Save & Add another",
                  style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                ),
              ),
              TextButton(
                onPressed: () {
                  bool saved = saveRecord();
                  if (saved) {

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        )
    );
  }

  clearForm() {
    bool saved = saveRecord();
    if (!saved) return;
    formKey.currentState?.reset();
    _itemEditor.clear();
    _amountEditor.clear();
    // keep the person selector, category selector and date as it is while clearing the form
    // _personEditor?.clear();
    // _categoryEditor.clear();
    // _dateEditor.text = DateTime.now().toString();

    // _checkList = _users.map((_) => false).toList();

    _shareControler = _payTypes!.map((e) => TextEditingController(text: shareList![e])).toList();

    setState(() {});
  }

  bool saveRecord() {


    //if (formKey.currentState!.validate() ) {
    if (true ) {

      String mainType = _mainTypeEditor.text;
      String payType = _payTypeEditor.text;
      String item = _itemEditor.text;
      String startTime = DateFormat('yyyy-MM-dd').parse(_dateEditor.text).toString();
      int money = int.parse(_amountEditor.text);

      var dateKey = _box?.get(startTime);
      CleanCalendarEvent calEvent = CleanCalendarEvent(mainType,payType,item,money,startTime,color: mainType == "수입" ? Colors.blue : Colors.red);
      if(dateKey != null ) {
        dateKey.add(calEvent.toJson());
        _box?.put(startTime, dateKey);
      }else {
        _box?.put(startTime, [calEvent.toJson()]);
      }

      widget.onValueChanged('save');



      return true;
    }


    return false;
  }



  final List<String> _list = [
    '0',
    'SDK',
    'plugin updates',
    'Facebook',

    'Kirchhoff',
    'Italy',
    'France',
    'Spain',


  ];

  bool _symmetry = false;
  bool _removeButton = true;
  bool _singleItem = true;
  bool _startDirection = true;
  bool _horizontalScroll = false;
  bool _withSuggesttions = false;
  int _count = 0;
  int _column = 3;
  double _fontSize = 14;

  String _itemCombine = 'withTextBefore';

  String _onPressed = '';

  List _icon = [Icons.home, Icons.language, Icons.headset];
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  TagsTextField get _textField {
    return TagsTextField(
      autofocus: false,
      //width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      textStyle: TextStyle(
        fontSize: _fontSize,
        //height: 1
      ),
      enabled: true,
      constraintSuggestion: true,
      suggestions: true
          ? [
        "One",
        "two",
        "android",
        "Dart",

      ]
          : null,
      onSubmitted: (String str) {
        setState(() {
          _items.add(str);
        });
      },
    );
  }









  Widget get _tags2 {
    //popup Menu


    ItemTagsCombine combine = ItemTagsCombine.onlyText;

    switch (_itemCombine) {
      case 'onlyText':
        combine = ItemTagsCombine.onlyText;
        break;
      case 'onlyIcon':
        combine = ItemTagsCombine.onlyIcon;
        break;
      case 'onlyIcon':
        combine = ItemTagsCombine.onlyIcon;
        break;
      case 'onlyImage':
        combine = ItemTagsCombine.onlyImage;
        break;
      case 'imageOrIconOrText':
        combine = ItemTagsCombine.imageOrIconOrText;
        break;
      case 'withTextAfter':
        combine = ItemTagsCombine.withTextAfter;
        break;
      case 'withTextBefore':
        combine = ItemTagsCombine.withTextBefore;
        break;
    }

    return Tags(
      key: Key("2"),
      symmetry: _symmetry,
      columns: _column,
      horizontalScroll: false,
      verticalDirection:
      _startDirection ? VerticalDirection.up : VerticalDirection.down,

      heightHorizontalScroll: 60 * (_fontSize / 14),
      textField: _textField,
      itemCount: _items.length,
      itemBuilder: (index) {
        final item = _items[index];

        return GestureDetector(
          child: ItemTags(
            key: Key(index.toString()),
            index: index,
            title: item,
            active: false,
            pressEnabled: true,
            activeColor: Colors.green,
            singleItem: true,
            combine: combine,

            icon: (item == '0' || item == '1' || item == '2')
                ? ItemTagsIcon(
              icon: _icon[int.parse(item)],
            )
                : null,
            onPressed: (item) => print(item),
            removeButton: ItemTagsRemoveButton(
              backgroundColor: Colors.green[900],
              onRemoved: () {
                setState(() {
                  _items.removeAt(index);
                });
                return true;
              },
            ),
            textScaleFactor:
            utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
            textStyle: TextStyle(
              fontSize: _fontSize,
            ),
          ),
          onTapDown: (details) {
            print(details.globalPosition);
            _tapPosition = details.globalPosition;},
          onLongPress: () {
            showMenu(
              //semanticLabel: item,
                items: <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text(item, style: TextStyle(color: Colors.blueGrey)),
                    enabled: false,
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.content_copy),
                        Text("Copy text"),
                      ],
                    ),
                  ),
                ],
                context: context,

                position: RelativeRect.fromRect(
                    _tapPosition & Size(40, 40),
                    Rect.zero ) // & RelativeRect.fromLTRB(65.0, 40.0, 0.0, 0.0),
            )
                .then((value) {
              if (value == 1) Clipboard.setData(ClipboardData(text: item));
            });
          },
        );
      },
    );
  }



  late Offset _tapPosition;
  late List _items;



  bool showError = false;
}

Future<List<Language>> getLanguages(String query) async {
  await Future.delayed(Duration(milliseconds: 500), null);
  return <Language>[
    Language(name: '식비', position: 1),
    Language(name: '교통비', position: 2),
    Language(name: '주유비', position: 3),
    Language(name: '문화생활', position: 4),
    Language(name: '통신', position: 5),
    Language(name: '공과금', position: 6),
  ]
      .where((lang) => lang.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

/// Language Class
class Language extends Taggable {
  ///
  final String name;

  ///
  final int position;

  /// Creates Language
  Language({
    required this.name,
    required this.position,
  });

  @override
  List<Object> get props => [name];

  /// Converts the class to json string.
  String toJson() => '''  {
    "name": $name,\n
    "position": $position\n
  }''';
}
