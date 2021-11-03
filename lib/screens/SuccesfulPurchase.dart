import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/screens/main/Frame/home/edit_fav.dart';
import 'package:winlife/screens/main/dashboard.dart';

class SuccesfulPurchase extends StatelessWidget {
  final String namaHadiah;
  const SuccesfulPurchase(this.namaHadiah);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(height: 70),
            Center(
              child: Image.asset(
                'assets/images/success-bulb.png',
                width: size.width * .30,
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text("Success!",
                    style: TextStyle(
                        color: Color(0xff063057),
                        fontSize: 24,
                        fontWeight: FontWeight.w800)),
              ),
            ),
            Center(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.all(7.0),
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xffFFAC38), width: 3),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: SelectableText(
                        namaHadiah.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Text(' Hadiah '),
                      )),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(85, 20, 85, 20),
                child: Text(
                    "Selamat...Anda telah berhasil menerima hadiah (" +
                        namaHadiah.toString() +
                        " / voucher).",
                    style: TextStyle(color: Color(0xff063057), fontSize: 14),
                    textAlign: TextAlign.center),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DashboardPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 0.0,
                    minWidth: 200.0,
                    height: 40.0,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DashboardPage())).then((_) {
                        // This block runs when you have come back to the 1st Page from 2nd.
                        setState(() {
                          // Call setState to refresh the page.
                        });
                      });
                    },
                    color: mainColor,
                    child: Text('GO HOME',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'mulibold')),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void setState(Null Function() param0) {
    //DashboardPage();
  }
}

MaterialButton viewMoreButtons(String title, Function fun) {
  return MaterialButton(
    //onPressed: fun,
    onPressed: null,
    textColor: Colors.white,
    color: const Color(0xffFFAC38),
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.left,
      ),
    ),
    height: 55,
    minWidth: 700,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  );
}

RaisedButton blueButton(String label, Function fun) {
  return RaisedButton(
    onPressed: null,
    textColor: Colors.white,
    color: Color(0xfff063057),
    padding: const EdgeInsets.all(15.0),
    child: Text(label),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}

showPowerBottomSheet(BuildContext context) => showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Container(
        height: 600,
        color: Color(0xFF737373),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
              )),
          child: Column(
            children: <Widget>[
              viewMoreButtons(
                  "Close Transaction", () => {Navigator.pop(context)}),
              SizedBox(height: 10),
              listItemContainer("Date of Transaction", "17th April, 2019"),
              listItemContainer("Transaction References", "KED12435353636"),
              listItemContainer("Token", "1234 5668 4657 3849"),
              listItemContainer("Account Type", "Prepaid"),
            ],
          ),
        ),
      );
    });

Widget listItemContainer(String title, String value) => Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(196, 196, 196, 1)),
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
        ],
      ),
      decoration: BoxDecoration(
          border: new Border(
              bottom: new BorderSide(width: 1.0, color: Color(0xffC4C4C4)))),
    );
