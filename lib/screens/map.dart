import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

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

class NaverMapView extends StatefulWidget {
  const NaverMapView({Key? key}) : super(key: key);

  @override
  _NaverMapViewState createState() => _NaverMapViewState();
}

class _NaverMapViewState extends State<NaverMapView> {
  final Completer<NaverMapController> _mapControllerCompleter = Completer();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: NaverMap(
            options: NaverMapViewOptions(
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
              _mapControllerCompleter.complete(controller);
              log("onMapReady", name: "onMapReady");
              await _setInitialLocation(controller);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              TextFormField(
                controller: _postcodeController,
                decoration: const InputDecoration(
                  hintText: '우편번호',
                ),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: '기본주소',
                ),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextFormField(
                textInputAction: TextInputAction.done,
                controller: _addressDetailController,
                decoration: const InputDecoration(
                  hintText: '상세주소 입력',
                ),
              ),
              const SizedBox(height: 10),
              CupertinoButton(
                onPressed: () => _searchAddress(context),
                child: const Text('주소검색'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _setInitialLocation(NaverMapController controller) async {
    // 초기 위치 설정 (스마트인재개발원 위치 좌표)
    final initialLocation = NLatLng(35.15052, 126.9162);

    // 해당 위치로 마커 추가
    final marker = NMarker(
      id: 'smart',
      position: initialLocation,
    );
    await controller.addOverlay(marker);

    final onMarkerInfoWindow = NInfoWindow.onMarker(id: marker.info.id, text: "스마트인재개발원");
    marker.openInfoWindow(onMarkerInfoWindow);
  }

  void _searchAddress(BuildContext context) async {
    KopoModel? model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );

    if (model != null) {
      final postcode = model.zonecode ?? '';
      _postcodeController.value = TextEditingValue(
        text: postcode,
      );

      final address = model.address ?? '';
      _addressController.value = TextEditingValue(
        text: address,
      );

      final buildingName = model.buildingName ?? '';
      _addressDetailController.value = TextEditingValue(
        text: buildingName,
      );

      // 주소 검색 후 지도 위치 업데이트
      if (address.isNotEmpty) {
        final controller = await _mapControllerCompleter.future;
        // 예시 좌표 (서울 시청)
        final newLocation = NLatLng(37.5666102, 126.9783881);

        final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
          target: newLocation,
          zoom: 18,
        ).setAnimation(
          animation: NCameraAnimation.fly,
          duration: const Duration(seconds: 2),
        );

        //await controller.animateCamera(cameraUpdate);

        final newMarker = NMarker(id: 'newLocation', position: newLocation);
        await controller.addOverlay(newMarker);
      }
    }
  }
}