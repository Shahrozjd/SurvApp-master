//Add the calendar on this screen where the provider
//can pick free dates and times and see the appoinments
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:surv/widgets/RectButton.dart';
import 'package:toast/toast.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class Calendar extends StatefulWidget {
  static const routeName = '/calendar';
  String docid;
  String title;
  Calendar({this.docid,this.title});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of(context, listen: false).fetchAndSetProducts();
  }

  DatePickerController _controller = DatePickerController();
  var totalDays;
  bool check = false;
  TextEditingController _controller4;
  String _valueToValidate4 = '';
  String _valueSaved4 = '';
  String _valueChanged4 = '';


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Calendar'),
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.only(top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: EdgeInsets.all(15),child: Text('Choose Daily Timings',style: TextStyle(fontSize: 25),),),
            SizedBox(height: 5,),
            Padding(padding: EdgeInsets.all(15),child: Text(widget.title,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),),
            DatePicker(
              DateTime.now()
                  .subtract(new Duration(days: DateTime.now().weekday - 1)),

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
              onDateChange: (date) {
                // New date selected
                setState(() {
                  String currdate = date.day.toString() +
                      "-" +
                      date.month.toString() +
                      "-" +
                      date.year.toString();
                  print(currdate);
                  showDialog(currdate);
                });
              },
            ),
          ],
        ),
      ),
    );
  }


  Future<String> selectTimeFrom(BuildContext context) async {

  }

  void showDialog(String date) async {
    List<String> timings = [];
    await FirebaseFirestore.instance
        .collection('servicescalendar')
        .doc(widget.docid).collection("calendar")
          .doc(date)
          .get()
          .then<dynamic>((DocumentSnapshot snapshot) async {
        setState(() {
          if (snapshot.exists) {
            Map<String, dynamic> data = snapshot.data();
            timings = List.from(data['timings']);
            print(timings);
          }
        });
      });
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        String shFromTime;
        return StatefulBuilder(
          builder: (context, setState) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox.expand(
                    child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Date: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(date, style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            // Select time
                            Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Icon(Icons.access_time),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() async {
                                            TimeOfDay selectedTime = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );

                                            MaterialLocalizations localizations = MaterialLocalizations.of(context);
                                            String formattedTime = localizations.formatTimeOfDay(selectedTime,
                                                alwaysUse24HourFormat: false);

                                            if (formattedTime != null) {
                                              setState(() {
                                                shFromTime = formattedTime;
                                              });

                                            }
                                          });
                                        },
                                        splashColor:
                                            Colors.black.withOpacity(0.2),
                                        child: Text(
                                          shFromTime==null?'Select Time':shFromTime,
                                          style: TextStyle(fontSize: 18),
                                        ))
                                  ],
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                RectButton(
                                  textval: 'Add',
                                  onpress: () {
                                    setState(() {
                                      timings.add(shFromTime);
                                      print(timings.toString());
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RectButton(
                              textval: 'Save',
                              onpress: () {
                                setState(() {
                                  addtofirestore(
                                    day: date,
                                    timings: timings.toList(),
                                  );
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: GridView.builder(
                                itemCount: timings.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 3.0,
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2),
                                itemBuilder: (context, index) {
                                  return Container(
                                    alignment: Alignment.center,
                                    color: Colors.red,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: InkWell(
                                              splashColor:
                                                  Colors.white.withOpacity(0.3),
                                              child: Icon(Icons.cancel),
                                              onTap: () {
                                                setState(() {
                                                  timings.remove(timings[index]
                                                      .toString());
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
                            )
                          ],
                        )),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 40, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }



  Future<void> addtofirestore({String day, List<String> timings}) async {
    await FirebaseFirestore.instance
        .collection('servicescalendar')
        .doc(widget.docid)
        .collection('calendar')
        .doc(day)
        .set({
      'timings': timings.toList(),
    }).then((value) {
      print('Data saved');
      Toast.show("Timings saved for this day ", context,
          duration: 3, gravity: Toast.BOTTOM);
    }).catchError((e) => print('Cant save day data'));
  }
}
