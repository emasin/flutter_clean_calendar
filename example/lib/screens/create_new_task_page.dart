import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:finan_ledger/theme/colors/light_colors.dart';
import 'package:finan_ledger/widgets/top_container.dart';
import 'package:finan_ledger/widgets/back_button.dart';
import 'package:finan_ledger/widgets/my_text_field.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:select_form_field/select_form_field.dart';

typedef LabelledValueChanged<T, U> = void Function(T label);

class CreateNewTaskPage extends StatefulWidget {
  const CreateNewTaskPage(this.onValueChanged);
  final LabelledValueChanged<String, dynamic> onValueChanged;

  @override
  _CreateNewTaskPageState createState() => _CreateNewTaskPageState();
}

class _CreateNewTaskPageState extends State<CreateNewTaskPage> {
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
  }

  void printBox() {
    final cats = _box.values;
  }


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  TextEditingController _itemEditor = TextEditingController();
  TextEditingController _payTypeEditor = TextEditingController();
  TextEditingController _amountEditor = TextEditingController();
  TextEditingController _dateEditor = TextEditingController(text: DateTime.now().toString());
  TextEditingController _mainTypeEditor = TextEditingController();
  List<TextEditingController>? _shareControler;
  Map<String, String>? shareList;
  List<String>? _payTypes;
  List<String>? _mainTyepe;
  List<double>? _sharedRatio;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                        SelectFormField(
                          // key: ValueKey<int>(count2),
                          autovalidate: false,
                          type: SelectFormFieldType.dropdown, // or can be dialog
                          controller: _mainTypeEditor,
                          icon: Icon(Icons.category),
                          hintText: 'Category of the spend',
                          labelText: 'Category',
                          items: _mainTyepe!
                              .map((e) => {
                            "value": e,
                            "label": e,
                          })
                              .map((e) => Map<String, dynamic>.from(e))
                              .toList(),

                          validator: (value) => value!.isEmpty ? "Required field *" : null,
                        ),
                        SizedBox(height: 9),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.shopping_cart_outlined),
                            hintText: 'Where did you spent the money?',
                            labelText: 'Item',
                          ),
                          controller: _itemEditor,
                          validator: (value) => value!.isEmpty ? "Required filed *" : null,
                        ),
                        SizedBox(height: 9),
                        SelectFormField(
                          icon: Icon(Icons.person_outline),
                          labelText: 'Spent By',
                          controller: _payTypeEditor,
                          items: _payTypes!.map((e) => {
                            "value": e,
                            "label": e,
                          })
                              .map(
                                  (e) => Map<String, dynamic>.from(e)) // select form field items require <String,dynamic>
                              .toList(),
                          validator: (value) => value!.isEmpty ? "Required filed *" : null,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: TextInputType.number,
                          controller: _amountEditor,
                          onChanged: (value) {

                          },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.account_balance_wallet_outlined),
                            hintText: 'How much money is spent?',
                            labelText: "Amount",
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
                        DateTimePicker(
                          controller: _dateEditor,
                          type: DateTimePickerType.date,
                          dateMask: 'yyyy년 MM월 dd일',
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          dateLabelText: 'Date',
                          locale: Locale("ko","KR"),
                          validator: (value) => value!.isEmpty ? "Required field *" : null,
                        ),
                        SizedBox(height: 9),

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
                                    "Shared Between",
                                    style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(.7)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9),
                          child: Column(
                            children: List.generate(
                              _payTypes!.length,
                                  (index) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 9),
                                          child: Text(
                                            _payTypes![index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade400,
                                              borderRadius: BorderRadius.all(Radius.circular(10))),
                                          // width: (MediaQuery.of(context).size.width - 100) * 0.5,
                                          height: 21,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              IconButton(
                                                padding: const EdgeInsets.all(0),
                                                iconSize: 13,
                                                color: _sharedRatio![index] == 0 ? Colors.black12 : Colors.black,
                                                icon: const Icon(Icons.remove_circle_outline),
                                                onPressed: () {
                                                  if (_amountEditor.text.trim().isEmpty ||
                                                      double.parse(_amountEditor.text) == 0) return;
                                                  if (_sharedRatio![index] > 0) {
                                                    _sharedRatio![index] -= 1;

                                                  }
                                                },
                                              ),
                                              Text(
                                                _sharedRatio![index]!.toStringAsFixed(2),
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                              IconButton(
                                                padding: const EdgeInsets.all(0),
                                                iconSize: 13,
                                                color: _sharedRatio![index] == 99 ? Colors.black12 : Colors.black,
                                                icon: const Icon(Icons.add_circle_outline),
                                                onPressed: () {
                                                  if (_sharedRatio![index] < 99) {
                                                    if (_amountEditor.text.trim().isEmpty ||
                                                        double.parse(_amountEditor.text) == 0) return;
                                                    _sharedRatio![index] += 1;

                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text("₹ ", style: TextStyle(fontSize: 14)),
                                            Container(
                                              height: 21,
                                              width: (MediaQuery.of(context).size.width - 100) * 0.5,
                                              padding: EdgeInsets.only(left: 7),
                                              child: TextField(
                                                onChanged: (val) {

                                                },
                                                textAlign: TextAlign.left,
                                                enabled: _sharedRatio![index] != 0,
                                                controller: _shareControler![index],
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black26),
                                                  ),
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black38),
                                                  ),
                                                ),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
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
  bool showError = false;
}
