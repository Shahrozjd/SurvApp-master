import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/products.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  static const routeName = '/detailsScreen';

  // const DetailsScreen({Key key, @required this.id}) : super(key: key);
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  TextEditingController _controller3;
  TextEditingController _controller4;
  String _valueChanged3 = '';
  String _valueToValidate3 = '';
  String _valueSaved3 = '';
  String _valueChanged4 = '';
  String _valueToValidate4 = '';
  String _valueSaved4 = '';
  bool _showMoreAbout = false;
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
    _controller3 = TextEditingController(text: DateTime.now().toString());

    String lsHour = TimeOfDay.now().hour.toString().padLeft(2, '0');
    String lsMinute = TimeOfDay.now().minute.toString().padLeft(2, '0');
    _controller4 = TextEditingController(text: '$lsHour:$lsMinute');

    _getValue();
  }

  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _controller3.text = '2002-01-09';
        _controller4.text = '9:00';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
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
                                  _sendingMails("sms:${loadedProduct.number}"),
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
                                onPressed: () => _sendingSMS(
                                    'mailto:${loadedProduct.email}')),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SmoothStarRating(
                            rating: loadedProduct.reviews,
                            size: 15,
                            color: Colors.orange,
                          ),
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
                          // Column(
                          //   children: <Widget>[
                          //     Text("${providerInfo[widget.id].certifications}",
                          //         style: Theme.of(context).textTheme.title),
                          //     Text(
                          //       "Certifications",
                          //       style: TextStyle(color: Colors.grey),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Pick Your Date And Time:",
                            style: Theme.of(context).textTheme.subtitle2,
                          )),
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _oFormKey,
                            child: Column(children: <Widget>[
                              DateTimePicker(
                                type: DateTimePickerType.date,
                                dateMask: 'yyyy/MM/dd',
                                controller: _controller3,
                                //initialValue: _initialValue,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                icon: Icon(Icons.event),
                                dateLabelText: 'Date',
                                locale: Locale('en', 'US'),
                                onChanged: (val) =>
                                    setState(() => _valueChanged3 = val),
                                validator: (val) {
                                  setState(() => _valueToValidate3 = val);
                                  return null;
                                },
                                onSaved: (val) =>
                                    setState(() => _valueSaved3 = val),
                              ),
                              DateTimePicker(
                                type: DateTimePickerType.time,
                                controller: _controller4,
                                //initialValue: _initialValue,
                                icon: Icon(Icons.access_time),
                                timeLabelText: "Time",
                                use24HourFormat: false,
                                locale: Locale('en', 'US'),
                                onChanged: (val) =>
                                    setState(() => _valueChanged4 = val),
                                validator: (val) {
                                  setState(() => _valueToValidate4 = val);
                                  return null;
                                },
                                onSaved: (val) =>
                                    setState(() => _valueSaved4 = val),
                              ),

                             
                            ]),
                          )),
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
                            final loForm = _oFormKey.currentState;

                            if (loForm.validate()) {
                              loForm.save();
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'DateTimePicker data value onChanged:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      SelectableText(_valueChanged3 ?? ''),
                      SelectableText(_valueChanged4 ?? ''),
                      SizedBox(height: 30),
                      Text(
                        'DateTimePicker data value validator:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      SelectableText(_valueToValidate3 ?? ''),
                      SelectableText(_valueToValidate4 ?? ''),
                      SizedBox(height: 10),
                      Text(
                        'DateTimePicker data value onSaved:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      SelectableText(_valueSaved3 ?? ''),
                      SelectableText(_valueSaved4 ?? ''),
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
}
