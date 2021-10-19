import 'package:flutter/material.dart';

class VADetail extends StatefulWidget {
  const VADetail({Key? key}) : super(key: key);

  @override
  _VADetailState createState() => _VADetailState();
}

class _VADetailState extends State<VADetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "VA Number ",
                        style:
                            TextStyle(fontFamily: 'neosansbold', fontSize: 15),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "1092381230912938",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontFamily: 'muli', fontSize: 15),
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }
}
