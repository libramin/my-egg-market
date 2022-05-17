import 'package:dio/dio.dart';
import 'package:my_egg_market/data/addressModel.dart';
import 'package:my_egg_market/data/nowAddressModel.dart';

const VWORLD_KEY = '7CD43C88-9AF7-36AF-B0F8-E87EAE0A85F4';

class AdderessService {
  Future<SearchAddressModel> searchAddressBystr(String text) async {
    final formData = {
      'key': VWORLD_KEY,
      'request': 'search',
      'type': 'ADDRESS',
      'category': 'ROAD',
      'query': text,
      'size': 30
    };

    final response = await Dio()
        .get('http://api.vworld.kr/req/search', queryParameters: formData)
        .catchError((e) {
      print(e.error);
    });
    SearchAddressModel addressModel = SearchAddressModel.fromJson(response.data['response']);
    return addressModel;
  }

  Future<List<NowAddressModel>> findAddressByCoordinate({required double log, required double lat}) async{

    final List<Map<String, dynamic>> formDatas = <Map<String, dynamic>> [];

    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '$log,$lat',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '${log+0.01},$lat',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '${log-0.01},$lat',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '${log},${lat+0.01}',
    });
    formDatas.add({
      'key': VWORLD_KEY,
      'service': 'address',
      'request': 'GetAddress',
      'type': 'PARCEL',
      'point': '${log},${lat-0.01}',
    });

    List<NowAddressModel> addresses = [];

    for(Map<String, dynamic> formData in formDatas){
      final response = await Dio()
          .get('http://api.vworld.kr/req/address', queryParameters: formData)
          .catchError((e) {
        print(e.error);
      });
      NowAddressModel nowAddressModel = NowAddressModel.fromJson(response.data['response']);

      if(response.data['response']['status'] =='OK') addresses.add(nowAddressModel);
    }

    return addresses;
  }

}
