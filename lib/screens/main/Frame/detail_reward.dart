import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winlife/constant/color.dart';
import 'package:winlife/data/model/reward_model.dart';
import 'package:winlife/data/model/voucher_model.dart';

class DetailReward extends StatefulWidget {
  const DetailReward({Key? key}) : super(key: key);

  @override
  _DetailRewardState createState() => _DetailRewardState();
}

class _DetailRewardState extends State<DetailReward> {
  ArgumentDetailVoucher args = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        title: Text(args.title),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Flexible(
                flex: 1,
                child: Image.network(
                  args.voucher.foto,
                  fit: BoxFit.fill,
                )),
            Flexible(
                flex: 3,
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.all(12),
                      child: Text(
                        args.voucher.promoCode,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: Text(
                        'Voucher Lifetime\n' +
                            args.voucher.valid_from.replaceAll('-', '/') +
                            ' - ' +
                            args.voucher.valid_until.replaceAll('-', '/'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      margin: EdgeInsets.all(12),
                      child: Text(
                        args.voucher.deskripsi,
                        style: TextStyle(
                          fontFamily: 'neosans',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      margin: EdgeInsets.all(12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: mainColor),
                        onPressed: () {},
                        child: Text(
                          "CLAIM",
                          style: TextStyle(
                              fontFamily: 'neosans',
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class ArgumentDetailReward {
  String title;
  Reward reward;
  ArgumentDetailReward({required this.title, required this.reward});
}

class ArgumentDetailVoucher {
  String title;
  Voucher voucher;
  ArgumentDetailVoucher({required this.title, required this.voucher});
}
