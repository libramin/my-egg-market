import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_egg_market/data/AddressModel.dart';
import 'address_service.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController _addressController = TextEditingController();

  AddressModel? _addressModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _addressController,
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
            onPressed: () async{
              FocusScope.of(context).unfocus();
              final text = _addressController.text;
              _addressModel = await AdderessService().searchAddressBystr(text);
              setState(() {

              });
            },
            icon: Icon(
              CupertinoIcons.compass,
              size: 20,
            ),
            label: Text('현재 위치 찾기'),
            style: TextButton.styleFrom(
                // minimumSize: Size(10,50)
                ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, index) {
                if (_addressModel == null ||
                    _addressModel!.result == null ||
                    _addressModel!.result!.items == null ||
                    _addressModel!.result!.items![index].address == null) {
                  return Container();
                }
                return ListTile(
                  title: Text(
                      _addressModel!.result!.items![index].address!.road??''),
                  subtitle: Text(
                      _addressModel!.result!.items![index].address!.parcel??''),
                );
              },
              itemCount: (_addressModel == null ||
                      _addressModel!.result == null ||
                      _addressModel!.result!.items == null)
                  ? 0
                  : _addressModel!.result!.items!.length,
            ),
          )
        ],
      ),
    );
  }
}
