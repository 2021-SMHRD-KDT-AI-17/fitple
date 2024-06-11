import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:fitple/DB/payDB.dart';

class TotalPayment extends StatelessWidget {
  final String userName;
  final String userEmail;
  final Map<String, dynamic> item;
  final int gymIdx;

  TotalPayment({required this.item, required this.userName, required this.userEmail, required this.gymIdx});

  String androidApplicationId = '664be87fbc8ef6011930061e';

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결제정보', style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, top: 15),
              child: Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text(
                    'FITPLE',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Text(
                    '결제가 진행 중입니다.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 18),
                  Text(
                    '결제를 계속 진행하려면 \n 아래 버튼을 눌러주세요.',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 130),
              child: ElevatedButton(
                onPressed: () => bootpayTest(context),
                child: Text(
                  '결제하기',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shadowColor: Colors.black26,
                  minimumSize: Size(300, 50),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // 이메일 형식 검증 정규 표현식
    final RegExp regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  void bootpayTest(BuildContext context) async {
    if (!isValidEmail(userEmail)) {
      print('Invalid email format');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('잘못된 이메일 형식입니다.')),
      );
      return;
    }

    Payload payload = await getPayload();
    if (kIsWeb) {
      payload.extra?.openType = "iframe";
    }

    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onError: $data');
      },
      onClose: () {
        print('------- onClose');
        Bootpay().dismiss(context);
      },
      onIssued: (String data) {
        print('------- onIssued: $data');
      },
      onConfirm: (String data) {
        print('------- onConfirm: $data');
        return true;
      },
      onDone: (String data) async {
        print('------- onDone: $data');

        try {
          await PayDB.ensureUserExists(userEmail, userName);
          await PayDB.savePaymentInfo(userEmail, item["pt_name"], item["trainer_email"], 1, int.parse(item["pt_price"].toString()), gymIdx); // gymIdx 추가
          print('Payment information saved to database.');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('결제가 완료되었습니다.')),
          );
        } catch (e) {
          print('Error saving payment information: $e');
        }
      },
    );
  }

  Future<Payload> getPayload() async {
    Item item1 = Item();
    item1.name = item["pt_name"];
    item1.qty = 1;
    item1.id = "ITEM_CODE_Health";
    item1.price = double.parse(item["pt_price"].toString());

    List<Item> itemList = [item1];

    Payload payload = Payload();
    payload.androidApplicationId = androidApplicationId;

    payload.pg = '나이스페이';
    payload.method = '카드';
    payload.methods = ['card', 'phone', 'vbank', 'bank', 'kakao', 'naverpay', 'payco'];
    payload.orderName = item1.name;
    payload.price = item1.price;

    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();

    payload.metadata = {
      "callbackParam1": "value12",
      "callbackParam2": "value34",
      "callbackParam3": "value56",
      "callbackParam4": "value78",
    };
    payload.items = itemList;

    User user = User();
    user.username = userName;
    user.email = userEmail;

    Extra extra = Extra();
    extra.appScheme = 'bootpayFlutterExample';
    extra.cardQuota = '3';
    extra.openType = 'popup';
    extra.phoneCarrier = "SKT,KT,LGT";
    extra.ageLimit = 20;

    payload.user = user;
    payload.extra = extra;
    return payload;
  }
}