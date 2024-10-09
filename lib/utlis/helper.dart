import 'package:flutter/material.dart';

class Helper {
  static void showProgressIndicator(BuildContext context) {
    showDialog(context: context, builder: (_) => Center(child: CircularProgressIndicator()));
  }
}
