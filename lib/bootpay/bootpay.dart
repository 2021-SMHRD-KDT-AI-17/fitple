import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/stat_item.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TotalPayment extends StatelessWidget {
  final Map<String, dynamic> item; // item 매개변수 추가

  TotalPayment({required this.item}); // 생성자 수정

  String androidApplicationId = '664be87fbc8ef6011930061e';
 //
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결제정보', style: TextStyle(fontSize: 18),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, top: 15),
              child: Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.blueAccent,),
                  SizedBox(width: 10,),
                  Text('FITPLE',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                  ),),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:200),
              child: Column(
                children: [
                  Text('결제가 진행 중입니다.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),),
                  SizedBox(height: 18,),
                  Text('결제를 계속 진행하려면 \n 아래 버튼을 눌러주세요.',
                    style: TextStyle(
                      fontSize: 15,),)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:130),
              child: ElevatedButton(
                onPressed: () => bootpayTest(context),
                child: Text('결제하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shadowColor: Colors.black26,
                  minimumSize: Size(300,50),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  void bootpayTest(BuildContext context) async {
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
      onDone: (String data) {
        print('------- onDone: $data');
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

    payload.pg = '이니시스';
    payload.method = '카드';
    payload.methods = ['card', 'phone', 'vbank', 'bank', 'kakao'];
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
    user.username = "사용자 이름";
    user.email = "user1234@gmail.com";
    user.area = "서울";
    user.phone = "010-4033-4678";
    user.addr = '서울시 동작구 상도로 222';

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