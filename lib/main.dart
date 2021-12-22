import 'package:flutter/material.dart';

import 'widgets/app.dart';
import 'dependency_container.dart' as dc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dc.init();
  runApp(App());
}
