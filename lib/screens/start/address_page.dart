import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/keys.dart';
import '../../data/address_model_location.dart';
import '../../data/address_model_search.dart';
import '../../repo/address_service.dart';
import 'package:location/location.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController _addressController = TextEditingController();

  AddressModelForSearch? _addressModelForSearch;
  final List<AddressModelForLocation> _addressModelForLocationList = [];
  bool _isGettingLocation = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _addressSearchTextField(),
          _getcurrentAddressButton(),
          if(_addressModelForSearch != null)
          _listViewForTextField(),
          if(_addressModelForLocationList.isNotEmpty)
            _listViewForButton(),
        ],
      ),
    );
  }


  Expanded _listViewForButton() {
    return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) {
                if (_addressModelForLocationList[index].result == null ||
                    _addressModelForLocationList[index].result!.isEmpty) {
                  return Container();
                }
                return ListTile(
                  onTap: (){
                    _saveAddressAndGoToNextPage(_addressModelForLocationList[index].result![0].text??'',
                        double.parse(_addressModelForLocationList[index].input!.point!.y ?? '0'),
                        double.parse(_addressModelForLocationList[index].input!.point!.x ?? '0'));
                  },
                  title: Text(_addressModelForLocationList[index].result![0].text ??
                      ''),
                  subtitle: Text(_addressModelForLocationList[index].result![0].zipcode ??
                      ''),
                );
              },
              itemCount: _addressModelForLocationList.length,
            ),
          );
  }

  Expanded _listViewForTextField() {
    return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemBuilder: (context, index) {
              if (_addressModelForSearch == null ||
                  _addressModelForSearch!.result == null ||
                  _addressModelForSearch!.result!.items == null ||
                  _addressModelForSearch!.result!.items![index].address ==
                      null) {
                return Container();
              }
              return ListTile(
                onTap: (){
                  _saveAddressAndGoToNextPage(_addressModelForSearch!
                      .result!.items![index].address!.road??'',
                      double.parse(_addressModelForSearch!
                          .result!.items![index].point!.y ?? '0'),
                      double.parse(_addressModelForSearch!
                          .result!.items![index].point!.x ?? '0'));
                },
                title: Text(_addressModelForSearch!
                        .result!.items![index].address!.road ??
                    ''),
                subtitle: Text(_addressModelForSearch!
                        .result!.items![index].address!.parcel ??
                    ''),
              );
            },
            itemCount: (_addressModelForSearch == null ||
                    _addressModelForSearch!.result == null ||
                    _addressModelForSearch!.result!.items == null)
                ? 0
                : _addressModelForSearch!.result!.items!.length,
          ),
        );
  }

  TextButton _getcurrentAddressButton() {
    return TextButton.icon(
          onPressed: () async {
            _addressModelForSearch = null;
            _addressModelForLocationList.clear();
            setState(() {
              _isGettingLocation = true;
            });
            Location location = Location();

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

            _addressModelForLocationList.addAll(await AddressService()
                .findAddressByCoordinate(
                    log: _locationData.longitude!,
                    lat: _locationData.latitude!));

            setState(() {
              _isGettingLocation = false;
            });
          },
          icon: _isGettingLocation
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
              : const Icon(
                  CupertinoIcons.compass,
                  size: 20,
                ),
          label: Text(_isGettingLocation ? '위치 찾는 중...' : '현재 위치 찾기'),
          style: TextButton.styleFrom(
              // minimumSize: Size(10,50)
              ),
        );
  }

  TextFormField _addressSearchTextField() {
    return TextFormField(
          controller: _addressController,
          onFieldSubmitted: (text) async {
            //사용자가 키보드 완료를 눌러야만 작동
            _addressModelForLocationList.clear();
            final text = _addressController.text;
            _addressModelForSearch =
                await AddressService().searchAddressBystr(text);
            setState(() {});
          },
          decoration: const InputDecoration(
            hintText: '도로명으로 검색',
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            prefixIconConstraints:
                BoxConstraints(minWidth: 25, minHeight: 25),
          ),
        );
  }

  _saveAddressAndGoToNextPage(String address, double lat, double lon) async{
    await _saveAddressOnSharedPreference(address,lat,lon);

    context.read<PageController>().animateToPage(2,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease);
  }

  _saveAddressOnSharedPreference(String address, double lat, double lon)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SHARED_ADDRESS, address);
    await prefs.setDouble(SHARED_LAT, lat);
    await prefs.setDouble(SHARED_LON, lon);
  }

}
