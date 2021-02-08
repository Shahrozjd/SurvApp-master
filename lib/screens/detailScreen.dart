import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../main.dart';
import '../providers/products.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

class DetailsScreen extends StatefulWidget {
  static const routeName = '/detailsScreen';

  // const DetailsScreen({Key key, @required this.id}) : super(key: key);
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  DatePickerController _controller = DatePickerController();
  String clientDate;

  // DateTime _selectedValue = DateTime.now();
  String _selectedValue = null;
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  TextEditingController _controller4;
  String clientTime;
  String _valueChanged4 = '';
  String _valueToValidate4 = '';
  String _valueSaved4 = '';
  bool _showMoreAbout = false;
  List<String> timings = [];
  List<String> aptimings = [];
  List<bool> ischeck;
  String currdate;

  _sendingMails(String m) async {
    if (await canLaunch(m)) {
      await launch(m);
    } else {
      throw 'Could not launch $m';
    }
  }

  _sendingSMS(String s) async {
    if (await canLaunch(s)) {
      await launch(s);
    } else {
      throw 'Could not launch $s';
    }
  }

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_US';
    String lsHour = TimeOfDay.now().hour.toString().padLeft(2, '0');
    String lsMinute = TimeOfDay.now().minute.toString().padLeft(2, '0');
    _controller4 = TextEditingController(text: '$lsHour:$lsMinute');
  }

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    final authData = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        //    floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.replay),
        //   onPressed: () {
        //     _controller.animateToSelection();
        //   },
        // ),
        body: LayoutBuilder(
          // builder: (context, _) => Stack(
          builder: (context, _) => Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: MediaQuery.of(context).size.height / 3,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        loadedProduct.imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.5),
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DraggableScrollableSheet(
                  initialChildSize: 2 / 3,
                  minChildSize: 2 / 3,
                  maxChildSize: 1,
                  builder: (context, scrollController) => Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          offset: Offset(0, -3),
                          blurRadius: 5.0,
                        )
                      ],
                    ),
                    child: ListView(controller: scrollController, children: <
                        Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${loadedProduct.title}",
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                                // Text(
                                //   "${providerInfo[widget.id].type}",
                                //   style: TextStyle(color: Colors.grey),
                                // ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  _sendingSMS("tel:${loadedProduct.number}"),
                            ),
                          ),
                          SizedBox(width: 15),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: IconButton(
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                onPressed: () => _sendingMails(
                                    'mailto:${loadedProduct.email}')),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SmoothStarRating(
                              // rating: loadedProduct.reviews,
                              //
                              rating: loadedProduct.isRated,
                              isReadOnly: false,
                              size: 15,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              defaultIconData: Icons.star_border,
                              starCount: 5,
                              allowHalfRating: true,
                              spacing: 2.0,
                              onRated: (value) {
                                print("rating value -> $value");
                                // loadedProduct.toggleRatingStatus(
                                //     authData.token, authData.userId, value);
                              }),
                          // Text("(${loadedProduct.reviewCount} Reviews)"),
                          Expanded(
                            child: FlatButton(
                              child: FittedBox(
                                child: Text(
                                  "See all reviews",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: Colors.blue),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                      Text(
                        "About",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      Wrap(
                        children: <Widget>[
                          Text(
                            "${loadedProduct.description}",
                            maxLines: _showMoreAbout ? null : 1,
                          ),
                          FlatButton(
                            child: Text(
                              _showMoreAbout ? "See Less" : "See More",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: Colors.blue),
                            ),
                            onPressed: () {
                              setState(() {
                                _showMoreAbout = !_showMoreAbout;
                              });
                            },
                          )
                        ],
                      ),
                      Text(
                        "Working Hours",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      Row(
                        children: <Widget>[
                          Text("${loadedProduct.workingHours}"),
                          SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(9.0),
                              child: Text(
                                "Open",
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: Colors.green),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Color(0xffdbf3e8),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Stats",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(height: 11),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          // Column(
                          //   children: <Widget>[
                          //     Text("${doctorInfo[widget.id].patientsCount}",
                          //         style: Theme.of(context).textTheme.title),
                          //     Text(
                          //       "Patients",
                          //       style: TextStyle(color: Colors.grey),
                          //     )
                          //   ],
                          // ),
                          Column(
                            children: <Widget>[
                              Text("${loadedProduct.experience} Years",
                                  style: Theme.of(context).textTheme.title),
                              Text(
                                "Experience",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(
                            "Pick Your Date And Time:",
                            style: Theme.of(context).textTheme.subtitle2,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 18),
                        child: Container(
                          child: DatePicker(
                            DateTime.now().subtract(
                                new Duration(days: DateTime.now().weekday - 1)),
                            width: 60,
                            height: 80,
                            controller: _controller,
                            // initialSelectedDate: DateTime.now(),
                            initialSelectedDate: null,
                            selectionColor: Colors.black,
                            selectedTextColor: Colors.white,

                            // inactiveDates: [
                            //   DateTime.now().add(Duration(days: 1)),
                            //   DateTime.now().add(Duration(days: 4)),
                            //   DateTime.now().add(Duration(days: 7))
                            // ],
                            onDateChange: (date) async {
                              // New date selected

                              timings = [];
                              aptimings = [];

                              currdate = date.day.toString() +
                                  "-" +
                                  date.month.toString() +
                                  "-" +
                                  date.year.toString();

                              await FirebaseFirestore.instance
                                  .collection("calendar")
                                  .doc(currdate)
                                  .get()
                                  .then<dynamic>((DocumentSnapshot snapshot) {
                                setState(() {
                                  if (snapshot.exists) {
                                    Map<String, dynamic> data = snapshot.data();
                                    timings = List.from(data['timings']);
                                    aptimings = List.from(data['timings']);
                                    print(timings);
                                    ischeck = List<bool>.filled(timings.length, false);
                                    _selectedValue = currdate;
                                  }
                                });
                              });
                            },
                          ),
                        ),
                      ),
                      _selectedValue == null
                          ? Center(
                              child: Text('Please Choose a date'),
                            )
                          : Container(
                            height: 150,
                            child: GridView.builder(
                              itemCount: timings.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 3.0,
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5),
                              itemBuilder: (context, index) {
                                return Container(
                                  alignment: Alignment.center,
                                  color: Colors.red,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 3.0),
                                        child: InkWell(
                                            splashColor: Colors.white
                                                .withOpacity(0.3),
                                            child: ischeck[index]
                                                ? Icon(Icons.done)
                                                : Icon(Icons.add),
                                            onTap: () {
                                              setState(() {
                                                if (ischeck[index]) {
                                                  ischeck[index] = false;
                                                  aptimings.add(timings[index].toString());

                                                } else {
                                                  ischeck[index] = true;
                                                  aptimings.remove(timings[index].toString());
                                                }
                                              });
                                            }),
                                      ),
                                      Text(
                                        timings[index].toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          color: Colors.blue,
                          child: Text(
                            "Make An Appointement",
                            style: Theme.of(context).textTheme.button,
                          ),
                          onPressed: () {
                            print(currdate);
                            print(aptimings);

                            updatetimingstofirestore(day: currdate,timings: aptimings);
                            // clientDate = _selectedValue.toString();
                            // clientTime = _valueSaved4;
                            //
                            // final loForm = _oFormKey.currentState;
                            //
                            // if (loForm.validate()) {
                            //   loForm.save();
                            // }
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updatetimingstofirestore({String day, List<String> timings}) async {
    await FirebaseFirestore.instance.collection('calendar').doc(day).update({
      'timings': timings.toList(),
    }).then((value) {
      print('Data saved');
      Toast.show("Done", context,
          duration: 3, gravity: Toast.BOTTOM);
    }).catchError((e) => print('Cant save day data'));
  }
}
