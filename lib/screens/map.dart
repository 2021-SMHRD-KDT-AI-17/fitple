import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:http/http.dart' as http;

class NaverMapApp extends StatelessWidget {
  final Function(String, String) onAddressSelected;

  const NaverMapApp({Key? key, required this.onAddressSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('주소 검색'),
      ),
      body: FutureBuilder(
        future: _initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return NaverMapView(onAddressSelected: onAddressSelected);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> _initialize() async {
    await NaverMapSdk.instance.initialize(
      clientId: 'msismbjoka',
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"),
    );
  }
}

class NaverMapView extends StatefulWidget {
  final Function(String, String) onAddressSelected;

  const NaverMapView({Key? key, required this.onAddressSelected}) : super(key: key);

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
            options: const NaverMapViewOptions(
              indoorEnable: true,
              locationButtonEnable: false,
              consumeSymbolTapEvents: false,
              zoomGesturesEnable: true,
              scrollGesturesEnable: true,
              initialCameraPosition: NCameraPosition(
                target: NLatLng(35.1107911, 126.8773435),
                zoom: 15,
                bearing: 0,
                tilt: 0,
              ),
              mapType: NMapType.basic,
              activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
            ),
            forceGesture: true,
            onMapReady: (controller) async {
              _mapControllerCompleter.complete(controller);
              log("onMapReady", name: "onMapReady");
              await _setInitialLocation(controller);
            },
            onMapTapped: (point, latLng) {
              log("Map tapped at: $latLng", name: "onMapTapped");
            },
            onCameraChange: (position, reason) {
              log("Camera position changed: $position, reason: $reason", name: "onCameraChange");
            },
            onCameraIdle: () {
              log("Camera idle", name: "onCameraIdle");
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
              const SizedBox(height: 10),
              CupertinoButton(
                onPressed: () => _confirmAddress(context),
                child: const Text('확인'),
                color: CupertinoColors.activeBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _setInitialLocation(NaverMapController controller) async {
    final initialLocation = const NLatLng(35.1107911, 126.8773435);
    final marker = NMarker(
      id: 'smart',
      position: initialLocation,
    );
    await controller.addOverlay(marker);
    final onMarkerInfoWindow = NInfoWindow.onMarker(id: marker.info.id, text: "스마트인재개발원");
    marker.openInfoWindow(onMarkerInfoWindow);

    // Add additional markers
    final List<Map<String, dynamic>> additionalMarkers = [
      {'position': NLatLng(35.1593628, 126.9142959), 'text': '투탑스짐'},
      {'position': NLatLng(35.141383, 126.9183286), 'text': '학동 이지짐'},
      {'position': NLatLng(35.1468586, 126.9146598), 'text': '라도스피트니스'},
      {'position': NLatLng(35.19104402, 126.82716659), 'text': '육체미 첨단점'},
      {'position': NLatLng(35.1552511, 126.9333097), 'text': '머슬헬프'},
      {'position': NLatLng(35.14444787, 126.92930903), 'text': '파워헬스'},
      {'position': NLatLng(35.14358332, 126.90357719), 'text': '뉴스타휘트니스'},
      {'position': NLatLng(35.15144121, 126.90394711), 'text': '가나휘트니스헬스'},
      {'position': NLatLng(35.15716495, 126.91523736), 'text': '필라테스모앳'},
      {'position': NLatLng(35.15627555, 126.91303603), 'text': 'S짐'},
      {'position': NLatLng(35.15669339, 126.91227353), 'text': '영휘트니스존'},
      {'position': NLatLng(35.1498995, 126.92336777), 'text': '쿨헬스클럽'},
    ];

    for (var markerData in additionalMarkers) {
      final additionalMarker = NMarker(
        id: markerData['text'],
        position: markerData['position'],
      );
      await controller.addOverlay(additionalMarker);
      final additionalMarkerInfoWindow = NInfoWindow.onMarker(id: additionalMarker.info.id, text: markerData['text']);
      additionalMarker.openInfoWindow(additionalMarkerInfoWindow);
    }
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

      if (address.isNotEmpty) {
        widget.onAddressSelected(address, buildingName);
        final controller = await _mapControllerCompleter.future;
        final newLocation = await _getLatLngFromAddress(address);

        if (newLocation != null) {
          final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
            target: newLocation,
            zoom: 18,
          );

          await controller.updateCamera(cameraUpdate);

          final newMarker = NMarker(id: 'newLocation', position: newLocation);
          await controller.addOverlay(newMarker);
        }
      }
    }
  }

  Future<void> _confirmAddress(BuildContext context) async {
    if (_addressController.text.isNotEmpty) {
      widget.onAddressSelected(_addressController.text, _addressDetailController.text);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('주소를 입력하세요'),
          actions: [
            CupertinoDialogAction(
              child: Text('확인'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Future<NLatLng?> _getLatLngFromAddress(String address) async {
    final url = Uri.parse('https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode');
    final response = await http.get(
      url.replace(queryParameters: {'query': address}),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': 'msismbjoka',
        'X-NCP-APIGW-API-KEY': 'OF97NFSHBRZG8HmeGGsklyAkzSTjgUG9b0lSDl91',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['addresses'] != null && data['addresses'].isNotEmpty) {
        final lat = double.parse(data['addresses'][0]['y']);
        final lng = double.parse(data['addresses'][0]['x']);
        return NLatLng(lat, lng);
      }
    }

    return null;
  }
}
