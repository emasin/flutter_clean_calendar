  import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  final Icon icon;
  final String defaultText;
  MyTextField({this.label, this.maxLines = 1, this.minLines = 1, this.icon,this.defaultText=''});

  @override
  Widget build(BuildContext context) {
    return TextField(
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
