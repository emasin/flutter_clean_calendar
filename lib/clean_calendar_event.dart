import 'package:flutter/material.dart';

class CleanCalendarEvent {
  // 수입,지출
  String mainType;
  // 현급,카드,계좌(은행)
  String payType;
  // 분류
  String mainCategory;
  // 하위 분류
  String subCategory;
  // 금액
  int money;

  String summary;
  String description;
  String location;
  String startTime;
  Color color;


  CleanCalendarEvent(
      this.mainType,
      this.payType,
      this.mainCategory,
      this.money,
      this.startTime,
      {
        this.subCategory = '',
        this.description = '',
        this.summary = '',
        this.location = '',
        this.color = Colors.blue,
       });
}
