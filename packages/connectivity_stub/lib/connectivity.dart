export 'src/connectivity_stub.dart' 
   // ignore: uri_does_not_exist
  if (dart.library.html) 'src/connectivity_html.dart'
   // ignore: uri_does_not_exist
  if (dart.library.io) 'package:connectivity/connectivity.dart';