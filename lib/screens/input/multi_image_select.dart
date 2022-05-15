import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MultiImageSelect extends StatefulWidget {
  const MultiImageSelect({
    Key? key,
  }) : super(key: key);

  @override
  State<MultiImageSelect> createState() => _MultiImageSelectState();
}

class _MultiImageSelectState extends State<MultiImageSelect> {

  List<Uint8List> _images = [];
  bool _isPickingImages = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        return SizedBox(
          height: size.width / 3,
          width: size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: ()async{
                    _isPickingImages = true;
                    setState(() {

                    });
                    final ImagePicker _picker = ImagePicker();
                    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 10);
                    if(images !=null && images.isNotEmpty){
                      _images.clear();
                      images.forEach((xFile) async{
                        _images.add(await xFile.readAsBytes());
                      });
                      _isPickingImages = false;
                      setState(() {

                      });
                    }
                  },
                  child: Container(
                    width: (size.width / 3) - 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: _isPickingImages? Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: CircularProgressIndicator(),
                    ):Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.grey,
                        ),
                        Text(
                          '0/10',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ...List.generate(
                  _images.length,
                  (index) => Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10,bottom: 10, right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: (size.width / 3) - 20,
                            height: (size.width / 3) - 20,
                            child: Image.memory(_images[index],
                              fit: BoxFit.cover,),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0, top: 0,width: 35,height: 35,
                        child: IconButton(
                          iconSize: 35,
                          padding: EdgeInsets.zero,
                            onPressed: (){
                            _images.removeAt(index);
                            setState(() {

                            });
                            }, icon: Icon(Icons.remove_circle,
                        color: Colors.black54,)),
                      )
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }
}
