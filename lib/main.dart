import 'package:flutter/material.dart';

import 'widgets/app.dart';
import 'injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(App());
}
