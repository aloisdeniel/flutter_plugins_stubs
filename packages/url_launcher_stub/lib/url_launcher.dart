export 'src/url_launcher_stub.dart' 
   // ignore: uri_does_not_exist
  if (dart.library.html) 'src/url_launcher_html.dart'
   // ignore: uri_does_not_exist
  if (dart.library.io) 'package:url_launcher/url_launcher.dart';