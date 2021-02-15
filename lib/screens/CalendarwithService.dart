import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surv/screens/calendar.dart';
import 'package:surv/widgets/app_drawer.dart';

class CalendarwithService extends StatefulWidget {
  static const routeName = '/calendarservice';

  @override
  _CalendarwithServiceState createState() => _CalendarwithServiceState();
}

class _CalendarwithServiceState extends State<CalendarwithService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      drawer: AppDrawer(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Choose a Service',
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query: FirebaseDatabase.instance.reference().child("services"),
                itemBuilder: (
                  BuildContext context,
                  DataSnapshot snapshot,
                  Animation<double> animation,
                  int index,
                ) {
                  Map services = snapshot.value;
                  return _servicecard(
                    services: services,
                    onpress: () {
                      print(snapshot.key);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Calendar(
                            docid: snapshot.key.toString(),
                            title: snapshot.value['title'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _servicecard({Map services, Function onpress}) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        margin: EdgeInsets.all(15),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(services['imageUrl']),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  services['title'],
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
