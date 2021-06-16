import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> prefs = SharedPreferences.getInstance();
// ignore: non_constant_identifier_names
final TextEditingController TextNumberController = TextEditingController();
String title = 'drag drop';
var textnumber;
var finalPosition;
// ignore: non_constant_identifier_names
var finalPosition_x;
double width = 100.0, height = 100.0;
var finaltextnumber;
void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //for dy
  Future getPsy() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedPosition = sharedPreferences.getDouble(
      'position',
    );

    setState(() {
      finalPosition = obtainedPosition;
      print('from getpsy $finalPosition.0');
    });
  }

  //for dx
  Future getPsx() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedPositionX = sharedPreferences.getDouble(
      'position_x',
    );

    setState(() {
      finalPosition_x = obtainedPositionX;
      print('from getpsx $finalPosition_x.0');
    });
  }

  // ignore: non_constant_identifier_names
  Future get_textnumber() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedtextNumber = sharedPreferences.getString(
      'textnumber',
    );

    setState(() {
      finaltextnumber = obtainedtextNumber;
      print(finaltextnumber);
    });
  }

  void initState() {
    super.initState();
    getPsx();
    getPsy();
    get_textnumber();
    setState(() {
      print('from initstate $position');
      print(dx);
    });
  }

  static double get dx => 0.0;
  static double get dy => 0.0;
  var position = Offset(dx, dy);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.red.withOpacity(0.5),
            child: Center(
              child: RawMaterialButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('position');
                  prefs.remove('position_x');
                  setState(() {
                    print(position);
                  });
                },
                child: Text('clear all'),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: position.dx == 0.0 ? finalPosition_x : position.dx,
                top: position.dy == 0.0 ? finalPosition : position.dy,
                child: Draggable(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          onChanged: (value) {
                            textnumber = value;
                          },
                          controller: TextNumberController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText:finaltextnumber == ''
                                ? 'Enter here'
                                : finaltextnumber,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: () {},
                        child: Icon(
                          Icons.menu_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  feedback: Container(
                    child: null,
                  ),
                  onDraggableCanceled: (Velocity velocity, Offset offset) {
                    position = offset;
                    var pdx = position.dx;

                    // ignore: missing_return
                    Future<double> get() async {
                      var pdy = position.dy;
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setDouble('position', pdy);
                      print('from get dy $pdy.0');
                    }

                    // ignore: non_constant_identifier_names, missing_return
                    Future<double> get_x() async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setDouble('position_x', pdx);
                      print('from get dx $pdx.0');
                    }

                    // ignore: non_constant_identifier_names, missing_return
                    Future<int> Set_textnumber() async {
                      final SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      //here we passing the PhoneNumber to this "phoneNumber" token
                      //now we can get the store value by using this "phoneNumber" token
                      sharedPreferences.setString(
                          'textnumber', TextNumberController.text);
                      print('from $TextNumberController');
                    }

                    setState(() {
                      position = offset;
                      print('from set state $position');
                      get_x();
                      get();
                      Set_textnumber();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
