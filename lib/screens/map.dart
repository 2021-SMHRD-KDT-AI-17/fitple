import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialize();
  runApp(const NaverMapApp());
}

Future<void> _initialize() async {
  await NaverMapSdk.instance.initialize(
    clientId: 'msismbjoka',  // 클라이언트 ID 설정
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
        indoorEnable: true,
        locationButtonEnable: false,
        consumeSymbolTapEvents: false,
        initialCameraPosition: NCameraPosition(
          target: NLatLng(35.15052, 126.9162),
          zoom: 18,
          bearing: 0,
          tilt: 0,
        ),
      ),
      onMapReady: (controller) async {
        mapControllerCompleter.complete(controller);
        log("onMapReady", name: "onMapReady");
        await _setInitialLocation(controller);
      },
    );
  }

  Future<void> _setInitialLocation(NaverMapController controller) async {
    // 광주 동구 중앙로 196 스마트인재개발원 위치 좌표
    final initialLocation = NLatLng(35.15052, 126.9162);

    // 해당 위치로 마커 추가
    final marker = NMarker(
        id: 'smart',
        position: const NLatLng(35.15052, 126.9162));
    await controller.addOverlayAll({marker});

    final onMarkerInfoWindow = NInfoWindow.onMarker(id: marker.info.id, text: "스마트인재개발원");
    marker.openInfoWindow(onMarkerInfoWindow);
  }
}

class NaverMapView1 extends StatelessWidget {
  const NaverMapView1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Completer<NaverMapController> mapControllerCompleter = Completer();

    return NaverMap(
      options: const NaverMapViewOptions(
        indoorEnable: true,
        locationButtonEnable: false,
        consumeSymbolTapEvents: false,
        initialCameraPosition: NCameraPosition(
          target: NLatLng(35.2204353, 126.8470647),
          zoom: 18,
          bearing: 0,
          tilt: 0,
        ),
      ),
      onMapReady: (controller) async {
        mapControllerCompleter.complete(controller);
        log("onMapReady", name: "onMapReady");
        await _setInitialLocation(controller);
      },
    );
  }

  Future<void> _setInitialLocation(NaverMapController controller) async {
    // 육체미 첨단점
    final initialLocation = NLatLng(35.2204353, 126.8470647);

    // 해당 위치로 마커 추가
    final marker = NMarker(
        id: '육체미',
        position: const NLatLng(35.2204353, 126.8470647));
    await controller.addOverlayAll({marker});

    final onMarkerInfoWindow = NInfoWindow.onMarker(id: marker.info.id, text: "육체미 첨단점");
    marker.openInfoWindow(onMarkerInfoWindow);
  }
}


