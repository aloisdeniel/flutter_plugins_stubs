export 'src/shared_preferences_stub.dart' 
   // ignore: uri_does_not_exist
  if (dart.library.html) 'src/shared_preferences_html.dart'
   // ignore: uri_does_not_exist
  if (dart.library.io) 'package:shared_preferences/shared_preferences.dart';