import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../data/address_model_location.dart';
import '../data/address_model_search.dart';

const VWORLD_KEY = '7CD43C88-9AF7-36AF-B0F8-E87EAE0A85F4'; //2022-11-06

class AddressService {
  Future<AddressModelForSearch> searchAddressBystr(String text) async {
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
      if (kDebugMode) {
        print(e.error);
      }
    });
    AddressModelForSearch addressModel = AddressModelForSearch.fromJson(response.data['response']);
    return addressModel;
  }

  Future<List<AddressModelForLocation>> findAddressByCoordinate({required double log, required double lat}) async{

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

    List<AddressModelForLocation> addresses = [];

    for(Map<String, dynamic> formData in formDatas){
      final response = await Dio()
          .get('http://api.vworld.kr/req/address', queryParameters: formData)
          .catchError((e) {
        if (kDebugMode) {
          print(e.error);
        }
      });
      AddressModelForLocation nowAddressModel = AddressModelForLocation.fromJson(response.data['response']);

      if(response.data['response']['status'] =='OK') addresses.add(nowAddressModel);
    }

    return addresses;
  }

}
