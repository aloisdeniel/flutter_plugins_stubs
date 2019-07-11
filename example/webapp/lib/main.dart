import 'package:flutter_web/material.dart';
import 'package:shared/view_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel viewModel;

  @override
  void initState() {
    this.viewModel = HomeViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel as Listenable,
      builder: (context, _) {
        return Column(
          children: <Widget>[
            Text("Is connected: ${viewModel.status}"),
            RaisedButton(child: Text("Start refresh"), onPressed: () => viewModel.update()),
            RaisedButton(child: Text("Open Google"), onPressed: () => viewModel.openGoogle()),
          ],
        );
      },
    );
  }
}
