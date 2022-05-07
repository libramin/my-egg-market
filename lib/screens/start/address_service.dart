import 'package:dio/dio.dart';
import 'package:my_egg_market/data/AddressModel.dart';

const VWORLD_KEY = '7CD43C88-9AF7-36AF-B0F8-E87EAE0A85F4';

class AdderessService {
  Future<AddressModel> searchAddressBystr(String text) async {
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
    AddressModel addressModel = AddressModel.fromJson(response.data['response']);
    return addressModel;
  }
}
