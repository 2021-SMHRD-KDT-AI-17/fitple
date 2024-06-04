import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialize();
  runApp(const NaverMapApp());
}

// 지도 초기화하기
Future<void> _initialize() async {
  await NaverMapSdk.instance.initialize(
    clientId: 'msismbjoka',  // 새로운 클라이언트 ID 설정
    onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"),
  );
}

class NaverMapApp extends StatelessWidget {
  const NaverMapApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: _initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const NaverMapView();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class NaverMapView extends StatelessWidget {
  const NaverMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Completer<NaverMapController> mapControllerCompleter = Completer();

    return NaverMap(
      options: const NaverMapViewOptions(
        indoorEnable: true,             // 실내 맵 사용 가능 여부 설정
        locationButtonEnable: false,    // 위치 버튼 표시 여부 설정
        consumeSymbolTapEvents: false,  // 심볼 탭 이벤트 소비 여부 설정
      ),
      onMapReady: (controller) async {                // 지도 준비 완료 시 호출되는 콜백 함수
        mapControllerCompleter.complete(controller);  // Completer에 지도 컨트롤러 완료 신호 전송
        log("onMapReady", name: "onMapReady");
      },
    );
  }
}