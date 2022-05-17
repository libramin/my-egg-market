import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/data/addressModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/keys.dart';
import '../../data/nowAddressModel.dart';
import 'address_service.dart';
import 'package:location/location.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController _addressController = TextEditingController();

  SearchAddressModel? _searchAddressModel;
  List<NowAddressModel> _nowAddresses = [];
  bool _isGettingLocation = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _addressController,
            onFieldSubmitted: (text) async {
              //사용자가 키보드 완료를 눌러야만 작동
              _nowAddresses.clear();
              final text = _addressController.text;
              _searchAddressModel =
                  await AdderessService().searchAddressBystr(text);
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: '도로명으로 검색',
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              prefixIconConstraints:
                  BoxConstraints(minWidth: 25, minHeight: 25),
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              _searchAddressModel = null;
              _nowAddresses.clear();
              setState(() {
                _isGettingLocation = true;
              });
              Location location = new Location();

              bool _serviceEnabled;
              PermissionStatus _permissionGranted;
              LocationData _locationData;

              _serviceEnabled = await location.serviceEnabled();
              if (!_serviceEnabled) {
                _serviceEnabled = await location.requestService();
                if (!_serviceEnabled) {
                  return;
                }
              }

              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.denied) {
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  return;
                }
              }
              _locationData = await location.getLocation();

              _nowAddresses.addAll(await AdderessService()
                  .findAddressByCoordinate(
                      log: _locationData.longitude!,
                      lat: _locationData.latitude!));

              setState(() {
                _isGettingLocation = false;
              });
            },
            icon: _isGettingLocation
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                : Icon(
                    CupertinoIcons.compass,
                    size: 20,
                  ),
            label: Text(_isGettingLocation ? '위치 찾는 중...' : '현재 위치 찾기'),
            style: TextButton.styleFrom(
                // minimumSize: Size(10,50)
                ),
          ),
          if(_searchAddressModel != null)
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) {
                if (_searchAddressModel == null ||
                    _searchAddressModel!.result == null ||
                    _searchAddressModel!.result!.items == null ||
                    _searchAddressModel!.result!.items![index].address ==
                        null) {
                  return Container();
                }
                return ListTile(
                  onTap: (){
                    _saveAddressAndGoToNextPage(_searchAddressModel!
                        .result!.items![index].address!.road??'',
                        double.parse(_searchAddressModel!
                            .result!.items![index].point!.y ?? '0'),
                        double.parse(_searchAddressModel!
                            .result!.items![index].point!.x ?? '0'));
                  },
                  title: Text(_searchAddressModel!
                          .result!.items![index].address!.road ??
                      ''),
                  subtitle: Text(_searchAddressModel!
                          .result!.items![index].address!.parcel ??
                      ''),
                );
              },
              itemCount: (_searchAddressModel == null ||
                      _searchAddressModel!.result == null ||
                      _searchAddressModel!.result!.items == null)
                  ? 0
                  : _searchAddressModel!.result!.items!.length,
            ),
          ),
          if(_nowAddresses.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (context, index) {
                  if (_nowAddresses[index].result == null ||
                      _nowAddresses[index].result!.isEmpty) {
                    return Container();
                  }
                  return ListTile(
                    onTap: (){
                      _saveAddressAndGoToNextPage(_nowAddresses[index].result![0].text??'',
                          double.parse(_nowAddresses[index].input!.point!.y ?? '0'),
                          double.parse(_nowAddresses[index].input!.point!.x ?? '0'));
                    },
                    title: Text(_nowAddresses[index].result![0].text ??
                        ''),
                    subtitle: Text(_nowAddresses[index].result![0].zipcode ??
                        ''),
                  );
                },
                itemCount: _nowAddresses.length,
              ),
            ),
        ],
      ),
    );
  }

  _saveAddressAndGoToNextPage(String address, double lat, double lon) async{
    await _saveAddressOnSharedPreference(address,lat,lon);

    context.read<PageController>().animateToPage(2,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease);
  }

  _saveAddressOnSharedPreference(String address, double lat, double lon)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SHARED_ADDRESS, address);
    await prefs.setDouble(SHARED_LAT, lat);
    await prefs.setDouble(SHARED_LON, lon);
  }

}
