import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_egg_market/states/select_image_notifier.dart';
import 'package:provider/provider.dart';

class MultiImageSelect extends StatefulWidget {
  const MultiImageSelect({
    Key? key,
  }) : super(key: key);

  @override
  State<MultiImageSelect> createState() => _MultiImageSelectState();
}

class _MultiImageSelectState extends State<MultiImageSelect> {
  bool _isPickingImages = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SelectImageNotifier selectImageNotifier = context.watch<SelectImageNotifier>();

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
                    setState(() { });
                    final ImagePicker _picker = ImagePicker();
                    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 10);
                    if(images !=null && images.isNotEmpty){
                      await context.read<SelectImageNotifier>().setNewImages(images);

                      _isPickingImages = false;
                      setState(() { });
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
                  selectImageNotifier.images.length,
                  (index) => Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10,bottom: 10, right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: (size.width / 3) - 20,
                            height: (size.width / 3) - 20,
                            child: Image.memory(selectImageNotifier.images[index],
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
                            selectImageNotifier.removeImage(index);
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
