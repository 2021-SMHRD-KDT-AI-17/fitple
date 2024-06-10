import 'package:fitple/DB/DB.dart';

// 상품등록
Future<void> insertItem(String ptName, String ptPrice, String trainerEmail) async {
  final conn = await dbConnector();

  try {
    await conn.execute(
      "INSERT INTO fit_item(pt_name, pt_price, trainer_email) VALUES (:pt_name, :pt_price, :trainer_email)",
      {
        "pt_name": ptName,
        "pt_price": ptPrice,
        "trainer_email": trainerEmail,
      },
    );
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  print('DB연결!');
}