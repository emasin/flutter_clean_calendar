  import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  final int keyboardType;
  final Icon? icon;
  final String defaultText;
  MyTextField({this.label = '', this.maxLines = 1, this.minLines = 1, this.icon,this.defaultText='',this.keyboardType = 1});

  @override
  Widget build(BuildContext context) {
    return this.keyboardType == 2 ? TextField(
      controller: TextEditingController(text: defaultText),
      style: TextStyle(color: Colors.black87),
      minLines: minLines,
      maxLines: maxLines,
      keyboardType:  TextInputType.number ,
      textInputAction: TextInputAction.done,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ], // Only
      decoration: InputDecoration(
        suffixIcon: icon == null ? null: icon,
          labelText: label,
          labelStyle: TextStyle(color: Colors.black45),
          
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    ) : TextField(
      controller: TextEditingController(text: defaultText),
      style: TextStyle(color: Colors.black87),
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
          suffixIcon: icon == null ? null: icon,
          labelText: label,
          labelStyle: TextStyle(color: Colors.black45),

          focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    );
  }
}
